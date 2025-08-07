// partner_screen_controller.dart

import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/services/partnerService.dart';
import 'package:edu_app/services/services.dart';
import 'package:get/get.dart';

enum SocioTipo { todos, clientes, proveedores }

class PartnerController extends GetxController {
  
  final PartnerService _service;

  // todo en Rx
  final RxString name;                   // "clientes" o "proveedores"
  final RxBool isProveedores = false.obs;
  final RxBool loading       = false.obs;
  final RxList<PartnerModel> socios    = <PartnerModel>[].obs;
  final Rx<SocioTipo> tipoFiltro       = SocioTipo.todos.obs;
 final bool autoFilterByName;
  PartnerController(
    this._service, {
    required String initialName,
    this.autoFilterByName = false,
  }) : name = initialName.obs {
    _init();
  }


  Future<void> _init() async {
    print(name.value);
    if (autoFilterByName) {
      print("HOLAAAA ENTRA?");
          print(isProveedores.value);
      aplicarFiltros(name.value == ServiceStrings.proveedores ? SocioTipo.proveedores : SocioTipo.clientes);

    }
    await loadPartners();
  }

  Future<void> loadPartners() async {
    loading.value = true;
    final raw = await _service.getAllPartners(name.value);
    socios.assignAll(raw);
    loading.value = false;
  }

  void aplicarFiltros(SocioTipo tipo) {
    tipoFiltro.value = tipo;
    print(tipoFiltro.value);
  }

  

  void togglePartnerType() {
    // cambio name e isProveedores reactivamente
    name.value = isProveedores.value
        ? ServiceStrings.clientes
        : ServiceStrings.proveedores;
    isProveedores.value = !isProveedores.value;
    loadPartners();
  }

}
