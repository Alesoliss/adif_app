class ProductoModel {
  final int? id; 
  final String nombre;
  final double precio;     
  final double? costo;     
  final double stock;
  final int? cateid;        
  final String? notas;
  final bool activo;
  final bool esServicio;
  final List<int>? img;     

  ProductoModel({
    this.id,
    required this.nombre,
    required this.precio,
    this.costo,
    required this.stock,
    this.cateid,
    this.notas,
    this.activo = true,
    this.esServicio = false,
    this.img,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'] as int?,
      nombre: json['nombre'] as String,
      precio: (json['precio'] as num).toDouble(),
      costo: json['costo'] != null ? (json['costo'] as num).toDouble() : null,
      stock: (json['stock'] as num).toDouble(),
      cateid: json['cateid'] as int?,
      notas: json['notas'] as String?,
      activo: (json['activo'] as int) == 1,
      esServicio: (json['esServicio'] as int) == 1,
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'precio': precio,
      'costo': costo,
      'stock': stock,
      'cateid': cateid,
      'notas': notas,
      'activo': activo ? 1 : 0,
      'esServicio': esServicio ? 1 : 0,
      'img': img,
    };
  }
}
