class ClienteModel {
  final String id;           
  final String nombre;       
  final String? telefono;    
  final String? direccion;    
  final String? notas;        
  final DateTime fechaRegistro; 
  final bool activo;          


  ClienteModel({
    required this.id,
    required this.nombre,
    this.telefono,
    this.direccion,
    this.notas,
    required this.fechaRegistro,
    this.activo = true,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      notas: json['notas'] as String?,
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'direccion': direccion,
      'notas': notas,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'activo': activo,
    };
  }
}
