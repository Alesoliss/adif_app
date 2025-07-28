import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/services/partnerService.dart';
import 'package:edu_app/services/services.dart';
import 'package:flutter/material.dart';

class PartnerController extends ChangeNotifier {
  final PartnerService _service;
  String name; // clientes o proveedores

  PartnerController(this._service, {required this.name}) {
        print("Entra");
    _init();
  }

  List<PartnerModel> _partners = [];
  bool _loading = false;
  bool isProveedores = true;
  List<PartnerModel> get partners => _partners;
  bool get loading => _loading;

  Future<void> _init() async {
    await loadPartners();
  }

  Future<void> loadPartners() async {
    print("Entra");
    _loading = true;
    notifyListeners();

    _partners = await _service.getAllPartners(name);
    print(_partners);
    _loading = false;
    notifyListeners();
  }


void togglePartnerType() {
  isProveedores = !isProveedores;
  name = isProveedores ? ServiceStrings.proveedores : ServiceStrings.clientes;
  loadPartners();
  notifyListeners();
}
  
  
}
