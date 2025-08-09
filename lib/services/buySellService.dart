import 'package:edu_app/models/buy-sell.dart';
import 'package:edu_app/services/services.dart';
import 'package:flutter/material.dart';

class BuySellService {
  /// Inserta una compra y sus detalles, y ajusta stock/costo
  static Future<void> saveCompra(BuySell compra) async {
    final db = await DatabaseHelper.initDB();

    // 1) Inserto la cabecera en tabla "compras"
    final compraId = await db.insert(ServiceStrings.compras, {
      'sociosId': compra.sociosId,
      'fecha': compra.fecha,
      'fechaVence': compra.fechaVence,
      'total': compra.total,
      'esCredito': compra.esCredito ? 1 : 0,
      'saldo': compra.esCredito ? compra.total : 0, // en compra, saldo = total
      'comentario': compra.comentario,
      'estado': 1,
      
    });

    // 2) Inserto cada línea en "compras_detalles" y actualizo producto
    for (final det in compra.detalles) {
      await db.insert(ServiceStrings.comprasDetalles, {
        'compraId': compraId,
        'linea': det.linea,
        'productoId': det.productoId,
        'factor': det.factor,
        'precio': det.precio,     // si lo necesitas
        'cantidad': det.cantidad,
        'total': det.total,
      });

      // 3) Ajusto stock y costo en productos
      final prod = (await db.query(
        ServiceStrings.productos,
        columns: ['stock', 'costo'],
        where: 'id = ?',
        whereArgs: [det.productoId],
      )).first;

      final oldStock = prod['stock'] as num;

      final newStock = oldStock + (det.cantidad * det.factor);

      await db.update(
        ServiceStrings.productos,
        {
          'stock': newStock,
          'costo':det.precio
        },
        where: 'id = ?',
        whereArgs: [det.productoId],
      );
    }
  }


Future<List<BuySell>> getAllBuySell() async {
  final db = await DatabaseHelper.initDB();

  const sql = '''
  SELECT *
FROM (
  SELECT  c.id            AS id,
          c.sociosId      AS sociosId,
          s.nombre        AS socios,
          c.fecha         AS fecha,
          c.fechaVence    AS fechaVence,
          c.total         AS total,
          c.esCredito     AS esCredito,
          c.saldo         AS saldo,
          1               AS esCompra,
          c.estado        AS estado
  FROM compras AS c
  INNER JOIN socios AS s ON s.id = c.sociosId

  UNION ALL

  SELECT  v.id            AS id,
          v.sociosId      AS sociosId,
          s.nombre        AS socios,
          v.fecha         AS fecha,
          v.fechaVence    AS fechaVence,
          v.total         AS total,
          v.esCredito     AS esCredito,
          v.saldo         AS saldo,
          0               AS esCompra,
          v.estado        AS estado
  FROM ventas AS v
  INNER JOIN socios AS s ON s.id = v.sociosId
)
ORDER BY fecha DESC, id DESC;
  ''';

  final rows = await db.rawQuery(sql);
  debugPrint(rows.toString());
  return rows.map((json) => BuySell.fromJson(json)).toList();
}


  /// Inserta una venta y sus detalles, y ajusta stock/precio
  static Future<void> saveVenta(BuySell venta) async {
    final db = await DatabaseHelper.initDB();

    // 1) Inserto la cabecera en tabla "ventas"
    final ventaId = await db.insert(ServiceStrings.ventas, {
      'sociosId': venta.sociosId,
      'fecha': venta.fecha,
      'fechaVence': venta.fechaVence,
      'total': venta.total,
      'esCredito': venta.esCredito ? 1 : 0,
      'saldo': venta.esCredito ? venta.total : 0.0,
      'comentario': venta.comentario,
       'estado': 1,
    });

    // 2) Inserto los detalles y actualizo producto
    for (final det in venta.detalles) {
      await db.insert(ServiceStrings.ventasDetalles, {
        'ventaId': ventaId,
        'linea': det.linea,
        'productoId': det.productoId,
        'precio': det.precio,
        'factor': det.factor,
        'cantidad': det.cantidad,
        'total': det.total,
      });

      // 3) Ajusto stock y precio en productos
      final prod = (await db.query(
        ServiceStrings.productos,
        columns: ['stock', 'precio'],
        where: 'id = ?',
        whereArgs: [det.productoId],
      )).first;

      final oldStock = prod['stock'] as num;
      final newStock = oldStock - (det.cantidad * det.factor);

      await db.update(
        ServiceStrings.productos,
        {
          'stock': newStock < 0 ? 0 : newStock,
          'precio': det.precio, 
        },
        where: 'id = ?',
        whereArgs: [det.productoId],
      );
    }
  }
}
