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
      where: '${ServiceStrings.esProveedor} = ?',
      whereArgs: [isProveedor],
      orderBy: '${ServiceStrings.id} DESC',
    );

    return rows.map((json) => PartnerModel.fromJson(json)).toList();
  }

  // Otros métodos CRUD...
}
