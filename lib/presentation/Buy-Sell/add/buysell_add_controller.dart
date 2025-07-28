import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/services/partnerService.dart';
import 'package:flutter/material.dart';

class BuySellAddController extends ChangeNotifier {
  final bool esCompra; // true = compra(proveedor), false = venta(cliente)
  final int? id;       // id de la compra/venta (si estás editando)
  BuySellAddController({this.esCompra = false, this.id}) {
    debugPrint("Inicializando como ${esCompra ? 'Compra' : 'Venta'}");
    // si id != null, podrías cargar la cabecera + detalles aquí.
  }

  final PartnerService _service = PartnerService();
  // socio seleccionado
  final TextEditingController socio = TextEditingController();
  int? socioId;

  // validaciones básicas
  bool nombreInvalido = false;

  void setPartner(PartnerModel partner) {
    socio.text = partner.nombre;
    socioId = partner.id;
    nombreInvalido = false;
    notifyListeners();
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
