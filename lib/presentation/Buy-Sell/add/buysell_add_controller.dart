// lib/presentation/buy_sell/add/buysell_add_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:edu_app/models/buy-sell-details.dart';
import 'package:edu_app/models/buy-sell.dart';
import 'package:edu_app/models/product_model.dart';
import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/services/services.dart';
import 'package:edu_app/services/buySellService.dart';
import 'package:edu_app/services/partnerService.dart';

enum PaymentType { contado, credito }

class BuySellAddController extends GetxController {
  BuySellAddController({required bool esCompra, int? id}) {
    this.esCompra.value = esCompra;
    if (id != null) {
      this.id.value = id;
      // aquí cargarías la cabecera y detalles si vas a editar
    }
  }
  // ---------------- Modo ----------------
  final esCompra = false.obs;
  final id = RxnInt(); // null cuando es nuevo

  // ---------------- UI  -----------------
  late final ScrollController scrollCtrl;
  final showFab = false.obs;

  // ---------------- Campos --------------
  final socio = TextEditingController();
  final producto = TextEditingController();
  final fecha   = TextEditingController();

  final detalles = <BuySellDetails>[].obs;
  final nombreInvalido = false.obs;
  final pago = PaymentType.contado.obs;

  // ---------------- Internos ------------
  final PartnerService _partnerService = PartnerService();
  DateTime? _fechaVencimiento;
  int?   socioId;
  int?   socioFinalId;
  String? socioFinalNombre;

  // =================== CICLO DE VIDA =================== //
  @override
  void onInit() {
    super.onInit();

    // Leer argumentos
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    esCompra.value = args['esCompra'] ?? false;
    id.value       = args['id'];

    // FAB / Scroll
    scrollCtrl = ScrollController()
      ..addListener(() {
        showFab.value = scrollCtrl.offset > 200;
      });

    // Pre-cargar info
    _init();
  }

  @override
  void onClose() {
    scrollCtrl.dispose();
    socio.dispose();
    producto.dispose();
    fecha.dispose();
    super.onClose();
  }

  // =================== INIT ============================= //
  Future<void> _init() async {
    if (id.value == null) {
      await _setDefaultPartner();
    } else {
      // TODO: cargar cabecera + detalles para modo edición
    }
  }

  Future<void> _setDefaultPartner() async {
    final defaultName = esCompra.isTrue
        ? 'Proveedor Final'
        : 'Consumidor Final';

    final partner = await _partnerService.getFinalPartner(defaultName);

    socioFinalId     = partner?.id;
    socioFinalNombre = partner?.nombre;

    if (partner != null) {
      setPartner(partner);
    } else {
      Get.log("⚠️ '$defaultName' no existe en BD");
    }
  }

  // =================== PARTNER ========================== //
  void setPartner(PartnerModel partner) {
    socioId = partner.id;
    socio.text = partner.nombre;
    nombreInvalido.value = false;
  }

  void setPartnerSeleccionado(PartnerModel p) {
    setPartner(p);
  }


    void setProductoSeleccionado(ProductoModel p) {
      double precio = 0;
      if(esCompra == true && p.costo != 0){  
        precio = p.costo ?? 0;
        }else if(p.precio != 0){  
        precio = p.precio;
        }
      addEmptyDetalle(productoId: p.id ?? 0, productoNombre: p.nombre, productoprecio: precio);
    }
  // =================== DETALLES ========================= //
  void addEmptyDetalle({
    required int productoId,
    required String productoNombre,
     double? productoprecio,
  }) {

    detalles.add(
      BuySellDetails(
        productoId:    productoId,
        productoNombre:productoNombre,
        precio: productoprecio ?? 0,

      ),
    );
  }

  void updateDetalle({
    required int index,
    double? precio,
    double? cantidad,
    double? factor,
  }) {
    final d = detalles[index];
    if (precio   != null) d.precio   = precio;
    if (cantidad != null) d.cantidad = cantidad;
    if (factor   != null) d.factor   = factor;
    d.recalcular();
    detalles[index] = d; // trigger
  }

  void incrementQuantity(int index) {
    detalles[index].cantidad++;
    detalles[index].recalcular();
    detalles.refresh();
  }

  void decrementQuantity(int index) {
    final d = detalles[index];
    d.cantidad--;
    if (d.cantidad < 1) {
      detalles.removeAt(index);
    } else {
      d.recalcular();
      detalles[index] = d;
    }
  }

  // =================== PAGO / FECHA ===================== //
  bool get fechaInvalida {
    if (pago.value != PaymentType.credito) return false;
    if (_fechaVencimiento == null) return true;
    final hn = DateTime.now().subtract(const Duration(hours: 6));
    final hoyHN = DateTime(hn.year, hn.month, hn.day);
    return _fechaVencimiento!.isBefore(hoyHN);
  }

  void setPaymentType(PaymentType p) {
    pago.value = p;
    if (p == PaymentType.credito) {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      _fechaVencimiento = tomorrow;
      fecha.text = DateFormat('yyyy-MM-dd').format(tomorrow);
    } else {
      _fechaVencimiento = null;
      fecha.clear();
    }
  }

  Future<void> pickFechaVencimiento(BuildContext context) async {
    final hoyHN = DateTime.now().subtract(const Duration(hours: 6));
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaVencimiento ?? hoyHN,
      firstDate: hoyHN,
      lastDate: DateTime(hoyHN.year + 5),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      _fechaVencimiento = picked;
      fecha.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  // =================== CRUD  ============================ //
  Future<void> saveProducto() async {
    final nuevo = ProductoModel(
      nombre: producto.text.trim(),
      precio: 0,
      costo : 0,
      stock : 0,
      cateid: 0,
      notas : '',
      esServicio: false,
    );

    final newId = await DatabaseHelper.insert(
      ServiceStrings.productos,
      nuevo.toJson(),
    );

    addEmptyDetalle(productoId: newId, productoNombre: nuevo.nombre);
    producto.clear();
  }

  Future<void> validateAndSave() async {
    nombreInvalido.value = socio.text.trim().isEmpty;
    if (nombreInvalido.isTrue) return;

    // Si cambió el nombre del “Final” → guardar socio nuevo
    if (socioId == socioFinalId && socio.text != socioFinalNombre) {
      await _saveSocio();
    }

    if (detalles.isEmpty) {
  
      return;
    }

  final listaDetallesLinea = detalles
      .asMap()                       // convierte la lista en un map {indice: elemento}
      .entries                       // iterable de MapEntry<int, Detalle>
      .map((entry) {
        final i = entry.key;         // índice (0, 1, 2…)
        final d = entry.value;       // el objeto Detalle original
        return BuySellDetalleModel(
          ventaId: 0,
          linea: i + 1,              // 1, 2, 3, 4…
          productoId: d.productoId,
          precio: d.precio,
          cantidad: d.cantidad,
          factor: d.factor,
          total: d.total,
        );
      })
      .toList();

     final listaDetalles = listaDetallesLinea
        .map((d) => BuySellDetalleModel(
              ventaId: 0,
              linea: d.linea,
              productoId: d.productoId,
              precio: d.precio,
              cantidad: d.cantidad,
              factor: d.factor,
              total: d.total,
            ))
        .toList();

    final total = detalles.fold<double>(0, (s, d) => s + d.total);

    final cabecera = BuySell(
      sociosId : socioId!,
      fecha    : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      fechaVence: _fechaVencimiento != null
          ? DateFormat('yyyy-MM-dd').format(_fechaVencimiento!)
          : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      total    : total,
      esCredito: pago.value == PaymentType.credito,
      saldo    : pago.value == PaymentType.credito ? total : 0,
      comentario: '',
      detalles: listaDetalles,
    );

    try {
      if (esCompra.isTrue) {
        final id = await BuySellService.saveCompra(cabecera);
        
      } else {
        final id = await BuySellService.saveVenta(cabecera);

      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar',
          snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> _saveSocio() async {
    final partner = PartnerModel(
      nombre: socio.text.trim(),
      esProveedor: esCompra.isTrue,
    );
    socioId = await DatabaseHelper.insert(
      ServiceStrings.socios,
      partner.toJson(),
    );
  }
}
