import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/services/services.dart';
import 'package:flutter/material.dart';

class PartnerAddController extends ChangeNotifier { 
  final bool esProveedor;
  final int? id; // ID del socio a editar (null si es nuevo)
  PartnerAddController({this.esProveedor = false,this.id}) {
    print("Inicializando como ${esProveedor ? 'Proveedor' : 'Cliente'}");
    if (id != null) {
      _loadSocio(id!);
    }
  }

  final TextEditingController nombre = TextEditingController();
  final TextEditingController dni = TextEditingController();
  final TextEditingController telefono = TextEditingController();
  final TextEditingController notas = TextEditingController();

  bool nombreInvalido = false;
  bool dniInvalido = false;
  bool telefonoInvalido = false;

  // Reglas de longitud (incluyendo guiones)
  static const int _dniLenWithDashes = 15;      // 0000-0000-0000 -> 14
  static const int _telLenWithDashes = 9;       // 0000-0000       -> 9

  // --------- FORMATTERS (llámalos desde onChanged en la UI) ----------
  void onDniChanged(String value) {
    final formatted = _formatDni(value);
    // Reemplazamos el valor manteniendo el cursor al final
    dni.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    // Validación live (opcional)
    dniInvalido = formatted.isNotEmpty && formatted.length != _dniLenWithDashes;
    notifyListeners();
  }

  void onTelefonoChanged(String value) {
    final formatted = _formatTelefono(value);
    telefono.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    telefonoInvalido =
        formatted.isNotEmpty && formatted.length != _telLenWithDashes;
    notifyListeners();
  }

   Future<void> _loadSocio(int id) async {
    try {
      final db = await DatabaseHelper.initDB();
      final result = await db.query(
        ServiceStrings.socios,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isNotEmpty) {
        final socio = PartnerModel.fromJson(result.first);
        nombre.text = socio.nombre;
        dni.text = socio.dni ?? '';
        telefono.text = socio.telefono ?? '';
        notas.text = socio.notas ?? '';
        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ No se pudo cargar el socio: $e");
    }
  }

  Future<void> validateAndSave() async {
    // Validamos
    nombreInvalido = nombre.text.trim().isEmpty;
    dniInvalido =
        dni.text.isNotEmpty && dni.text.length != _dniLenWithDashes;
    telefonoInvalido =
        telefono.text.isNotEmpty && telefono.text.length != _telLenWithDashes;

    notifyListeners();

    if (nombreInvalido || dniInvalido || telefonoInvalido) return;

    await _saveSocio();
  }

 Future<void> _saveSocio() async {
    try {
      final partner = PartnerModel(
        id: id,
        nombre: nombre.text.trim(),
        dni: dni.text.trim().isEmpty ? "" : dni.text.trim(),
        telefono: telefono.text.trim().isEmpty ? "" : telefono.text.trim(),
        notas: notas.text.trim().isEmpty ? "" : notas.text.trim(),
        esProveedor: esProveedor,
      );

      if(id == null){
      await DatabaseHelper.insert(
        ServiceStrings.socios,
        partner.toJson(),
      );
      nuevo();
      debugPrint("✅ Guardado con éxito: ${partner.nombre} con ID: $id");
      }else{
         await DatabaseHelper.update(
          ServiceStrings.socios,
          partner.toJson(),
          id!,
        );
        debugPrint("✏️ Editado con éxito: ${partner.nombre}");
      }
      
    } catch (e, st) {
      debugPrint("❌ No se pudo guardar: $e\n$st");
    }
  }

String _formatDni(String value) {
  var digits = value.replaceAll(RegExp(r'[^0-9]'), '');
  
  if (digits.length > 4 && digits.length <= 8) {
    digits = '${digits.substring(0, 4)}-${digits.substring(4)}';
  } else if (digits.length > 8) {
    final part1 = digits.substring(0, 4);
    final part2 = digits.substring(4, 8);
    final part3 = digits.substring(8, digits.length > 13 ? 13 : digits.length);
    digits = '$part1-$part2-$part3';
  }

  return digits;
}

  String _formatTelefono(String value) {
    var digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 4) {
      digits = '${digits.substring(0, 4)}-${digits.substring(4, digits.length > 8 ? 8 : digits.length)}';
    }
    return digits;
  }

void nuevo() {
  nombre.clear();
  dni.clear();
  telefono.clear();
  notas.clear();

  nombreInvalido = false;
  dniInvalido = false;
  telefonoInvalido = false;

  notifyListeners();
}


  // void disposeAll() {
  //   nombre.dispose();
  //   dni.dispose();
  //   telefono.dispose();
  //   notas.dispose();
  //   super.dispose();
  // }
}
