import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_app/presentation/products/add/product_add_controller.dart';
import 'package:edu_app/routes/app_routes.dart';

class AgregarProductoScreen extends StatelessWidget {
  const AgregarProductoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductoAddController(),
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Theme.of(
          //   context,
          // ).colorScheme.primary.withOpacity(0.08),
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
          centerTitle: true,
          title: const Text(
            "Agregar producto",
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
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  shadowColor: Colors.black12,
                  elevation: 1,
                ),
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.black87,
                ),
                onPressed: () {
                  // Navegar a notificaciones
                },
              ),
            ),
          ],
        ),

        body: Consumer<ProductoAddController>(
          builder: (context, ctrl, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPhotoAddWidget(ctrl, context),
                  const SizedBox(height: 30),
                  const Text(
                    "Información del producto",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: ctrl.nombre,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: "Nombre del producto",
                        hintText: "Ej: Coca-Cola 600ml",
                        labelStyle: const TextStyle(
                          color: Color(0xFF8A8A8A),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        hintStyle: const TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1.3,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Precios",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            controller: ctrl.precio,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              labelText: "Precio de venta",
                              hintText: "Ej: 12.50",
                              labelStyle: const TextStyle(
                                color: Color(0xFF8A8A8A),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              hintStyle: const TextStyle(
                                color: Color(0xFFBDBDBD),
                                fontSize: 15,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0),
                                  width: 1.3,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            controller: ctrl.costo,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              labelText: "Precio de compra",
                              hintText: "Ej: 9.00",
                              labelStyle: const TextStyle(
                                color: Color(0xFF8A8A8A),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              hintStyle: const TextStyle(
                                color: Color(0xFFBDBDBD),
                                fontSize: 15,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0),
                                  width: 1.3,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Inventario",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            controller: ctrl.stock,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              labelText: "Stock",
                              hintText: "Cantidad disponible",
                              labelStyle: const TextStyle(
                                color: Color(0xFF8A8A8A),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              hintStyle: const TextStyle(
                                color: Color(0xFFBDBDBD),
                                fontSize: 15,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0),
                                  width: 1.3,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Datos adicionales",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: ctrl.categoriaId,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: "Categoría (opcional)",
                        hintText: "Ej: Bebidas",
                        labelStyle: const TextStyle(
                          color: Color(0xFF8A8A8A),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        hintStyle: const TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1.3,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: ctrl.notas,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: "Notas (opcional)",
                        hintText: "Notas internas sobre el producto",
                        labelStyle: const TextStyle(
                          color: Color(0xFF8A8A8A),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        hintStyle: const TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1.3,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "Producto activo",
                        style: TextStyle(
                          color: Color(0xFF4F4F4F),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: ctrl.activo,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (v) {
                        ctrl.activo = v;
                        ctrl.notifyListeners();
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "¿Es servicio?",
                        style: TextStyle(
                          color: Color(0xFF4F4F4F),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: ctrl.activo,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (v) {
                        ctrl.activo = v;
                        ctrl.notifyListeners();
                      },
                    ),
                  ),

                  const SizedBox(height: 0),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: () async {
                        await ctrl.validateAndSave();
                        if (context.mounted) Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("GUARDAR PRODUCTO"),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Center _buildPhotoAddWidget(
    ProductoAddController ctrl,
    BuildContext context,
  ) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final path = await Get.toNamed(MainRoutes.seleccionarFoto);
          if (path != null && path is String) {
            ctrl.setFotoPath(path);
          }
        },
        child: CircleAvatar(
          radius: 44,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.18),
          backgroundImage: ctrl.fotoPath != null
              ? FileImage(File(ctrl.fotoPath!))
              : null,
          child: ctrl.fotoPath == null
              ? Icon(
                  Icons.camera_alt_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 36,
                )
              : null,
        ),
      ),
    );
  }
}
