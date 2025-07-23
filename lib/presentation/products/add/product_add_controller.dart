import 'dart:convert';
import 'dart:io';
import 'package:edu_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProductoAddController extends ChangeNotifier {
  final TextEditingController nombre = TextEditingController();
  final TextEditingController descripcion = TextEditingController();
  final TextEditingController precioVenta = TextEditingController();
  final TextEditingController precioCompra = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final TextEditingController unidad = TextEditingController();
  final TextEditingController categoria = TextEditingController();
  final TextEditingController codigoBarras = TextEditingController();
  final TextEditingController notas = TextEditingController();

  String? fotoPath;
  bool activo = true;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (img != null) {
      fotoPath = img.path;
      notifyListeners();
    }
  }

  Future<void> saveProducto() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/productos.json');
    List<ProductoModel> productos = [];
    if (await file.exists()) {
      final data = await file.readAsString();
      final jsonList = jsonDecode(data) as List;
      productos = jsonList.map((e) => ProductoModel.fromJson(e)).toList();
    }
    final uuid = const Uuid().v4();
    productos.add(ProductoModel(
      id: uuid,
      nombre: nombre.text.trim(),
      descripcion: descripcion.text.trim().isEmpty ? null : descripcion.text.trim(),
      precioVenta: double.tryParse(precioVenta.text) ?? 0,
      precioCompra: double.tryParse(precioCompra.text),
      stock: int.tryParse(stock.text) ?? 0,
      unidad: unidad.text.trim(),
      categoria: categoria.text.trim().isEmpty ? null : categoria.text.trim(),
      codigoBarras: codigoBarras.text.trim().isEmpty ? null : codigoBarras.text.trim(),
      activo: activo,
      fechaRegistro: DateTime.now(),
      notas: notas.text.trim().isEmpty ? null : notas.text.trim(),
      fotoUrl: fotoPath,
    ));
    await file.writeAsString(jsonEncode(productos.map((e) => e.toJson()).toList()));
  }
void setFotoPath(String path) {
  fotoPath = path;
  notifyListeners();
}



  void disposeAll() {
    nombre.dispose();
    descripcion.dispose();
    precioVenta.dispose();
    precioCompra.dispose();
    stock.dispose();
    unidad.dispose();
    categoria.dispose();
    codigoBarras.dispose();
    notas.dispose();
    super.dispose();
  }
}
