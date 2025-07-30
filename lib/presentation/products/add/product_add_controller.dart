import 'dart:io';
import 'package:edu_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:edu_app/services/services.dart';

class ProductoAddController extends ChangeNotifier {
  final int? id; // ID del producto (null si es nuevo)

  ProductoAddController({this.id}) {
    if (id != null) _loadProducto(id!);
  }

  // Controladores para inputs
  final TextEditingController nombre = TextEditingController();
  final TextEditingController precio = TextEditingController();
  final TextEditingController costo = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final TextEditingController notas = TextEditingController();
  final TextEditingController categoriaId =
      TextEditingController(); // como ID opcional

  bool activo = true;
  bool esServicio = false;
  List<int>? imgBytes;
  String? fotoPath;

  // Flags de validación
  bool nombreInvalido = false;
  bool precioInvalido = false;
  bool stockInvalido = false;

  // ----------- Cargar producto si es edición -----------
  Future<void> _loadProducto(int id) async {
    try {
      final db = await DatabaseHelper.initDB();
      final result = await db.query(
        ServiceStrings.productos,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (result.isNotEmpty) {
        final producto = ProductoModel.fromJson(result.first);
        nombre.text = producto.nombre;
        precio.text = producto.precio.toString();
        costo.text = producto.costo?.toString() ?? '';
        stock.text = producto.stock.toString();
        categoriaId.text = producto.cateid?.toString() ?? '';
        notas.text = producto.notas ?? '';
        activo = producto.activo;
        esServicio = producto.esServicio;
        imgBytes = producto.img;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ Error al cargar producto: $e");
    }
  }

  // ----------- Validar y guardar -----------
  Future<void> validateAndSave() async {
    nombreInvalido = nombre.text.trim().isEmpty;
    precioInvalido = double.tryParse(precio.text) == null;
    stockInvalido = double.tryParse(stock.text) == null;

    notifyListeners();

    if (nombreInvalido || precioInvalido || stockInvalido) return;

    await _saveProducto();
  }

  Future<void> _saveProducto() async {
    try {
      final producto = ProductoModel(
        id: id,
        nombre: nombre.text.trim(),
        precio: double.parse(precio.text),
        costo: costo.text.trim().isEmpty ? null : double.parse(costo.text),
        stock: double.parse(stock.text),
        cateid: categoriaId.text.trim().isEmpty
            ? null
            : int.tryParse(categoriaId.text),
        notas: notas.text.trim().isEmpty ? null : notas.text.trim(),
        activo: activo,
        esServicio: esServicio,
        img: imgBytes,
      );

      if (id == null) {
        await DatabaseHelper.insert(
          ServiceStrings.productos,
          producto.toJson(),
        );
        debugPrint("✅ Producto guardado: ${producto.nombre}");
        limpiar();
      } else {
        await DatabaseHelper.update(
          ServiceStrings.productos,
          producto.toJson(),
          id!,
        );
        debugPrint("✏️ Producto actualizado: ${producto.nombre}");
      }
    } catch (e, st) {
      debugPrint("❌ Error al guardar producto: $e\n$st");
    }
  }

  // ----------- Imagen -----------
  Future<void> setFotoPath(String path) async {
    try {
      fotoPath = path;
      final file = File(path);
      imgBytes = await file.readAsBytes();
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error al leer imagen: $e");
    }
  }

  // ----------- Resetear formulario -----------
  void limpiar() {
    nombre.clear();
    precio.clear();
    costo.clear();
    stock.clear();
    categoriaId.clear();
    notas.clear();
    activo = true;
    esServicio = false;
    fotoPath = null;
    imgBytes = null;

    nombreInvalido = false;
    precioInvalido = false;
    stockInvalido = false;

    notifyListeners();
  }

  @override
  void dispose() {
    nombre.dispose();
    precio.dispose();
    costo.dispose();
    stock.dispose();
    categoriaId.dispose();
    notas.dispose();
    super.dispose();
  }
}
