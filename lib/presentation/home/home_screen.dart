import 'package:edu_app/presentation/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edu Lindo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              // Acción de respaldo/exportar
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menú rápido
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _QuickButton(icon: Icons.inventory, label: "Productos", onTap: () {}),
                  _QuickButton(icon: Icons.bar_chart, label: "Ventas", onTap: () {}),
                  _QuickButton(icon: Icons.shopping_cart, label: "Compras", onTap: () {}),
                  _QuickButton(icon: Icons.people, label: "Clientes", onTap: () {}),
                ],
              ),
              const SizedBox(height: 24),
              // Productos más vendidos
              Obx(() => _CardSection(
                    title: "Productos más vendidos",
                    children: controller.productosMasVendidos.map((prod) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${prod['emoji']} ${prod['nombre']}", style: const TextStyle(fontSize: 16)),
                          Text("x${prod['cantidad']} vendidos", style: const TextStyle(fontSize: 16)),
                        ],
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 16),
              // Últimas ventas
              Obx(() => _CardSection(
                    title: "Últimas ventas",
                    children: controller.ultimasVentas.map((venta) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${venta['fecha']}  ${venta['producto']}"),
                          Text("L.${venta['total']}"),
                        ],
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 16),
              // Últimas compras
              Obx(() => _CardSection(
                    title: "Ultimas compras",
                    children: controller.ultimasCompras.map((compra) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${compra['fecha']}  ${compra['proveedor']}"),
                          Text("L.${compra['total']}"),
                        ],
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 16),
              // Clientes con saldo/deuda
              Obx(() => _CardSection(
                    title: "Clientes con saldo/deuda",
                    children: controller.clientesDeuda.map((cliente) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Text(cliente['nombre']),
                          Text("L.${cliente['deuda']}"),
                        ],
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 24),
              // Botón de venta rápida
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("Agregar venta rápida"),
                  onPressed: () {
                    // Acción para agregar venta
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickButton({required this.icon, required this.label, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 32, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class _CardSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _CardSection({required this.title, required this.children, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}
