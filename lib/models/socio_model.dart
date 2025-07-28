class PartnerModel {
  final int? id;
  final String nombre;
  final String? dni;
  final String? telefono;
  final String? notas;
  final bool esProveedor;

  PartnerModel({
    this.id,
    required this.nombre,
    this.dni,
    this.telefono,
    this.notas,
    this.esProveedor = false,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      id: json['id'] as int?,
      nombre: json['nombre'] as String,
      dni: json['dni'] as String?,
      telefono: json['telefono'] as String?,
      notas: json['notas'] as String?,
      esProveedor: (json['esProveedor'] ?? 0) == 1,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'dni': dni,
      'telefono': telefono,
      'notas': notas,
      'esProveedor': esProveedor ? 1 : 0,
    };
  }

  PartnerModel copyWith({
    int? id,
    String? nombre,
    String? dni,
    String? telefono,
    String? notas,
    bool? activo,
    bool? esProveedor,
  }) {
    return PartnerModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      dni: dni ?? this.dni,
      telefono: telefono ?? this.telefono,
      notas: notas ?? this.notas,
      esProveedor: esProveedor ?? this.esProveedor,
    );
  }
}
