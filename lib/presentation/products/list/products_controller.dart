import 'package:edu_app/models/category_model.dart';
import 'package:edu_app/models/product_model.dart';
import 'package:edu_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
 class ProductsController extends GetxController {
  var productos = <ProductoModel>[].obs;
  var loading = false.obs;
  final RxBool mostrarServicios = false.obs;
  final TextEditingController categoriaNombre = TextEditingController();

  // filtros
  final Rx<ProductoTipo> tipoFiltro = ProductoTipo.todos.obs;
  final Rx<ProductoEstado> estadoFiltro = ProductoEstado.todos.obs;
  final RxDouble precioMaximoFiltro = 1000.0.obs;
  final RxString categoriaFiltro = ''.obs;
  final Rx<RangeValues> rangoPrecioFiltro = RangeValues(0, 1000).obs;
  


  final RxList<CategoriaModel> sugerenciasCategorias = <CategoriaModel>[].obs;

  void aplicarFiltros(
    ProductoTipo tipo,
    ProductoEstado estado, {
    double? precioMax,
    String? categoria,
  }) {
    tipoFiltro.value = tipo;
    estadoFiltro.value = estado;
    if (precioMax != null) precioMaximoFiltro.value = precioMax;
    if (categoria != null) categoriaFiltro.value = categoria;
  }

  @override
  void onInit() {
    super.onInit();
    loadProductos();
    loadCategorias(); // 👈 Aquí llamamos para llenar las sugerencias
  }

  @override
  void onReady() {
    super.onReady();
    loadProductos();
  }

  void resetFilters({
  ProductoTipo tipo    = ProductoTipo.todos,
  ProductoEstado estado = ProductoEstado.activos,
  RangeValues rango    = const RangeValues(0, 1000),
  String categoria     = '',
  }) {
    tipoFiltro.value        = tipo;
    estadoFiltro.value      = estado;
    rangoPrecioFiltro.value = rango;
    categoriaFiltro.value   = categoria;
  }

  Future<void> loadProductos() async {
    loading.value = true;

    final data = await DatabaseHelper.getAll(ServiceStrings.productos);
    productos.value = data.map((json) => ProductoModel.fromJson(json)).toList();

    loading.value = false;
  }

  Future<void> loadCategorias() async {
    final data = await DatabaseHelper.getAll(ServiceStrings.categorias);
    sugerenciasCategorias.value =
        data.map((json) => CategoriaModel.fromJson(json)).toList();
          debugPrint('✔ Categorías cargadas: ${sugerenciasCategorias.length}');
  }
}

enum ProductoTipo { todos, productos, servicios }
enum ProductoEstado { todos, activos, inactivos }
