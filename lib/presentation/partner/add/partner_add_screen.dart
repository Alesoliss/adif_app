import 'dart:io';
import 'package:edu_app/presentation/partner/add/partner_add_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_app/presentation/products/add/product_add_controller.dart';
import 'package:edu_app/routes/app_routes.dart';

class AddPartnerScreen extends StatelessWidget {
  const AddPartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final esProveedor = args['esProveedor'] ?? false; // por defecto cliente
    final id = args['id'] as int?;
    return ChangeNotifierProvider(
    create: (_) => PartnerAddController(esProveedor: esProveedor, id: id),
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Theme.of(
          //   context,
          // ).colorScheme.primary.withOpacity(0.08),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), 
            ),
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
           title: Text(id == null
            ? (esProveedor ? "Agregar proveedor" : "Agregar cliente")
            : (esProveedor ? "Editar proveedor" : "Editar cliente"),
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
        ),

        body: Consumer<PartnerAddController>(
          
          builder: (context, ctrl, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                   Text(
                   "Información del ${esProveedor ? 'proveedor' : 'cliente'}",
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
      labelText: "Nombre",
      hintText: "Ej: Juan Pérez",
      labelStyle: const TextStyle(
        color: Color(0xFF8A8A8A),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: ctrl.nombreInvalido ? Colors.red : const Color(0xFFE0E0E0),
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
      errorText: ctrl.nombreInvalido ? 'El nombre es obligatorio' : null,
    ),
  ),
),                 

  Padding(
  padding: const EdgeInsets.symmetric(vertical: 10),
  child: TextField(
    controller: ctrl.dni,
    keyboardType: TextInputType.number,
    style: const TextStyle(color: Colors.black87, fontSize: 16),
    onChanged: ctrl.onDniChanged,
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
          color: ctrl.dniInvalido ? Colors.red : const Color(0xFFE0E0E0),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: ctrl.dniInvalido
              ? Colors.red
              : Theme.of(context).colorScheme.primary,
        ),
      ),
      errorText: ctrl.dniInvalido ? 'DNI debe tener 13 caracteres (0000-0000-0000)' : null,
    ),
  ),
),

Padding(
  padding: const EdgeInsets.symmetric(vertical: 10),
  child: TextField(
    controller: ctrl.telefono,
    keyboardType: TextInputType.number,
    style: const TextStyle(color: Colors.black87, fontSize: 16),
    onChanged: ctrl.onTelefonoChanged,
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
          color: ctrl.telefonoInvalido ? Colors.red : const Color(0xFFE0E0E0),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: ctrl.telefonoInvalido
              ? Colors.red
              : Theme.of(context).colorScheme.primary,
        ),
      ),
      errorText: ctrl.telefonoInvalido ? 'Teléfono debe tener 9 caracteres (0000-0000)' : null,
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
                        hintText: "Notas internas sobre el ${esProveedor ? 'proveedor' : 'cliente'}",
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

                  const SizedBox(height: 0),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: () async {
                        await ctrl.validateAndSave();
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
            );
          },
        ),
      ),
    );
  }
}
