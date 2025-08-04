// lib/presentation/buy_sell/add/add_buy_sell_screen.dart
import 'package:edu_app/models/buy-sell-details.dart';
import 'package:edu_app/models/product_model.dart';
import 'package:edu_app/presentation/products/list/products_controller.dart';
import 'package:edu_app/presentation/products/list/products_screen.dart';
import 'package:edu_app/shared_components/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import 'buysell_add_controller.dart';
import '../../partner/list/partner_screen.dart';
import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/services/services.dart';
class BuySellAddBinding extends Bindings {
  @override
  void dependencies() {
   
  }
}
class AddBuySellScreen extends GetView<BuySellAddController> {
  
  const AddBuySellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = Get.arguments as Map<String, dynamic>? ?? {};
      Get.put(
        BuySellAddController(
          esCompra: args['esCompra'] ?? false,
          id: args['id'],
        ),
      );
    return Scaffold(
      appBar: _buildAppBar(theme),
      body: _buildBody(theme, context),
      bottomNavigationBar: _buildFooter(theme),
     floatingActionButton: Obx(() => Visibility(
      visible: controller.showFab.value,
      maintainSize: true,   // evita re-layout brusco
      maintainAnimation: true,
      maintainState: true,
      child: FloatingActionButton(
        onPressed: () {
          if (controller.producto.text.trim().isNotEmpty) {
            controller.saveProducto();
          }
        },
        child: const Icon(Icons.add),
      ),
)),

    );
  }

  // -------------------- APPBAR ---------------------------
  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            shadowColor: Colors.black12,
            elevation: 1,
          ),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: Get.back,
        ),
      ),
      centerTitle: true,
      title: Obx(() {
        final isEdit = controller.id.value != null;
        final isCompra = controller.esCompra.value;
        return Text(
          isEdit
              ? (isCompra ? 'Detalles compra' : 'Detalles venta')
              : (isCompra ? 'Agregar compra' : 'Agregar venta'),
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 17),
        );
      }),
    );
  }

  // -------------------- CUERPO ---------------------------
  Widget _buildBody(ThemeData theme, BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        controller: controller.scrollCtrl,
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Socio -----
            Text(
              controller.esCompra.isTrue
                  ? 'Información del proveedor'
                  : 'Información del cliente',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    readOnly: controller.socioId != null,
                    controller: controller.socio,
                    decoration: InputDecoration(
                      labelText:
                          controller.esCompra.isTrue ? 'Proveedor' : 'Cliente',
                      hintText: controller.esCompra.isTrue
                          ? 'Selecciona un proveedor'
                          : 'Selecciona un cliente',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: controller.nombreInvalido.isTrue
                              ? Colors.red
                              : const Color(0xFFE0E0E0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: controller.nombreInvalido.isTrue
                              ? Colors.red
                              : theme.colorScheme.primary,
                        ),
                      ),
                      errorText: controller.nombreInvalido.isTrue
                          ? 'El ${controller.esCompra.isTrue ? 'proveedor' : 'cliente'} es obligatorio'
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      final selected = await _openPartnerSelector(
                          context, controller.esCompra.value);
                      if (selected != null) {
                        controller.setPartnerSeleccionado(selected);
                      }
                    },
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ----- Producto -----
            if (!controller.showFab.value)
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: controller.producto,
                      decoration: const InputDecoration(
                        labelText: 'Producto',
                        hintText: 'Selecciona o escribe un producto',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: ()async  {
                        if (controller.producto.text.trim().isNotEmpty) {
                          controller.saveProducto();
                        }else{
                         final selected = await _openProductSelector(context);
                      if (selected != null) {
                        controller.setProductoSeleccionado(selected);
                      } 
       }
                      },
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),

            // ----- Tipo de pago -----
            Row(
              children: [
                _pagoButton(context, PaymentType.contado, 'Contado'),
                const SizedBox(width: 10),
                _pagoButton(context, PaymentType.credito, 'Crédito'),
              ],
            ),

            // ----- Fecha vencimiento -----
            if (controller.pago.value == PaymentType.credito)
              TextField(
                controller: controller.fecha,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha de vencimiento',
                  hintText: 'Selecciona la fecha',
                  suffixIcon: const Icon(Icons.calendar_today),
                  errorText: controller.fechaInvalida
                      ? 'La fecha es obligatoria'
                      : null,
                ),
                onTap: () => controller.pickFechaVencimiento(context),
              ),

            const SizedBox(height: 20),

            // ----- Detalles -----
            if (controller.detalles.isNotEmpty) ...[
              const Text('Detalles:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.detalles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final d = controller.detalles[i];
                  return _DetalleCard(
                    detalle: d,
                    index: i,
                    esCompra: controller.esCompra.value,
                    onUpdate: controller.updateDetalle,
                    onInc: controller.incrementQuantity,
                    onDec: controller.decrementQuantity,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // -------------------- FOOTER ---------------------------
  Widget _buildFooter(ThemeData theme) {
    return Obx(() {
      final total = controller.detalles.fold<double>(
          0, (s, d) => s + d.total);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Total: LPS ${total.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            onPressed: () async {
                final saved = await controller.validateAndSave();   
                  if (controller.detalles.isEmpty) {
 SnackbarHelper.show(
                            type: SnackType.error,
                            message:  'Debe tener un producto por lo menos'
                          );
                }
                if (!controller.nombreInvalido.isTrue && !controller.detalles.isEmpty) {
 SnackbarHelper.show(
                            type: SnackType.success,
                            message:  'La ${controller.esCompra.isTrue ? 'compra' : 'venta'} guarada correctamente'
                          );
                }
              },
              child: Obx(() => Text(
                    'GUARDAR ${controller.esCompra.isTrue ? 'COMPRA' : 'VENTA'}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  )),
            ),
          ],
        ),
      );
    });
  }

  // -------------------- UTILS ----------------------------
  Widget _pagoButton(BuildContext ctx, PaymentType tipo, String label) {
    final isSelected = controller.pago.value == tipo;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? Theme.of(ctx).colorScheme.primary : Colors.transparent,
          foregroundColor:
              isSelected ? Colors.white : Theme.of(ctx).colorScheme.primary,
          side: BorderSide(color: Theme.of(ctx).colorScheme.primary),
          elevation: 0,
        ),
        onPressed: () => controller.setPaymentType(tipo),
        child: Text(label),
      ),
    );
  }

  Future<PartnerModel?> _openPartnerSelector(
      BuildContext context, bool esCompra) {
    return showModalBottomSheet<PartnerModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => PartnerScreen(
        onSelect: (p) => Navigator.pop(context, p),
        initialName:
            esCompra ? ServiceStrings.proveedores : ServiceStrings.clientes,
      ),
    );
  }

   Future<ProductoModel?> _openProductSelector(BuildContext context) {
      final idsYaSeleccionados =controller.detalles.map((d) => d.productoId).toSet();
      final esCompraSeleccionado = controller.esCompra.value ?? false;

  final prodCtrl = Get.isRegistered<ProductsController>()
      ? Get.find<ProductsController>()          // ya existe
      : Get.put(ProductsController());          // se crea nuevo

  // 3️⃣  Limpiar / fijar filtros solo en esa instancia
  prodCtrl.resetFilters(estado: ProductoEstado.activos);
  return showModalBottomSheet<ProductoModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ProductsScreen(
      onSelect: (p) => Navigator.pop(context, p),
      excludeIds: idsYaSeleccionados,
      esCompra : esCompraSeleccionado ?? false
    ),
  );
}


}
  class _DetalleCard extends StatelessWidget {
  final BuySellDetails detalle;
  final int index;
  final bool esCompra;
  final void Function({
    required int index,
    double? precio,
    double? cantidad,
    double? factor,
  }) onUpdate;
  final void Function(int) onInc;
  final void Function(int) onDec;

  const _DetalleCard({
    required this.detalle,
    required this.index,
    required this.esCompra,
    required this.onUpdate,
    required this.onInc,
    required this.onDec,
  });

  @override
  Widget build(BuildContext context) {
    final d = detalle;
    return Card(
      color: Colors.white,
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Producto
            Text(
              d.productoNombre,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Precio + Cantidad (50/50)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: 'Precio',
                        isDense: true,
                        border: UnderlineInputBorder()),
                    controller: TextEditingController(
                        text: d.precio.toStringAsFixed(2)),
                                                               inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
                    onChanged: (v) => onUpdate(
                        index: index,
                        precio: double.tryParse(v) ?? 0),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cantidad',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      
                      Row(
                        children: [
                          _CircleIconButton(
                            icon: Icons.remove,
                            onTap: () => onDec(index),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                        vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                              ),
                              controller: TextEditingController(
                                  text: d.cantidad
                                      .toStringAsFixed(0)),
                                                          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
                              onChanged: (v) => onUpdate(
                                  index: index,
                                  cantidad:
                                      double.tryParse(v) ?? 1),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _CircleIconButton(
                            icon: Icons.add,
                            onTap: () => onInc(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Factor (solo compras) + Total
            if (esCompra)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType
                          .numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Factor',
                        isDense: true,
                        border: UnderlineInputBorder(),
                      ),
                      controller: TextEditingController(
                          text: d.factor.toStringAsFixed(2)),
                                                                                    inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
                      onChanged: (v) => onUpdate(
                          index: index,
                          factor: double.tryParse(v) ?? 1),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    'LPS ${d.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            else
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'LPS ${d.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}