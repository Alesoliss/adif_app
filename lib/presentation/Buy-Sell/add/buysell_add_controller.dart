import 'package:edu_app/models/buy-sell-details.dart';
import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/services/partnerService.dart';
import 'package:edu_app/services/services.dart';
import 'package:flutter/material.dart';
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
  int? socioId;
  int? SocioIDValidacion;
  String? SocioNombreValidacion;
  bool seleccionado = false;
final List<BuySellDetails> detalles = [];
    int? productoId;


void addEmptyDetalle({required int compraId, required int productoId, required String productoNombre}) {
    final nextLinea = detalles.length + 1;
    final d = BuySellDetails(
        productoNombre: productoNombre,  // ← aquí
      compraId: compraId,
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
    notifyListeners();
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

   Future<void> _saveProducto() async {
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


  bool validate() {
    nombreInvalido = socio.text.trim().isEmpty;
    notifyListeners();
    return !nombreInvalido;
  }

  @override
  void dispose() {
    socio.dispose();
    super.dispose();
  }
}
