import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// =================== DATABASE HELPER ===================
class DatabaseHelper {
  static Database? _db;
 static const int _dbVersion = 1; // Aumenta la versión de la DB
  static Future<Database> initDB() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'adif_database.db');
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _upgradeDB(db, oldVersion, newVersion);
      },
    );
    return _db!;
  }

    static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE socios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        dni TEXT,
        telefono TEXT,
        notas TEXT,
        esProveedor INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE categorias(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT
      )
    ''');

    await db.execute(''' 
      CREATE TABLE productos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        precio REAL,
        costo REAL,
        stock REAL,
        cateid INTEGER,
        notas TEXT,
        activo INTEGER,
        esServicio INTEGER,
        img BLOB,
        FOREIGN KEY (cateid) REFERENCES categorias (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ventas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sociosId INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        fechaVence TEXT NOT NULL,
        total REAL NOT NULL,
        esCredito INTEGER NOT NULL DEFAULT 0,
        saldo REAL NOT NULL DEFAULT 0,
        comentario TEXT,
        estado INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE ventas_detalles(
        ventaId INTEGER NOT NULL,
        linea INTEGER NOT NULL,
        productoId INTEGER NOT NULL,
        costo REAL NOT NULL,
        precio REAL NOT NULL,
        cantidad REAL NOT NULL,
        factor REAL NOT NULL,
        total REAL NOT NULL,
        PRIMARY KEY (ventaId, linea),
        FOREIGN KEY (ventaId) REFERENCES ventas(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE compras(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sociosId INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        fechaVence TEXT NOT NULL,
        total REAL NOT NULL,
        esCredito INTEGER NOT NULL DEFAULT 0,
        saldo REAL NOT NULL DEFAULT 0,
        comentario TEXT,
        estado INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE compras_detalles(
        compraId INTEGER NOT NULL,
        linea INTEGER NOT NULL,
        productoId INTEGER NOT NULL,
        costo REAL NOT NULL,
        precio REAL NOT NULL,
        cantidad REAL NOT NULL,
        factor REAL NOT NULL,
        total REAL NOT NULL,
        PRIMARY KEY (compraId, linea),
        FOREIGN KEY (compraId) REFERENCES compras(id) ON DELETE CASCADE
      )
    ''');

await db.execute('''
  CREATE TABLE usuarios(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario TEXT NOT NULL,
    contra TEXT NOT NULL,
    esAdmin INTEGER NOT NULL
  )
''');

await db.execute('''
  CREATE TABLE objetos(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    objeto TEXT NOT NULL,
    estado TEXT NOT NULL
  )
''');

await db.insert('socios', {
  'nombre': 'Proveedor Final',
  'dni': '',
  'telefono': '',
  'notas': 'Proveedor',
  'esProveedor': 1,
});

// Consumidor Final
await db.insert('socios', {
  'nombre': 'Consumidor Final',
  'dni': '',
  'telefono': '',
  'notas': 'Cliente',
  'esProveedor': 0,
});
// Insertar el usuario admin
await db.execute('''
  INSERT INTO usuarios (usuario, contra, esAdmin)
  VALUES ('admin', '@dmin1979', 1)
''');

await db.execute('''
  INSERT INTO usuarios (usuario, contra, esAdmin)
  VALUES ('admin', '@dmin1979', 1)
''');

// Insertar los objetos con estado "Activo"
await db.execute('''
  INSERT INTO objetos (objeto, estado) VALUES
  ('P_Ventas', 'Activo'),
  ('P_Proveedores', 'Activo'),
  ('P_Clientes', 'Activo'),
  ('P_Compras', 'Activo'),
  ('P_Productos', 'Activo')
''');
  }

   static Future<void> _upgradeDB(
      Database db, int oldVersion, int newVersion) async {
   if (oldVersion < 2) {
    // Versión 2: Agregar comentario
    await db.execute('ALTER TABLE ventas ADD COLUMN comentario TEXT;');
    await db.execute('ALTER TABLE compras ADD COLUMN comentario TEXT;');
  }
  if (oldVersion < 3) {
    // Versión 3: Agregar fechaVence
    await db.execute('ALTER TABLE ventas ADD COLUMN fechaVence TEXT;');
    await db.execute('ALTER TABLE compras ADD COLUMN fechaVence TEXT;');
  }
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await initDB();
    return await db.insert(table, data);
  }

  static Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await initDB();
    return await db.query(table);
  }

  static Future<int> update(
      String table, Map<String, dynamic> data, int id) async {
    final db = await initDB();
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> delete(String table, int id) async {
    final db = await initDB();
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}

// =================== SERVICE RESULT ===================
sealed class ServiceResult<T> {
  const ServiceResult();
  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;
}

class Ok<T> extends ServiceResult<T> {
  final T data;
  const Ok(this.data);
}

class Err<T> extends ServiceResult<T> {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  const Err(this.message, {this.error, this.stackTrace});
}

class ServiceStrings {
  // Tablas principales
  static const String socios = "socios";
  static const String categorias = "categorias";
  static const String productos = "productos";
  static const String ventas = "ventas";
  static const String ventasDetalles = "ventas_detalles";
  static const String compras = "compras";
  static const String comprasDetalles = "compras_detalles";

  // Alias para socios
  static const String clientes = "Clientes";
  static const String proveedores = "Proveedores";

  // Columnas comunes
  static const String id = "id";
  static const String nombre = "nombre";
  static const String dni = "dni";
  static const String telefono = "telefono";
  static const String notas = "notas";
  static const String activo = "activo";
  static const String esProveedor = "esProveedor";

  // Columnas productos
  static const String precio = "precio";
  static const String costo = "costo";
  static const String stock = "stock";
  static const String cateid = "cateid";
  static const String img = "img";

  // Columnas ventas y compras
  static const String sociosId = "sociosId";
  static const String fecha = "fecha";
  static const String total = "total";
  static const String esCredito = "esCredito";
  static const String saldo = "saldo";

  // Columnas de detalles
  static const String ventaId = "ventaId";
  static const String compraId = "compraId";
  static const String linea = "linea";
  static const String productoId = "productoId";
  static const String cantidad = "cantidad";
}
