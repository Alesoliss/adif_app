class ProductoModel {
  final String id;
  final String nombre;
  final String? descripcion;
  final double precioVenta;
  final double? precioCompra;
  final int stock;
  final String unidad;
  final String? categoria;
  final String? codigoBarras;
  final bool activo;
  final DateTime fechaRegistro;
  final String? notas;
  final String? fotoUrl;

  ProductoModel({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precioVenta,
    this.precioCompra,
    required this.stock,
    required this.unidad,
    this.categoria,
    this.codigoBarras,
    this.activo = true,
    required this.fechaRegistro,
    this.notas,
    this.fotoUrl,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      precioVenta: (json['precioVenta'] as num).toDouble(),
      precioCompra: json['precioCompra'] != null
          ? (json['precioCompra'] as num).toDouble()
          : null,
      stock: json['stock'] as int,
      unidad: json['unidad'] as String,
      categoria: json['categoria'] as String?,
      codigoBarras: json['codigoBarras'] as String?,
      activo: json['activo'] ?? true,
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
      notas: json['notas'] as String?,
      fotoUrl: json['fotoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precioVenta': precioVenta,
      'precioCompra': precioCompra,
      'stock': stock,
      'unidad': unidad,
      'categoria': categoria,
      'codigoBarras': codigoBarras,
      'activo': activo,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'notas': notas,
      'fotoUrl': fotoUrl,
    };
  }
}
