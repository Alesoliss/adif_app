// lib/presentation/partner/add/partner_add_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/services/services.dart';

class PartnerAddController extends GetxController {

    PartnerAddController({bool esProveedor = false, int? id}) {
    this.esProveedor.value = esProveedor;
    if (id != null) {
      this.id.value = id;
      _loadSocio(id);
    }
  }
  // --- Estado base ---
  final nombre = TextEditingController();
  final dni = TextEditingController();
  final telefono = TextEditingController();
  final notas = TextEditingController();

  // Flags de validación (reactivos)
  final nombreInvalido = false.obs;
  final dniInvalido = false.obs;
  final telefonoInvalido = false.obs;

  // Modo / argumentos
  final esProveedor = false.obs;
  final id = RxnInt();

  // Reglas de longitud (incluyendo guiones)
  static const int _dniLenWithDashes = 15; // 0000-0000-00000 => 15
  static const int _telLenWithDashes = 9;  // 0000-0000 => 9

  @override
  void onInit() {
    super.onInit();
    // Lee argumentos: { esProveedor: bool, id: int? }
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    esProveedor.value = args['esProveedor'] ?? false;
    final int? maybeId = args['id'];
    if (maybeId != null) {
      id.value = maybeId;
      _loadSocio(maybeId);
    }
  }

  // --------- FORMATTERS (llámalos desde onChanged en la UI) ----------
  void onDniChanged(String value) {
    final formatted = _formatDni(value);
    dni.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    // Validación live (opcional)
    dniInvalido.value =
        formatted.isNotEmpty && formatted.length != _dniLenWithDashes;
  }

  void onTelefonoChanged(String value) {
    final formatted = _formatTelefono(value);
    telefono.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    telefonoInvalido.value =
        formatted.isNotEmpty && formatted.length != _telLenWithDashes;
  }

  Future<void> _loadSocio(int socioId) async {
    try {
      final db = await DatabaseHelper.initDB();
      final result = await db.query(
        ServiceStrings.socios,
        where: 'id = ?',
        whereArgs: [socioId],
        limit: 1,
      );

      if (result.isNotEmpty) {
        final socio = PartnerModel.fromJson(result.first);
        nombre.text = socio.nombre;
        dni.text = socio.dni ?? '';
        telefono.text = socio.telefono ?? '';
        notas.text = socio.notas ?? '';
      }
    } catch (e) {
      debugPrint("❌ No se pudo cargar el socio: $e");
    }
  }

  Future<void> validateAndSave() async {
    // Validaciones simples
    nombreInvalido.value = nombre.text.trim().isEmpty;
    dniInvalido.value =
        dni.text.isNotEmpty && dni.text.length != _dniLenWithDashes;
    telefonoInvalido.value =
        telefono.text.isNotEmpty && telefono.text.length != _telLenWithDashes;

    if (nombreInvalido.value || dniInvalido.value || telefonoInvalido.value) {
      return;
    }

    await _saveSocio();
  }

  Future<void> _saveSocio() async {
    try {
      final partner = PartnerModel(
        id: id.value,
        nombre: nombre.text.trim(),
        dni: dni.text.trim(),
        telefono: telefono.text.trim(),
        notas: notas.text.trim(),
        esProveedor: esProveedor.value,
      );

      if (id.value == null) {
        // Insert
         print("GUARDADO CON EXITO:" + partner.toJson().toString());
        final newId = await DatabaseHelper.insert(
          ServiceStrings.socios,
          partner.toJson(),
        );
        print("GUARDADO CON EXITO:" + newId.toString());
        id.value = newId;
        nuevo(); // Limpia para capturar otro
      } else {
        // Update
        await DatabaseHelper.update(
          ServiceStrings.socios,
          partner.toJson(),
          id.value!,
        );
        // Si prefieres volver, descomenta:
        // Get.back(result: true);
      }
    } catch (e, st) {
      debugPrint("❌ No se pudo guardar: $e\n$st");
      Get.snackbar('Error', 'No se pudo guardar',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void nuevo() {
    nombre.clear();
    dni.clear();
    telefono.clear();
    notas.clear();
    nombreInvalido.value = false;
    dniInvalido.value = false;
    telefonoInvalido.value = false;
    id.value = null;
  }

  String _formatDni(String value) {
    // 13 dígitos → 4-4-5 => 0000-0000-00000 (Honduras)
    var digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 4 && digits.length <= 8) {
      digits = '${digits.substring(0, 4)}-${digits.substring(4)}';
    } else if (digits.length > 8) {
      final part1 = digits.substring(0, 4);
      final part2 = digits.substring(4, 8);
      final part3 =
          digits.substring(8, digits.length > 13 ? 13 : digits.length);
      digits = '$part1-$part2-$part3';
    }
    return digits;
  }

  String _formatTelefono(String value) {
    var digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 4) {
      digits =
          '${digits.substring(0, 4)}-${digits.substring(4, digits.length > 8 ? 8 : digits.length)}';
    }
    return digits;
  }

  @override
  void onClose() {
    nombre.dispose();
    dni.dispose();
    telefono.dispose();
    notas.dispose();
    super.onClose();
    super.onClose();
  }
}
