import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/services/services.dart';
import 'package:sqflite/sqflite.dart';

class PartnerService {
  final String table = ServiceStrings.socios;

  Future<List<PartnerModel>> getAllPartners(String name) async {
    final db = await DatabaseHelper.initDB();
    
    // Determinamos si es proveedor o cliente
    final isProveedor = name == ServiceStrings.proveedores ? 1 : 0;


  final rows = await db.query(
    table,
    where: ' nombre NOT IN (?, ?)',
    whereArgs: [ 'Consumidor Final', 'Proveedor Final'],
    orderBy: '${ServiceStrings.id} DESC',
  );

    return rows.map((json) => PartnerModel.fromJson(json)).toList();
  }

  Future<PartnerModel?> getFinalPartner(String name) async {
  final db = await DatabaseHelper.initDB();

  final rows = await db.query(
    table,
    where: 'nombre = ?',
    whereArgs: [name], // ej: 'Consumidor Final' o 'Proveedor Final'
    limit: 1,
  );

  if (rows.isNotEmpty) {
   final model = PartnerModel.fromJson(rows.first);
    print('🔍 Parsed PartnerModel: id=${model.id}, nombre="${model.nombre}"');
    return model;
  }
  return null;
}

  // Otros métodos CRUD...
}
