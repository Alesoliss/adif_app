import 'package:flutter/material.dart';
import 'package:edu_app/models/product_model.dart';
import 'package:edu_app/services/services.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  var productos = <ProductoModel>[].obs;
  var loading = false.obs;
  final RxBool mostrarServicios = false.obs;


  @override
  void onInit() {
    super.onInit();
    loadProductos(); 
  }

  @override
  void onReady() {
    super.onReady();
    loadProductos();
  }

  Future<void> loadProductos() async {
    loading.value = true;

    final data = await DatabaseHelper.getAll(ServiceStrings.productos);
    productos.value = data.map((json) => ProductoModel.fromJson(json)).toList();

    loading.value = false;
  }
}
