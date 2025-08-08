import 'package:edu_app/shared_components/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'partner_add_controller.dart';

class AddPartnerScreen extends StatelessWidget {
  const AddPartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final esProveedor = args['esProveedor'] ?? false;
    final id = args['id'] as int?;

    final ctrl = Get.put(
      PartnerAddController(esProveedor: esProveedor, id: id),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Get.back(result: true), // ← devuelve “true”
        ),
        centerTitle: true,
        title: Text(
          id == null
              ? (esProveedor ? "Agregar proveedor" : "Agregar cliente")
              : (esProveedor ? "Editar proveedor" : "Editar cliente"),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              "Información del ${esProveedor ? 'proveedor' : 'cliente'}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),

            // Nombre
            Obx(
              () => TextField(
                controller: ctrl.nombre,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Nombre",
                  hintText: "Ej: Juan Pérez",
                  labelStyle: const TextStyle(
                    color: Color(0xFF8A8A8A),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ctrl.nombreInvalido.value
                          ? Colors.red
                          : const Color(0xFFE0E0E0),
                      width: 1.3,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ctrl.nombreInvalido.value
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                      width: 1.6,
                    ),
                  ),
                  errorText: ctrl.nombreInvalido.value
                      ? 'El nombre es obligatorio'
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // DNI
            Obx(
              () => TextField(
                controller: ctrl.dni,
                keyboardType: TextInputType.number,
                onChanged: ctrl.onDniChanged,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                decoration: InputDecoration(
                  labelText: "DNI del ${esProveedor ? 'proveedor' : 'cliente'}",
                  hintText: "Ej: 0000-0000-0000",
                  labelStyle: const TextStyle(
                    color: Color(0xFF8A8A8A),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ctrl.dniInvalido.value
                          ? Colors.red
                          : const Color(0xFFE0E0E0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ctrl.dniInvalido.value
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  errorText: ctrl.dniInvalido.value
                      ? 'DNI debe tener 13 caracteres (0000-0000-0000)'
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Teléfono
            Obx(
              () => TextField(
                controller: ctrl.telefono,
                keyboardType: TextInputType.number,
                onChanged: ctrl.onTelefonoChanged,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                decoration: InputDecoration(
                  labelText: "Teléfono",
                  hintText: "Ej: 0000-0000",
                  labelStyle: const TextStyle(
                    color: Color(0xFF8A8A8A),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ctrl.telefonoInvalido.value
                          ? Colors.red
                          : const Color(0xFFE0E0E0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ctrl.telefonoInvalido.value
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  errorText: ctrl.telefonoInvalido.value
                      ? 'Teléfono debe tener 9 caracteres (0000-0000)'
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Notas
            TextField(
              controller: ctrl.notas,
              maxLines: 2,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              decoration: InputDecoration(
                labelText: "Notas (opcional)",
                hintText:
                    "Notas internas sobre el ${esProveedor ? 'proveedor' : 'cliente'}",
                labelStyle: const TextStyle(
                  color: Color(0xFF8A8A8A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                hintStyle: const TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 15,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.3),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () async {
                  await ctrl.validateAndSave();
                  if (!ctrl.nombreInvalido.value &&
                      !ctrl.dniInvalido.value &&
                      !ctrl.telefonoInvalido.value) {
                    SnackbarHelper.show(
                      type: SnackType.success,
                      message: id == null
                          ? '"${esProveedor ? 'Proveedor' : 'Cliente'}" guardado correctamente'
                          : 'Cambios guardados con éxito',
                    );
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
                child: Text("GUARDAR ${esProveedor ? 'PROVEEDOR' : 'CLIENTE'}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
