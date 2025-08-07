// import 'package:edu_app/models/buy-sell.dart';
// import 'package:edu_app/models/category_model.dart';
// import 'package:edu_app/models/product_model.dart';
// import 'package:edu_app/services/services.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// enum BuyTipo { todos, compras, ventas }
// enum BuyTipoPago { todos, anulados, pagados, credito,  }
// class BuySellController extends GetxController {
//   var productos = <BuySell>[].obs;
//   var loading = false.obs;
//   final RxBool mostrarServicios = false.obs;

//   // filtros
//   final Rx<BuyTipo> tipoFiltro = BuyTipo.todos.obs;
//   final Rx<BuyTipoPago> estadoFiltro = BuyTipoPago.todos.obs;
//   final RxDouble precioMaximoFiltro = 1000.0.obs;
//   final Rx<RangeValues> rangoPrecioFiltro = RangeValues(0, 1000).obs;
  



//   void aplicarFiltros(
//     BuyTipo tipo,
//     BuyTipoPago estado, {
//     double? precioMax,
//     String? categoria,
//   }) {
//     tipoFiltro.value = tipo;
//     estadoFiltro.value = estado;
//     if (precioMax != null) precioMaximoFiltro.value = precioMax;
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     loadBuySells();
//   }

//   @override
//   void onReady() {
//     super.onReady();
//     loadProductos();
//   }

//   void resetFilters({
//   BuyTipo tipo    = BuyTipo.todos,
//   BuyTipoPago estado = BuyTipoPago.todos,
//   RangeValues rango    = const RangeValues(0, 1000),
//   }) {
//     tipoFiltro.value        = tipo;
//     estadoFiltro.value      = estado;
//     rangoPrecioFiltro.value = rango;
//   }

//   Future<void> loadBuySells() async {
//     loading.value = true;

//     final data = await DatabaseHelper.getAll(ServiceStrings.productos);
//     productos.value = data.map((json) => ProductoModel.fromJson(json)).toList();

//     loading.value = false;
//   }

// }


