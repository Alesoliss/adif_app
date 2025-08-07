// import 'dart:typed_data';
// import 'package:edu_app/models/product_model.dart';
// import 'package:edu_app/presentation/Buy-Sell/list/buysell_controller.dart';
// import 'package:edu_app/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class BuySellScreen extends StatelessWidget {
//   final bool esCompra;
//   BuySellScreen({this.esCompra   = false, super.key});  // ← aquí
//   final controller = Get.put(BuySellController());
//   final TextEditingController searchController = TextEditingController();
//   final RxString query = ''.obs;

//   //abre filtro
//   void showRightFilterPanel(
//     BuildContext context,
//     BuySellController controller,
//   ) {
//     showGeneralDialog(
//       context: context,
//       barrierLabel: "Filtro",
//       barrierDismissible: true,
//       barrierColor: Colors.black54,
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (_, _, _) {
//         return Align(
//           alignment: Alignment.centerRight,
//           child: FractionallySizedBox(
//             widthFactor: 0.70,
//             child: Material(
//               borderRadius: const BorderRadius.horizontal(
//                 left: Radius.circular(20),
//               ),
//               color: Colors.white,
//               child: _PanelFiltros(controller: controller),
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (_, animation, _, child) {
//         final offsetAnimation =
//             Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
//               CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
//             );
//         return SlideTransition(position: offsetAnimation, child: child);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//         ),
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 12),
//           child: IconButton(
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.white,
//               shape: const CircleBorder(),
//               shadowColor: Colors.black12,
//               elevation: 1,
//             ),
//             icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
//             onPressed: () => Get.back(),
//           ),
//         ),
//         centerTitle: true,
//       title: Obx(() {
//         // isProveedores es RxBool
//         final titulo = switch (controller.tipoFiltro.value) {
//         SocioTipo.todos        => 'Socios',
//         SocioTipo.clientes     => 'Clientes',
//         SocioTipo.proveedores  => 'Proveedores',
//       };
//       return Text(titulo, style: const TextStyle(color: Colors.black87));
//       }),
//         actions: [
//         if (onSelect == null)
//             Padding(
//               padding: const EdgeInsets.only(right: 12),
//               child: IconButton(
//                 icon: const Icon(Icons.add, color: Colors.black87),
//                 style: IconButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   shape: const CircleBorder(),
//                   elevation: 1,
//                 ),
//                 onPressed: () async {
//                   final result = await Get.toNamed(MainRoutes.addProduct);
//                   if (result == true) await controller.loadProductos();
//                 },
//               ),
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           _buildSearchBar(),
//           Expanded(
//             child: Obx(() {
//               if (controller.loading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               final productosFiltrados = controller.productos.where((producto) {
//             if (excludeIds?.contains(producto.id) ?? false) return false;
//                 final filtro = query.value.toLowerCase();
//                 final coincideBusqueda =
//                     producto.nombre.toLowerCase().contains(filtro) ||
//                     (producto.notas ?? '').toLowerCase().contains(filtro);
//                 final coincideTipo = switch (controller.tipoFiltro.value) {
//                   ProductoTipo.todos => true,
//                   ProductoTipo.productos => !producto.esServicio,
//                   ProductoTipo.servicios => producto.esServicio,
//                 };

//                 final coincideEstado = switch (controller.estadoFiltro.value) {
//                   ProductoEstado.todos => true,
//                   ProductoEstado.activos => producto.activo,
//                   ProductoEstado.inactivos => !producto.activo,
//                 };

//                 final coincidePrecio =
//                     producto.precio >=
//                         controller.rangoPrecioFiltro.value.start &&
//                     producto.precio <= controller.rangoPrecioFiltro.value.end;

//                 return coincideBusqueda &&
//                     coincideTipo &&
//                     coincideEstado &&
//                     coincidePrecio;
//               }).toList();

//               if (productosFiltrados.isEmpty) {
//                 return const Center(child: Text("No se encontraron productos"));
//               }

//               return ListView.builder(
//                 itemCount: productosFiltrados.length,
//                 padding: const EdgeInsets.all(16),
//                 itemBuilder: (context, index) {
//                   return _cardProductWidget(productosFiltrados[index], context);
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

// Widget _buildSearchBar() {
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
//     child: Row(
//       children: [
//         // -------- Buscador ----------
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(14),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             child: Row(
//               children: [
//                 const Icon(Icons.search, color: Colors.grey),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: TextField(
//                     controller: searchController,
//                     decoration: const InputDecoration(
//                       hintText: 'Buscar productos...',
//                       border: InputBorder.none,
//                     ),
//                     onChanged: (value) => query.value = value,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // -------- Botón filtro (solo cuando onSelect == null) ----------
//         if (onSelect == null) ...[
//           const SizedBox(width: 8),
//           SizedBox(
//             height: 48,
//             width: 48,
//             child: IconButton(
//               icon: const Icon(Icons.tune, color: Colors.white),
//               style: IconButton.styleFrom(
//                 backgroundColor: Theme.of(Get.context!).colorScheme.primary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 elevation: 1,
//               ),
//               onPressed: () => showRightFilterPanel(Get.context!, controller),
//             ),
//           ),
//         ],
//       ],
//     ),
//   );
// }         
//   Widget _cardProductWidget(ProductoModel producto, BuildContext context) {
//     final theme = Theme.of(context);
//   final isCompra = esCompra;           // ya es bool

//   final etiqueta = isCompra ? 'Costo' : 'Precio';
// final double valor = isCompra
//     ? (producto.costo  ?? 0)   // si viene null → 0
//     : (producto.precio ?? 0);
//     return GestureDetector(
//       onTap: () async {
//         if (onSelect != null) {
//           // --- MODO SELECTOR -----------------------------------------------
//           onSelect!(producto);
//           //Navigator.pop(context);
//         } else {
//           // --- MODO NORMAL -------------------------------------------------
//           final result = await Get.toNamed(
//             MainRoutes.addProduct,
//             arguments: {'id': producto.id},
//           );
//           if (result == true) await controller.loadProductos();
//         }
//       },
//       child: Card(
//         color: Colors.white,
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         elevation: 2,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               // mini-imagen / icono
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                   image: producto.img != null && producto.img!.isNotEmpty
//                       ? DecorationImage(
//                           image: MemoryImage(
//                               Uint8List.fromList(producto.img!)),
//                           fit: BoxFit.cover,
//                         )
//                       : null,
//                 ),
//                 child: producto.img == null || producto.img!.isEmpty
//                     ? const Icon(Icons.inventory_2_outlined, size: 34)
//                     : null,
//               ),
//               const SizedBox(width: 16),
//               // datos del producto
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       producto.nombre,
//                       style: theme.textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                   Text(        '$etiqueta: L. ${valor.toStringAsFixed(2)}',
//                       style: theme.textTheme.bodyMedium),
//                     Text(
//                       'Stock: ${producto.stock}',
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     if (producto.notas?.isNotEmpty ?? false)
//                       Text(
//                         producto.notas!,
//                         style: theme.textTheme.bodySmall?.copyWith(
//                           color: Colors.grey.shade500,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// }



// class _FiltroChip extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//   final Color color;

//   const _FiltroChip({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//     required this.color,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: selected ? color : Colors.grey[200],
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: selected ? Colors.white : Colors.black87,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }
// class _PanelFiltros extends StatelessWidget {
//   final ProductsController controller;

//   const _PanelFiltros({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     final primary = Theme.of(context).colorScheme.primary;

//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 16),
//         child: Column(
//           children: [
//             // Header
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const Text(
//                   "Filtros",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const Spacer(),
//                 TextButton(
//                   onPressed: () {
//                     controller.aplicarFiltros(
//                       ProductoTipo.todos,
//                       ProductoEstado.todos,
//                       precioMax: 1000,
//                       categoria: '',
//                     );
//                     Navigator.pop(context);
//                   },
//                   child: const Text(
//                     "Limpiar",
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),

//             // Scrollable Content
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Tipo de producto",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     const SizedBox(height: 12),
//                     Obx(
//                       () => Wrap(
//                         spacing: 10,
//                         runSpacing: 10,
//                         children: ProductoTipo.values.map((tipo) {
//                           final selected = controller.tipoFiltro.value == tipo;
//                           return _FiltroChip(
//                             label: tipo.name.capitalizeFirst!,
//                             selected: selected,
//                             onTap: () => controller.tipoFiltro.value = tipo,
//                             color: primary,
//                           );
//                         }).toList(),
//                       ),
//                     ),

//                     const SizedBox(height: 24),
//                     const Text("Estado", style: TextStyle(color: Colors.grey)),
//                     const SizedBox(height: 12),
//                     Obx(
//                       () => Wrap(
//                         spacing: 10,
//                         runSpacing: 10,
//                         children: ProductoEstado.values.map((estado) {
//                           final label = switch (estado) {
//                             ProductoEstado.todos => 'Todos',
//                             ProductoEstado.activos => 'Activos',
//                             ProductoEstado.inactivos => 'Inactivos',
//                           };
//                           final selected =
//                               controller.estadoFiltro.value == estado;
//                           return _FiltroChip(
//                             label: label,
//                             selected: selected,
//                             onTap: () => controller.estadoFiltro.value = estado,
//                             color: primary,
//                           );
//                         }).toList(),
//                       ),
//                     ),

//                     const SizedBox(height: 24),
//                     const Text(
//                       "Rango de precios",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     Obx(
//                       () => Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           RangeSlider(
//                             values: controller.rangoPrecioFiltro.value,
//                             min: 0,
//                             max: 1000,
//                             divisions: 20,
//                             labels: RangeLabels(
//                               "L. ${controller.rangoPrecioFiltro.value.start.toStringAsFixed(0)}",
//                               "L. ${controller.rangoPrecioFiltro.value.end.toStringAsFixed(0)}",
//                             ),
//                             onChanged: (RangeValues values) {
//                               controller.rangoPrecioFiltro.value = values;
//                             },
//                             activeColor: primary,
//                           ),
//                           Text(
//                             "Desde L. ${controller.rangoPrecioFiltro.value.start.toStringAsFixed(0)} "
//                             "hasta L. ${controller.rangoPrecioFiltro.value.end.toStringAsFixed(0)}",
//                             style: const TextStyle(fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),
//                     const Text(
//                       "Categorías",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     const SizedBox(height: 12),
//                     Obx(() {
//                       if (controller.sugerenciasCategorias.isEmpty) {
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         ); // o SizedBox.shrink()
//                       }

//                       return Wrap(
//                         spacing: 10,
//                         runSpacing: 10,
//                         children: controller.sugerenciasCategorias.map((cat) {
//                           final selected =
//                               controller.categoriaFiltro.value == cat.nombre;
//                           return _FiltroChip(
//                             label: cat.nombre,
//                             selected: selected,
//                             onTap: () =>
//                                 controller.categoriaFiltro.value = cat.nombre,
//                             color: primary,
//                           );
//                         }).toList(),
//                       );
//                     }),

//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               ),
//             ),

//             // Botón aplicar
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: FilledButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: FilledButton.styleFrom(
//                   backgroundColor: primary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: const Text("Aplicar filtros"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
