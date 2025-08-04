class BuySellDetails {
  int compraId;
  final int linea;
  int productoId;
   final String productoNombre;
  double costo;
  double precio;
  double cantidad;
  double factor;
  double total;

  BuySellDetails({
    this.compraId = 0,
    this.linea = 0,
    required this.productoId,
      required this.productoNombre,
    this.costo = 0,
    this.precio = 0,
    this.cantidad = 1,
    this.factor = 1,
  }) : total = precio * cantidad;

  /// Recalcula el total si cambian precio, cantidad o factor
  void recalcular() {
    total = precio * cantidad;
  }

  Map<String, dynamic> toJson() => {
        'compraId': compraId,
        'linea': linea,
        'productoId': productoId,
        'costo': costo,
        'precio': precio,
        'cantidad': cantidad,
        'factor': factor,
        'total': total,
      };

  factory BuySellDetails.fromJson(Map<String, dynamic> json) {
    return BuySellDetails(
      compraId: json['compraId'] as int,
      linea: json['linea'] as int,
      productoId: json['productoId'] as int,
      productoNombre: '', // no se carga desde BD
      costo: (json['costo'] as num).toDouble(),
      precio: (json['precio'] as num).toDouble(),
      cantidad: (json['cantidad'] as num).toDouble(),
      factor: (json['factor'] as num).toDouble(),
    )..total = (json['total'] as num).toDouble();
  }
  
}extension ListSum on List<BuySellDetails> {
  double get sumTotal {
    return fold(0.0, (prev, elem) => prev + elem.total);
  }
}