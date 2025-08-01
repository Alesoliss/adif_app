import 'package:edu_app/models/buy-sell-details.dart';
import 'package:edu_app/models/buy-sell.dart';
import 'package:edu_app/models/product_model.dart';
import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/services/buySellService.dart';
import 'package:edu_app/services/partnerService.dart';
import 'package:edu_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
enum PaymentType { contado, credito }
class BuySellAddController extends ChangeNotifier {
  final bool esCompra; // true = compra(proveedor), false = venta(cliente)
  final int? id;       // id de la compra/venta (si estás editando)
  BuySellAddController({this.esCompra = false, this.id}) {
    debugPrint("Inicializando como ${esCompra ? 'Compra' : 'Venta'}");
    // si id != null, podrías cargar la cabecera + detalles aquí.
        _init(); // ✅ Llama la inicialización aquí
  }

  final PartnerService _service = PartnerService();
  // socio seleccionado
  final TextEditingController socio = TextEditingController();
  final TextEditingController producto = TextEditingController();
  final TextEditingController fecha = TextEditingController();
bool get fechaInvalida {
  if (pago != PaymentType.credito) return false;
  if (_fechaVencimiento == null) return true;

  // 1) Hora actual en UTC:
  final nowUtc = DateTime.now().toUtc();
  // 2) Convertimos a Honduras (UTC-6):
  final hn = nowUtc.subtract(const Duration(hours: 6));
  // 3) Normalizamos a medianoche HN:
  final hoyHn = DateTime(hn.year, hn.month, hn.day);

  // Si la fecha vencimiento es ANTES de hoy en HN → inválida
  return _fechaVencimiento!.isBefore(hoyHn);
}
  // Guarda internamente la fecha seleccionada
  DateTime? _fechaVencimiento;
  int? socioId;
  int? SocioIDValidacion;
  String? SocioNombreValidacion;
  bool seleccionado = false;
final List<BuySellDetails> detalles = [];
    int? productoId;


void addEmptyDetalle({required int productoId, required String productoNombre}) {
    final nextLinea = detalles.length + 1;
    final d = BuySellDetails(
      productoNombre: productoNombre,  // ← aquí
      linea: nextLinea,
      productoId: productoId,
    );
    detalles.add(d);
    notifyListeners();
  }

  /// Recalcula total de una línea concreta
  void updateDetalle({
    required int index,
    double? precio,
    double? cantidad,
    double? factor,
  }) {
    final d = detalles[index];
    if (precio != null) d.precio = precio;
    if (cantidad != null) d.cantidad = cantidad;
    if (factor != null) d.factor = factor;
    d.recalcular();
    notifyListeners();
  }
  // validaciones básicas
  bool nombreInvalido = false;

   PaymentType pago = PaymentType.contado;
void setPaymentType(PaymentType p) {
  pago = p;
  if (p == PaymentType.credito) {
    // Hora local ya viene bien
    final ahora = DateTime.now();
    // Normalizamos a medianoche de hoy
    final hoyDate = DateTime(ahora.year, ahora.month, ahora.day);
    // Mañana
    final mananaDate = hoyDate.add(- const Duration(days: 1));

    _fechaVencimiento = mananaDate;
    fecha.text = DateFormat('yyyy-MM-dd').format(mananaDate);
  } else {
    _fechaVencimiento = null;
    fecha.clear();
  }
  notifyListeners();
}
Future<void> pickFechaVencimiento(BuildContext context) async {
  // UTC actual menos 6 horas = hora de Honduras
  final nowUtc = DateTime.now().toUtc();
  final honduras = nowUtc.subtract(const Duration(hours: 6));

  // Normalizamos a medianoche en Honduras
  final hoyDate = DateTime(honduras.year, honduras.month, honduras.day);

  final picked = await showDatePicker(
    context: context,
    initialDate: _fechaVencimiento ?? hoyDate,
    firstDate: hoyDate,
    lastDate: DateTime(hoyDate.year + 5, hoyDate.month, hoyDate.day),
    locale: const Locale('es', 'ES'),
  );

  if (picked != null) {
    _fechaVencimiento = picked;
    fecha.text = DateFormat('yyyy-MM-dd').format(picked);
    notifyListeners();
  }
}

  void setPartner(PartnerModel partner) {
    socio.text = partner.nombre;
    socioId = partner.id;
    nombreInvalido = false;
    notifyListeners();
  }
    void setPartnerSeleccionado(PartnerModel partner) {
    seleccionado = true;
    notifyListeners();
    setPartner(partner);
  }
  Future<void> _init() async {
  
    if (id == null) {
      await setDefaultPartner(); // ✅ Solo si estás creando, no editando
    } else {
      // Aquí puedes cargar datos existentes por ID si estás editando
    }
  }
Future<void> setDefaultPartner() async {
  final defaultName = esCompra ? 'Proveedor Final' : 'Consumidor Final';
  final partner = await _service.getFinalPartner(defaultName);
   
  SocioIDValidacion = partner?.id;
  SocioNombreValidacion = partner?.nombre;

  if (partner != null) {
     print("cuanto entraaaaa");
    setPartner(partner);
  } else {
    debugPrint("⚠️ No se encontró el socio '$defaultName' en la base de datos");
  }
}

Future<void> validateAndSave() async {
nombreInvalido = socio.text.trim().isEmpty;
 notifyListeners();
if (nombreInvalido) return;
print(socio);
print(SocioNombreValidacion);

if (socioId == SocioIDValidacion && socio.text != SocioNombreValidacion) {
   await _saveSocio();
}
if(detalles.length > 0) {
  final listaModelos = detalles.map((d) => BuySellDetalleModel(
  ventaId: 0,            // temporal: se asigna tras insertar cabecera
  linea: d.linea,
  productoId: d.productoId,
  costo: d.costo,
  precio: d.precio,
  cantidad: d.cantidad,
  factor: d.factor,
  total: d.total,
)).toList();

    final buySell = BuySell(
    sociosId: socioId!,
    fecha: fecha.text,
    fechaVence: fecha.text,
    total: detalles.sumTotal,
    esCredito: pago == PaymentType.credito,
    saldo: pago == PaymentType.credito ? detalles.sumTotal : 0.0,
    comentario: '',
    detalles: listaModelos,
  );

try {
  if (esCompra) {
    final compraId = await BuySellService.saveCompra(buySell);
    print('Compra insertada OK, ID = ');
  } else {
    final ventaId = await BuySellService.saveVenta(buySell);
    print('Venta insertada OK, ID =');
  }
} catch (error) {
  print('Error al guardar: $error');
  // Aquí puedes mostrar un diálogo, un SnackBar, etc.
}
}
}

 Future<void> _saveSocio() async {
    try {
      final partner = PartnerModel(
        id: null,
        nombre: socio.text.trim(),
        esProveedor: esCompra ? true : false
      );
        print("VA GUARDAR EL SOCIO XD");
      final newId = await DatabaseHelper.insert(
        ServiceStrings.socios,
        partner.toJson(),
      );
      socioId = newId;  
      
      
    } catch (e, st) {
      debugPrint("❌ No se pudo guardar: $e\n$st");
    }
  }
  void incrementQuantity(int index) {
    detalles[index].cantidad++;
    detalles[index].recalcular();
    notifyListeners();
  }
  void decrementQuantity(int index) {
    final d = detalles[index];
    d.cantidad--;
    if (d.cantidad < 1) {
      detalles.removeAt(index);
    } else {
      d.recalcular();
    }
    notifyListeners();
  }
  Future<void> saveProducto() async {
    try {
      final Addproducto = ProductoModel(
        id: null,
        nombre: producto.text.trim(),
        precio: 0,
        costo: 0,
        stock: 0,
        cateid: 0,
        notas: "",
        esServicio: false
      );
        print("VA GUARDAR EL SOCIO XD");
      final newId = await DatabaseHelper.insert(
        ServiceStrings.productos,
        Addproducto.toJson(),
      );

      addEmptyDetalle(productoId: newId,productoNombre:producto.text.trim()); 
      producto.clear();
      
    } catch (e, st) {
      debugPrint("❌ No se pudo guardar: $e\n$st");
    }
  }


  bool validate() {
    nombreInvalido = socio.text.trim().isEmpty;
    notifyListeners();
    return !nombreInvalido;
  }

  @override
  void dispose() {
    socio.dispose();
      fecha.dispose();
    super.dispose();
  }
}
