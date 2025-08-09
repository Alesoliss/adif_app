import 'package:edu_app/models/buy-sell.dart';
import 'package:edu_app/models/category_model.dart';
import 'package:edu_app/models/product_model.dart';
import 'package:edu_app/presentation/Buy-Sell/list/buysell_screen.dart';
import 'package:edu_app/services/buySellService.dart';
import 'package:edu_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
enum BuyTipo { todos, compras, ventas }
enum BuyTipoPago { todos, anulados, pagados, credito,  }
class BuySellController extends GetxController {
  final buySell = <BuySell>[].obs;
  final loading = false.obs;

  // filtros
  final tipoFiltro = BuyTipo.todos.obs;                 // compras/ventas/todos
  final estadoFiltro = BuyFiltroEstado.todos.obs;       // anuladas/pagadas/credito
  final rangoPrecioFiltro = const RangeValues(0, 100000).obs;

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
bool _asBool(dynamic v) => v == true || v == 1 || v == '1';
  // lista filtrada y ORDENADA
  List<BuySell> filtrarYOrdenar({
    required bool esCompra,
    required String search,
  }) {
    final s = search.trim().toLowerCase();

    final filtrados = buySell.where((b) {
      // 1) compra/venta
      if (_asBool(b.esCompra) != esCompra) return false;

      // 2) búsqueda por socio
      if (s.isNotEmpty && !(b.socios ?? '').toLowerCase().contains(s)) {
        return false;
      }

      // 3) estado
      final ev = calcularEstadoVisual(b);
      final matchEstado = switch (estadoFiltro.value) {
        BuyFiltroEstado.todos     => true,
        BuyFiltroEstado.anuladas  => ev == BuyEstadoVisual.anulada,
        BuyFiltroEstado.pagadas   => ev == BuyEstadoVisual.pagada,
        BuyFiltroEstado.credito   => ev == BuyEstadoVisual.credito,
      };
      if (!matchEstado) return false;

      // 4) precio/rango
      final total = b.total ?? 0;
      final rv = rangoPrecioFiltro.value;
      if (total < rv.start || total > rv.end) return false;

      return true;
    }).toList();

    // ORDEN: primero créditos con saldo > 0, luego por fecha desc
    filtrados.sort((a, b) {
      int prioA = (a.esCredito == true && (a.saldo ?? 0) > 0) ? 0 : 1;
      int prioB = (b.esCredito == true && (b.saldo ?? 0) > 0) ? 0 : 1;
      if (prioA != prioB) return prioA - prioB;

      final fa = DateTime.tryParse(a.fecha ?? '') ?? DateTime(1900);
      final fb = DateTime.tryParse(b.fecha ?? '') ?? DateTime(1900);
      return fb.compareTo(fa); // desc
    });

    return filtrados;
  }
  BuyEstadoVisual calcularEstadoVisual(BuySell b) {
  final esAnulada = (b.estado == 0 || b.estado == '0' || b.estado == false);
  if (esAnulada) return BuyEstadoVisual.anulada;

  if (_asBool(b.esCredito) && (b.saldo ?? 0) > 0) {
    return BuyEstadoVisual.credito;
  }
  return BuyEstadoVisual.pagada;
}
}


