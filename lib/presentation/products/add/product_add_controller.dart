import 'dart:io';
import 'package:edu_app/models/category_model.dart';
import 'package:edu_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:edu_app/services/services.dart';
import 'package:image/image.dart' as img;

class ProductoAddController extends ChangeNotifier {
  final int? id;

  ProductoAddController({this.id}) {
    if (id != null) _loadProducto(id!);
  }

  // Controladores para inputs
  final TextEditingController nombre = TextEditingController();
  final TextEditingController precio = TextEditingController();
  final TextEditingController costo = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final TextEditingController notas = TextEditingController();
  final TextEditingController categoriaId = TextEditingController();

  bool activo = true;
  bool esServicio = false;
  List<int>? imgBytes;
  String? fotoPath;

  // Flags de validación
  bool nombreInvalido = false;
  bool precioInvalido = false;
  bool stockInvalido = false;

  //para categoria
  final TextEditingController categoriaNombre = TextEditingController();
  bool categoriaNoExiste = false;
  List<CategoriaModel> sugerenciasCategorias = [];

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
        if (producto.cateid != null) {
          final db = await DatabaseHelper.initDB();
          final catResult = await db.query(
            ServiceStrings.categorias,
            where: 'id = ?',
            whereArgs: [producto.cateid],
            limit: 1,
          );
          if (catResult.isNotEmpty) {
            categoriaNombre.text = CategoriaModel.fromJson(
              catResult.first,
            ).nombre;
          }
        }
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
        final nuevoId = await DatabaseHelper.insert(
          ServiceStrings.productos,
          producto.toJson(),
        );
        debugPrint("✅ Guardado con éxito: ${producto.nombre} con ID: $nuevoId");
        limpiar();
      } else {
        await DatabaseHelper.update(
          ServiceStrings.productos,
          producto.toJson(),
          id!,
        );
        debugPrint("✏️ Editado con éxito: ${producto.nombre}");
      }
    } catch (e, st) {
      debugPrint("❌ No se pudo guardar: $e\n$st");
    }
  }

  // ----------- Imagen -----------
  Future<void> setFotoPath(String path) async {
    try {
      fotoPath = path;
      final file = File(path);
      final bytes = await file.readAsBytes();

      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) {
        throw Exception("No se pudo decodificar la imagen");
      }

      img.Image resized = originalImage;
      if (originalImage.width > 720) {
        final newHeight = (720 * originalImage.height / originalImage.width)
            .round();
        resized = img.copyResize(originalImage, width: 720, height: newHeight);
      }

      imgBytes = img.encodePng(resized);

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error al procesar imagen: $e");
    }
  }

  //para categorias

  Future<void> cargarCategorias(String input) async {
    final lista = await DatabaseHelper.getAll(ServiceStrings.categorias);
    final categorias = lista.map((e) => CategoriaModel.fromJson(e)).toList();

    final filtro = input.trim().toLowerCase();
    sugerenciasCategorias = categorias
        .where((cat) => cat.nombre.toLowerCase().contains(filtro))
        .toList();

    final existe = categorias.any((cat) => cat.nombre.toLowerCase() == filtro);
    categoriaNoExiste = !existe;
    notifyListeners();
  }

  Future<void> crearCategoriaSiNoExiste() async {
    final nombre = categoriaNombre.text.trim();
    if (nombre.isEmpty) return;

    final lista = await DatabaseHelper.getAll(ServiceStrings.categorias);
    final categorias = lista.map((e) => CategoriaModel.fromJson(e)).toList();
    final existe = categorias.firstWhere(
      (cat) => cat.nombre.toLowerCase() == nombre.toLowerCase(),
      orElse: () => CategoriaModel(id: null, nombre: ''),
    );

    if (existe.id == null) {
      final nuevaCategoria = CategoriaModel(nombre: nombre);
      final id = await DatabaseHelper.insert(
        ServiceStrings.categorias,
        nuevaCategoria.toJson(),
      );
      categoriaId.text = id.toString();
      categoriaNoExiste = false;
      notifyListeners();
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
