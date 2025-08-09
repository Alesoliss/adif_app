// lib/presentation/Buy-Sell/list/buysell_controller.dart
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:edu_app/models/buy-sell.dart';
import 'package:edu_app/models/buy-sell-details.dart';
import 'package:edu_app/services/services.dart';
import 'package:edu_app/services/buySellService.dart';

final _fmtLps = NumberFormat.currency(locale: 'es_HN', symbol: 'LPS ', decimalDigits: 2);

// Estados para filtrar en UI
enum BuyFiltroEstado { todos, anuladas, pagadas, credito }

// Badge/estado visual calculado por registro
enum BuyEstadoVisual { anulada, pagada, credito }

class BuySellController extends GetxController {
  final buySell = <BuySell>[].obs;
  final loading = false.obs;

  // filtros UI
  final estadoFiltro = BuyFiltroEstado.todos.obs;               // anuladas/pagadas/credito/todos
  final rangoPrecioFiltro = const RangeValues(0, 100000).obs;   // total

  final _service = BuySellService();

  @override
  void onInit() {
    super.onInit();
    loadBuySells();
  }

  Future<void> loadBuySells() async {
    try {
      loading.value = true;
      final data = await _service.getAllBuySell();
      buySell.value = data;
    } finally {
      loading.value = false;
    }
  }

  // ------------------------ Helpers de estado/booleans ------------------------
  bool _asBool(dynamic v) => v == true || v == 1 || v == '1';

  BuyEstadoVisual calcularEstadoVisual(BuySell b) {
    final esAnulada = (b.estado == 0 || b.estado == '0' || b.estado == false);
    if (esAnulada) return BuyEstadoVisual.anulada;

    if (_asBool(b.esCredito) && (b.saldo ?? 0) > 0) return BuyEstadoVisual.credito;
    return BuyEstadoVisual.pagada;
  }

  // Método de pago
  String metodoLabel(BuySell b) {
    switch (b.metodo) {
      case 1: return 'Efectivo';
      case 2: return 'Transferencia';
      default: return ''; // vacío si no aplica o no viene (compras o créditos)
    }
  }
  IconData metodoIcon(BuySell b) {
    switch (b.metodo) {
      case 1: return Icons.attach_money_rounded;
      case 2: return Icons.swap_horiz;
      default: return Icons.payments_outlined;
    }
  }

  // ------------------------ Filtro + orden ------------------------
  List<BuySell> filtrarYOrdenar({
    required bool esCompra,
    required String search,
  }) {
    final s = search.trim().toLowerCase();

    final filtrados = buySell.where((b) {
      // 1) compra/venta
      if (_asBool(b.esCompra) != esCompra) return false;

      // 2) búsqueda por socio
      if (s.isNotEmpty && !(b.socios ?? '').toLowerCase().contains(s)) return false;

      // 3) estado
      final ev = calcularEstadoVisual(b);
      final matchEstado = switch (estadoFiltro.value) {
        BuyFiltroEstado.todos     => true,
        BuyFiltroEstado.anuladas  => ev == BuyEstadoVisual.anulada,
        BuyFiltroEstado.pagadas   => ev == BuyEstadoVisual.pagada,
        BuyFiltroEstado.credito   => ev == BuyEstadoVisual.credito,
      };
      if (!matchEstado) return false;

      // 4) rango totales
      final total = b.total ?? 0;
      final rv = rangoPrecioFiltro.value;
      if (total < rv.start || total > rv.end) return false;

      return true;
    }).toList();

    // ORDEN: 1) créditos con saldo>0, 2) fecha desc, 3) id desc
    filtrados.sort((a, b) {
      final prioA = (_asBool(a.esCredito) && (a.saldo ?? 0) > 0) ? 0 : 1;
      final prioB = (_asBool(b.esCredito) && (b.saldo ?? 0) > 0) ? 0 : 1;
      if (prioA != prioB) return prioA - prioB;

      final fa = DateTime.tryParse(a.fecha ?? '') ?? DateTime(1900);
      final fb = DateTime.tryParse(b.fecha ?? '') ?? DateTime(1900);
      final byFecha = fb.compareTo(fa);
      if (byFecha != 0) return byFecha;

      return (b.id ?? 0).compareTo(a.id ?? 0);
    });

    return filtrados;
  }

  // ------------------------ ABONAR (créditos) ------------------------
  Future<void> showAbonarDialog(BuildContext context, BuySell b) async {
    final saldo = (b.saldo ?? 0).toDouble();
    if (saldo <= 0) {
      Get.snackbar('Sin saldo', 'Este documento no tiene saldo pendiente',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final tc = TextEditingController(text: saldo.toStringAsFixed(2));
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Abonar a crédito'),
        content: StatefulBuilder(
          builder: (_, setSt) {
            final monto = double.tryParse(tc.text) ?? 0;
            final invalido = (monto <= 0) || (monto > saldo);
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('Saldo actual:'),
                    const Spacer(),
                    Text(_fmtLps.format(saldo),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tc,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Monto a abonar',
                  ),
                  onChanged: (_) => setSt(() {}),
                ),
                if (invalido) ...[
                  const SizedBox(height: 8),
                  const Text('Monto inválido',
                      style: TextStyle(color: Colors.red)),
                ],
              ],
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirmar')),
        ],
      ),
    );

    if (ok != true) return;

    final monto = double.tryParse(tc.text) ?? 0;
    if (monto <= 0 || monto > saldo) return;

    await _aplicarAbono(b, monto);
    Get.snackbar('Abono aplicado', 'Nuevo saldo: ${_fmtLps.format(max(0, saldo - monto))}',
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> _aplicarAbono(BuySell b, double monto) async {
    final db = await DatabaseHelper.initDB();
    final isCompra = _asBool(b.esCompra);
    final tabla = isCompra ? ServiceStrings.compras : ServiceStrings.ventas;

    // Leer saldo actual por seguridad
    final row = (await db.query(
      tabla,
      columns: ['saldo'],
      where: 'id = ?',
      whereArgs: [b.id],
      limit: 1,
    ));
    final saldoDb = row.isNotEmpty ? (row.first['saldo'] as num).toDouble() : (b.saldo ?? 0);
    final nuevoSaldo = max(0.0, saldoDb - monto);

    await db.update(
      tabla,
      {
        'saldo': nuevoSaldo,
        // 'estado': 1, // lo puedes dejar tal cual; estado 1 = activo
      },
      where: 'id = ?',
      whereArgs: [b.id],
    );

    // Actualizar en memoria
    final idx = buySell.indexWhere((x) => x.id == b.id && _asBool(x.esCompra) == isCompra);
    if (idx != -1) {
      final actualizado = BuySell(
        id: b.id,
        sociosId: b.sociosId,
        socios: b.socios ?? '',
        fecha: b.fecha ?? '',
        fechaVence: b.fechaVence,
        total: b.total ?? 0,
        esCredito: b.esCredito,
        saldo: nuevoSaldo,
        comentario: b.comentario,
        esCompra: b.esCompra,
        estado: b.estado,
        metodo: b.metodo,
        detalles: b.detalles ?? const [],
      );
      buySell[idx] = actualizado;
    }
  }

  // ------------------------ Comentario ------------------------
  Future<void> showComentarioDialog(BuildContext context, BuySell b) async {
    final tc = TextEditingController(text: b.comentario ?? '');

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Comentario'),
        content: TextField(
          controller: tc,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Escribe el comentario…',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Guardar')),
        ],
      ),
    );

    if (ok == true) {
      await _actualizarComentario(b, tc.text.trim());
      Get.snackbar('Comentario', 'Guardado correctamente',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _actualizarComentario(BuySell b, String comentario) async {
    final db = await DatabaseHelper.initDB();
    final isCompra = _asBool(b.esCompra);
    final tabla = isCompra ? ServiceStrings.compras : ServiceStrings.ventas;

    await db.update(
      tabla,
      {'comentario': comentario},
      where: 'id = ?',
      whereArgs: [b.id],
    );

    // Actualizar en memoria
    final idx = buySell.indexWhere((x) => x.id == b.id && _asBool(x.esCompra) == isCompra);
    if (idx != -1) {
      final actualizado = BuySell(
        id: b.id,
        sociosId: b.sociosId,
        socios: b.socios ?? '',
        fecha: b.fecha ?? '',
        fechaVence: b.fechaVence,
        total: b.total ?? 0,
        esCredito: b.esCredito,
        saldo: b.saldo ?? 0,
        comentario: comentario,
        esCompra: b.esCompra,
        estado: b.estado,
        metodo: b.metodo,
        detalles: b.detalles ?? const [],
      );
      buySell[idx] = actualizado;
    }
  }

  // ------------------------ Detalles de la venta/compra ------------------------
  Future<List<BuySellDetalleModel>> cargarDetalles(BuySell b) async {
    final db = await DatabaseHelper.initDB();
    final isCompra = _asBool(b.esCompra);

    final tablaDet = isCompra
        ? ServiceStrings.comprasDetalles
        : ServiceStrings.ventasDetalles;

    final idCampo = isCompra ? 'compraId' : 'ventaId';

    final rows = await db.query(
      tablaDet,
      where: '$idCampo = ?',
      whereArgs: [b.id],
      orderBy: 'linea ASC',
    );

    return rows.map((r) {
      return BuySellDetalleModel(
        ventaId: r[idCampo] as int,
        linea: (r['linea'] as num).toInt(),
        productoId: (r['productoId'] as num).toInt(),
        precio: (r['precio'] as num).toDouble(),
        cantidad: (r['cantidad'] as num).toDouble(),
        factor: (r['factor'] as num).toDouble(),
        total: (r['total'] as num).toDouble(),
      );
    }).toList();
  }
}
