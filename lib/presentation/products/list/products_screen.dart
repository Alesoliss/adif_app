import 'dart:typed_data';
import 'package:edu_app/models/product_model.dart';
import 'package:edu_app/presentation/products/list/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({super.key});

  final controller = Get.put(ProductsController());
  final TextEditingController searchController = TextEditingController();
  final RxString query = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              shadowColor: Colors.black12,
              elevation: 1,
            ),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Productos",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black87),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                elevation: 1,
              ),
              onPressed: () async {
                await Get.toNamed('/producto/agregar');
                controller.loadProductos(); // 👈 recarga al volver
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final productosFiltrados = controller.productos.where((producto) {
                final filtro = query.value.toLowerCase();
                final coincideBusqueda =
                    producto.nombre.toLowerCase().contains(filtro) ||
                    (producto.notas ?? '').toLowerCase().contains(filtro);
                final coincideTipo = controller.mostrarServicios.value
                    ? producto.esServicio
                    : !producto.esServicio;
                return coincideBusqueda && coincideTipo;
              }).toList();

              if (productosFiltrados.isEmpty) {
                return const Center(child: Text("No se encontraron productos"));
              }

              return ListView.builder(
                itemCount: productosFiltrados.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return _cardProductWidget(productosFiltrados[index], context);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Buscar productos...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => query.value = value,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() {
            return Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).colorScheme.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                icon: Text(
                  controller.mostrarServicios.value ? "S" : "P",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  controller.mostrarServicios.value =
                      !controller.mostrarServicios.value;
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _cardProductWidget(ProductoModel producto, BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                image: producto.img != null && producto.img!.isNotEmpty
                    ? DecorationImage(
                        image: MemoryImage(Uint8List.fromList(producto.img!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: producto.img == null || producto.img!.isEmpty
                  ? const Icon(Icons.inventory_2_outlined, size: 34)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Precio: L. ${producto.precio.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    'Stock: ${producto.stock}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (producto.notas?.isNotEmpty ?? false)
                    Text(
                      producto.notas!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
