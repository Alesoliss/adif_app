// lib/presentation/buy_sell/add/buysell_add_controller.dart
import 'package:edu_app/presentation/products/list/products_controller.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:edu_app/models/buy-sell-details.dart';
import 'package:edu_app/models/buy-sell.dart';
import 'package:edu_app/models/product_model.dart';
import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/services/services.dart';
import 'package:edu_app/services/buySellService.dart';
import 'package:edu_app/services/partnerService.dart';

enum PaymentType { contado, credito }
enum PaymentMethod { efectivo, tarjeta, transferencia }

class BuySellAddController extends GetxController {
  BuySellAddController({required bool esCompra, int? id}) {
    this.esCompra.value = esCompra;
    if (id != null) this.id.value = id;
  }

  // ---------------- Modo ----------------
  final esCompra = false.obs;
  final id = RxnInt(); // null cuando es nuevo

  // ---------------- Campos --------------
  final socio = TextEditingController();
  final producto = TextEditingController();
  final fecha = TextEditingController();

  final detalles = <BuySellDetails>[].obs;
  final nombreInvalido = false.obs;
  final pago = PaymentType.contado.obs;

  // Método de pago (solo aplica para ventas al contado)
  final metodo = Rxn<PaymentMethod>();
  double? montoRecibido; // para efectivo

  // ---------------- Internos ------------
  final PartnerService _partnerService = PartnerService();
  DateTime? _fechaVencimiento;
  int? socioId;
  int? socioFinalId;
  String? socioFinalNombre;

  double get totalActual =>
      detalles.fold<double>(0, (s, d) => s + d.total);

  // =================== CICLO DE VIDA =================== //
  @override
  void onInit() {
    super.onInit();

    // Leer argumentos
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    esCompra.value = args['esCompra'] ?? false;
    id.value = args['id'];

    _init();
  }

  @override
  void onClose() {
    socio.dispose();
    producto.dispose();
    fecha.dispose();
    super.onClose();
  }

  // =================== INIT ============================= //
  Future<void> _init() async {
    if (id.value == null) {
      await _setDefaultPartner();
      // Compra al contado por defecto -> efectivo
      if (esCompra.isTrue && pago.value == PaymentType.contado) {
        metodo.value = PaymentMethod.efectivo;
      }
    } else {
      // TODO: cargar para edición
    }
  }

  Future<void> _setDefaultPartner() async {
    final defaultName = esCompra.isTrue ? 'Proveedor Final' : 'Consumidor Final';
    final partner = await _partnerService.getFinalPartner(defaultName);

    socioFinalId = partner?.id;
    socioFinalNombre = partner?.nombre;

    if (partner != null) {
      setPartner(partner);
    } else {
      Get.log("⚠️ '$defaultName' no existe en BD");
    }
  }

  // =================== PARTNER ========================== //
  void setPartner(PartnerModel partner) {
    socioId = partner.id;
    socio.text = partner.nombre;
    nombreInvalido.value = false;
  }

  void setPartnerSeleccionado(PartnerModel p) => setPartner(p);

  // =================== PRODUCTO ========================= //
  void setProductoSeleccionado(ProductoModel p) {
    double precio = 0;
    if (esCompra.isTrue && (p.costo ?? 0) != 0) {
      precio = p.costo ?? 0;
    } else if ((p.precio) != 0) {
      precio = p.precio;
    }

    addEmptyDetalle(
      productoId: p.id ?? 0,
      productoNombre: p.nombre,
      productoprecio: precio,
    );
  }

  Future<void> saveProducto() async {
    final nombre = producto.text.trim();
    if (nombre.isEmpty) return;

    final nuevo = ProductoModel(
      nombre: nombre,
      precio: 0,
      costo: 0,
      stock: 0,
      cateid: 0,
      notas: '',
      esServicio: false,
    );

    final newId = await DatabaseHelper.insert(
      ServiceStrings.productos,
      nuevo.toJson(),
    );

    if (Get.isRegistered<ProductsController>()) {
      final pc = Get.find<ProductsController>();
      await pc.loadProductos();
    }

    addEmptyDetalle(productoId: newId, productoNombre: nuevo.nombre);
    producto.clear();
  }

  // =================== DETALLES ========================= //
  void addEmptyDetalle({
    required int productoId,
    required String productoNombre,
    double? productoprecio,
  }) {
    detalles.add(
      BuySellDetails(
        productoId: productoId,
        productoNombre: productoNombre,
        precio: productoprecio ?? 0,
      ),
    );
  }

  void updateDetalle({
    required int index,
    double? precio,
    double? cantidad,
    double? factor,
  }) {
    final d = detalles[index];
    if (precio != null) d.precio = precio;
    if (cantidad != null) d.cantidad = cantidad;
    if (factor != null) d.factor = factor;
    d.recalcular();
    detalles[index] = d; // trigger
  }

  void incrementQuantity(int index) {
    detalles[index].cantidad++;
    detalles[index].recalcular();
    detalles.refresh();
  }

  void decrementQuantity(int index) {
    final d = detalles[index];
    d.cantidad--;
    if (d.cantidad < 1) {
      detalles.removeAt(index);
    } else {
      d.recalcular();
      detalles[index] = d;
    }
  }

  // =================== PAGO / FECHA ===================== //
  bool get fechaInvalida {
    if (pago.value != PaymentType.credito) return false;
    if (_fechaVencimiento == null) return true;
    final hoy = DateTime.now();
    final hoyLimite = DateTime(hoy.year, hoy.month, hoy.day);
    return _fechaVencimiento!.isBefore(hoyLimite);
  }

  void setPaymentType(PaymentType p) {
    pago.value = p;
    if (p == PaymentType.credito) {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      _fechaVencimiento = tomorrow;
      fecha.text = DateFormat('yyyy-MM-dd').format(tomorrow);
      metodo.value = null; // en crédito no aplica método
      montoRecibido = null;
    } else {
      _fechaVencimiento = null;
      fecha.clear();
      // contado: compra -> efectivo por defecto; venta -> esperar elección
      metodo.value = esCompra.isTrue ? PaymentMethod.efectivo : null;
      montoRecibido = null;
    }
  }

  Future<void> pickFechaVencimientoAlt(BuildContext context) async {
    final hoy = DateTime.now();
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(hoy.year, hoy.month, hoy.day),
      maxTime: DateTime(hoy.year + 5),
      currentTime: _fechaVencimiento ?? hoy,
      locale: LocaleType.es,
      onConfirm: (date) {
        _fechaVencimiento = date;
        fecha.text = DateFormat('yyyy-MM-dd').format(date);
      },
    );
  }

  // ======= Método de pago (ventas al contado) ======= //
  Future<void> pickMetodoPago(BuildContext ctx) async {
  final value = await Get.bottomSheet<PaymentMethod>(
    SafeArea(
      child: Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const Text('Método de pago', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              leading: const Icon(Icons.attach_money_rounded),
              title: const Text('Efectivo'),
              trailing: metodo.value == PaymentMethod.efectivo ? const Icon(Icons.check) : null,
              onTap: () => Get.back(result: PaymentMethod.efectivo),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Transferencia'),
              trailing: metodo.value == PaymentMethod.transferencia ? const Icon(Icons.check) : null,
              onTap: () => Get.back(result: PaymentMethod.transferencia),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
  );

  if (value == null) return;
  metodo.value = value;

  if (value == PaymentMethod.efectivo) {
    final ok = await _dialogCobroEfectivo(ctx);
    if (!ok) metodo.value = null;
  } else {
    montoRecibido = null;
  }
}


  Future<bool> _dialogCobroEfectivo(BuildContext context) async {
    final tc = TextEditingController(text: totalActual.toStringAsFixed(2));
    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Cobro en efectivo'),
          content: StatefulBuilder(
            builder: (_, setSt) {
              final recibido = double.tryParse(tc.text) ?? 0;
              final cambio = (recibido - totalActual);
              final insuficiente = recibido < totalActual;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text('Total:'),
                      const Spacer(),
                      Text('L ${totalActual.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tc,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Monto recibido',
                    ),
                    onChanged: (_) => setSt(() {}),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Cambio:'),
                      const Spacer(),
                      Text('L ${cambio < 0 ? 0 : cambio.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  if (insuficiente) ...[
                    const SizedBox(height: 8),
                    const Text('El monto recibido es menor al total.',
                        style: TextStyle(color: Colors.red)),
                  ],
                ],
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final recibido = double.tryParse(tc.text) ?? 0;
      if (recibido < totalActual) return false;
      montoRecibido = recibido;
      return true;
    }
    return false;
  }

  // =================== CRUD  ============================ //
  Future<void> validateAndSave() async {
    // validaciones básicas
    nombreInvalido.value = socio.text.trim().isEmpty;
    if (nombreInvalido.isTrue) return;
    if (detalles.isEmpty) return;

    // Si cambió el nombre del “Final” → guardar socio nuevo
    if (socioId == socioFinalId && socio.text != socioFinalNombre) {
      await _saveSocio();
    }

    // Reglas de pago
    if (pago.value == PaymentType.credito) {
      // método no aplica
      metodo.value = null;
      if (_fechaVencimiento == null) {
        Get.snackbar('Fecha requerida', 'Selecciona fecha de vencimiento',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
    } else {
      // CONTADO
      if (esCompra.isTrue) {
        metodo.value ??= PaymentMethod.efectivo;
      } else {
        // Venta al contado: pedir método si no hay
        if (metodo.value == null) {
          await pickMetodoPago(Get.context!);
          if (metodo.value == null) return; // canceló
        }
        // Si efectivo, asegurar cobro
        if (metodo.value == PaymentMethod.efectivo && montoRecibido == null) {
          final ok = await _dialogCobroEfectivo(Get.context!);
          if (!ok) return;
        }
      }
    }

    // construir detalles
    final listaDetalles = detalles.asMap().entries.map((e) {
      final d = e.value;
      return BuySellDetalleModel(
        ventaId: 0,
        linea: e.key + 1,
        productoId: d.productoId,
        precio: d.precio,
        cantidad: d.cantidad,
        factor: d.factor,
        total: d.total,
      );
    }).toList();

    final total = totalActual;

    final cabecera = BuySell(
      sociosId: socioId!,
      fecha: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      fechaVence: _fechaVencimiento != null
          ? DateFormat('yyyy-MM-dd').format(_fechaVencimiento!)
          : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      total: total,
      esCredito: pago.value == PaymentType.credito,
      saldo: pago.value == PaymentType.credito ? total : 0,
      comentario: '',
      esCompra: esCompra.value,
      metodo: _metodoToInt(metodo.value),
      detalles: listaDetalles,
    );

    try {
      if (esCompra.isTrue) {
        await BuySellService.saveCompra(cabecera);
      } else {
        await BuySellService.saveVenta(cabecera);
        // Si quieres registrar caja cuando efectivo:
        // if (pago.value == PaymentType.contado && metodo.value == PaymentMethod.efectivo) {
        //   await CajaService.registrarIngresoEfectivo(montoRecibido!, total);
        // }
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> _saveSocio() async {
    final partner = PartnerModel(
      nombre: socio.text.trim(),
      esProveedor: esCompra.isTrue,
    );
    socioId = await DatabaseHelper.insert(
      ServiceStrings.socios,
      partner.toJson(),
    );
  }

  // =================== Helpers ========================= //
  int? _metodoToInt(PaymentMethod? m) {
    switch (m) {
      case PaymentMethod.efectivo:
        return 1;
      case PaymentMethod.tarjeta:
        return 2;
      case PaymentMethod.transferencia:
        return 3;
      default:
        return null;
    }
  }

  Future<void> resetAll() async {
  // Limpieza de campos
  socio.clear();
  socioId = null;

  producto.clear();
  detalles.clear();           // -> totalActual se vuelve 0 automáticamente
  fecha.clear();
  _fechaVencimiento = null;   // -> hará que fechaInvalida sea false al estar en contado

  // Estado de pago
  pago.value = PaymentType.contado;
  metodo.value = esCompra.isTrue ? PaymentMethod.efectivo : null; // compra contado = efectivo
  montoRecibido = null;

  // Validaciones UI
  nombreInvalido.value = false;

  // Reasignar el socio "Final" por defecto
  await _setDefaultPartner();

  update();
}
}
