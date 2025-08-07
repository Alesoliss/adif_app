class BuySell {
  final int? id;
  final int sociosId;
  final String? socios;
  final String fecha;
  final String? fechaVence;
  final double total;
  final bool esCredito;
  final double saldo;
  final String? comentario;
  final bool? esCompra;
  final int? estado;
  final List<BuySellDetalleModel> detalles;

  BuySell({
    this.id,
    required this.sociosId,
    required this.fecha,
    this.fechaVence,
    required this.total,
    this.esCredito = false,
    required this.saldo,
    this.comentario,
    this.esCompra,
    this.estado,
    this.socios = "",
    this.detalles = const [],
  });

  factory BuySell.fromJson(Map<String, dynamic> json) {
    return BuySell(
      id: json['id'] as int?,
      sociosId: json['sociosId'] as int,
      fecha: json['fecha'] as String,
      fechaVence: json['fechaVence'] as String?,
      total: (json['total'] as num).toDouble(),
      esCredito: (json['esCredito'] ?? 0) == 1,
      saldo: (json['saldo'] as num).toDouble(),
      comentario: json['comentario'] as String?,
      esCompra: json['esCompra'] as bool?,
      estado: json['estado'] as int?,
      socios: json['socios'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sociosId': sociosId,
      'fecha': fecha,
      'fechaVence': fechaVence,
      'total': total,
      'esCredito': esCredito ? 1 : 0,
      'saldo': saldo,
      'comentario': comentario,
    };
  }

  BuySell copyWith({
    int? id,
    int? sociosId,
    String? fecha,
    String? fechaVence,
    double? total,
    bool? esCredito,
    double? saldo,
    String? comentario,
    List<BuySellDetalleModel>? detalles,
  }) {
    return BuySell(
      id: id ?? this.id,
      sociosId: sociosId ?? this.sociosId,
      fecha: fecha ?? this.fecha,
      fechaVence: fechaVence ?? this.fechaVence,
      total: total ?? this.total,
      esCredito: esCredito ?? this.esCredito,
      saldo: saldo ?? this.saldo,
      comentario: comentario ?? this.comentario,
      detalles: detalles ?? this.detalles,
    );
  }
}

class BuySellDetalleModel {
  final int ventaId;
  final int linea;
  final int productoId;
  final double precio;
  final double cantidad;
  final double factor;
  final double total;

  BuySellDetalleModel({
    required this.ventaId,
    required this.linea,
    required this.productoId,
    required this.precio,
    required this.cantidad,
    required this.factor,
    required this.total,
  });

  factory BuySellDetalleModel.fromJson(Map<String, dynamic> json) {
    return BuySellDetalleModel(
      ventaId: json['ventaId'] as int,
      linea: json['linea'] as int,
      productoId: json['productoId'] as int,
      precio: (json['precio'] as num).toDouble(),
      cantidad: (json['cantidad'] as num).toDouble(),
      factor: (json['factor'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ventaId': ventaId,
      'linea': linea,
      'productoId': productoId,
      'precio': precio,
      'cantidad': cantidad,
      'factor': factor,
      'total': total,
    };
  }
}
