import 'package:get/get.dart';

class HomeController extends GetxController {
  // Productos más vendidos (simulado)
  final productosMasVendidos = [
    {'nombre': 'Coca Cola', 'emoji': '🥤', 'cantidad': 10},
    {'nombre': 'Pan blanco', 'emoji': '🍞', 'cantidad': 7},
  ].obs;

  // Últimas ventas (simulado)
  final ultimasVentas = [
    {'fecha': '12/07', 'producto': 'Galletas', 'total': 40},
    {'fecha': '11/07', 'producto': 'Coca Cola x1', 'total': 25},
  ].obs;

  // Últimas compras (simulado)
  final ultimasCompras = [
    {'fecha': '12/07', 'proveedor': 'Almacén “La Central”', 'total': 200},
    {'fecha': '11/07', 'proveedor': 'Distribuidor XYZ', 'total': 180},
  ].obs;

  // Clientes con deuda (simulado)
  final clientesDeuda = [
    {'nombre': 'Juan Pérez', 'deuda': 100},
    {'nombre': 'Ferretería Sampedrana', 'deuda': 350},
  ].obs;
}
