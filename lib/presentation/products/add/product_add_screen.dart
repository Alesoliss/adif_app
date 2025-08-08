import 'dart:io';
import 'dart:typed_data';
import 'package:edu_app/models/category_model.dart';
import 'package:edu_app/shared_components/helpers/ok_cancel_dialog.dart';
import 'package:edu_app/shared_components/helpers/snackbar_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:edu_app/presentation/products/add/product_add_controller.dart';
import 'package:edu_app/routes/app_routes.dart';

class AgregarProductoScreen extends StatelessWidget {
  const AgregarProductoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final id = args['id'] as int?;
    final ctrl = Get.put(ProductoAddController(id: id));

    return Scaffold(
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
        title: Text(
          id == null ? "Agregar producto" : "Editar producto",
          style: const TextStyle(
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

      body: SingleChildScrollView(
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
                style: const TextStyle(color: Colors.black87, fontSize: 16),
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ctrl.nombreInvalido
                          ? Colors.red
                          : const Color(0xFFE0E0E0),
                      width: 1.3,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ctrl.nombreInvalido
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                      width: 1.6,
                    ),
                  ),
                  errorText: ctrl.nombreInvalido
                      ? 'Este campo es obligatorio'
                      : null,
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
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ctrl.precioInvalido
                                ? Colors.red
                                : const Color(0xFFE0E0E0),
                            width: 1.3,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ctrl.precioInvalido
                                ? Colors.red
                                : Theme.of(context).colorScheme.primary,
                            width: 1.6,
                          ),
                        ),
                        errorText: ctrl.precioInvalido
                            ? 'Precio inválido'
                            : null,
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
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ctrl.stockInvalido
                                ? Colors.red
                                : const Color(0xFFE0E0E0),
                            width: 1.3,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ctrl.stockInvalido
                                ? Colors.red
                                : Theme.of(context).colorScheme.primary,
                            width: 1.6,
                          ),
                        ),
                        errorText: ctrl.stockInvalido ? 'Stock inválido' : null,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Autocomplete<CategoriaModel>(
                    displayStringForOption: (cat) => cat.nombre,
                    optionsBuilder: (TextEditingValue value) async {
                      await ctrl.cargarCategorias(value.text);
                      return ctrl.sugerenciasCategorias;
                    },
                    fieldViewBuilder:
                        (
                          context,
                          textEditingController,
                          focusNode,
                          onFieldSubmitted,
                        ) {
                          // Inicializar texto
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (textEditingController.text !=
                                ctrl.categoriaNombre.text) {
                              textEditingController.text =
                                  ctrl.categoriaNombre.text;
                              textEditingController.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: textEditingController.text.length,
                                    ),
                                  );
                            }
                          });

                          // UI que depende de categoriaNoExiste
                          return Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Obx(() {
                                final showError =
                                    ctrl.categoriaNoExiste.value &&
                                    ctrl.categoriaNombre.text.trim().isNotEmpty;

                                return TextField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  onChanged: (value) async {
                                    ctrl.categoriaNombre.text = value;
                                    ctrl.categoriaTexto.value =
                                        value; // 👈 actualiza observable
                                    await ctrl.cargarCategorias(value);
                                  },

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
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        width: 1.6,
                                      ),
                                    ),
                                    errorText: showError
                                        ? 'La categoría no existe'
                                        : null,
                                  ),
                                );
                              }),

                              if (textEditingController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () {
                                    textEditingController.clear();
                                    ctrl.categoriaNombre.clear();
                                    ctrl.categoriaId.clear();
                                    ctrl.categoriaNoExiste.value = false;
                                  },
                                ),
                            ],
                          );
                        },
                    onSelected: (cat) {
                      ctrl.categoriaId.text = cat.id.toString();
                      ctrl.categoriaNombre.text = cat.nombre;
                      ctrl.categoriaNoExiste.value = false;
                    },
                  ),

                 Obx(() {
  final nombre = ctrl.categoriaTexto.value.trim(); // 👈 ahora sí es observable
  final noExiste = ctrl.categoriaNoExiste.value;
  return (nombre.isNotEmpty && noExiste)
      ? Padding(
          padding: const EdgeInsets.only(top: 6),
          child: TextButton.icon(
            onPressed: ctrl.crearCategoriaSiNoExiste,
            icon: const Icon(Icons.add),
            label: const Text("Crear nueva categoría"),
          ),
        )
      : const SizedBox.shrink();
}),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: ctrl.notas,
                maxLines: 2,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                activeColor: Colors.white, // Color del círculo
                activeTrackColor: Theme.of(
                  context,
                ).colorScheme.primary, // fondo azul
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade400,
                onChanged: (v) {
                  ctrl.activo = v;
                  ctrl.actualizarUI();
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
                value: ctrl.esServicio,
                activeColor: Colors.white, // círculo
                activeTrackColor: Theme.of(
                  context,
                ).colorScheme.primary, // fondo
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade400,
                onChanged: (v) {
                  ctrl.esServicio = v;
                  ctrl.actualizarUI();
                },
              ),
            ),

            const SizedBox(height: 0),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () async {
                  if (ctrl.id != null) {
                    final confirmar = await showDialog<bool>(
                      context: context,
                      builder: (_) => const OkCancelDialog(
                        title: 'Confirmar edición',
                        message: '¿Deseas guardar los cambios realizados?',
                        icon: Icons.edit_note_rounded,
                        okString: 'Guardar',
                        cancelString: 'Cancelar',
                      ),
                    );

                    if (confirmar != true) return;
                  }

                  await ctrl.validateAndSave();

                  if (!ctrl.nombreInvalido &&
                      !ctrl.precioInvalido &&
                      !ctrl.stockInvalido &&
                      context.mounted) {
                    SnackbarHelper.show(
                      type: SnackType.success,
                      message: ctrl.id == null
                          ? 'Producto guardado correctamente'
                          : 'Cambios guardados con éxito',
                    );
                    Navigator.pop(context, true);
                  }
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
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(46),
          backgroundImage: ctrl.fotoPath != null
              ? FileImage(File(ctrl.fotoPath!))
              : (ctrl.imgBytes != null
                    ? MemoryImage(Uint8List.fromList(ctrl.imgBytes!))
                    : null),
          child: (ctrl.fotoPath == null && ctrl.imgBytes == null)
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
