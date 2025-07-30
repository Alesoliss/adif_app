import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/presentation/Buy-Sell/add/buysell_add_controller.dart';
import 'package:edu_app/presentation/partner/list/partner_screen.dart';
import 'package:edu_app/presentation/partner/list/partner_screen_controller.dart';
import 'package:edu_app/services/partnerService.dart';
import 'package:edu_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBuySellScreen extends StatelessWidget {
  const AddBuySellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final bool esCompra = args['esCompra'] ?? false;
    final int? id = args['id'] as int?;

    return ChangeNotifierProvider(
      create: (_) => BuySellAddController(esCompra: esCompra, id: id),
      child: Scaffold(
        appBar: AppBar(
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
          centerTitle: true,
          title: Text(
            id == null
                ? (esCompra ? "Agregar compra" : "Agregar venta")
                : (esCompra ? "Detalles compra" : "Detalles venta"),
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
        ),
        body: Consumer<BuySellAddController>(
          builder: (context, ctrl, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
             
                  Text(
                    esCompra ? "Información del proveedor" : "Información del cliente",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),

                  // Nombre (75%) + botón buscar (25%)
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            readOnly: ctrl.seleccionado,
                            controller: ctrl.socio,
                            style: const TextStyle(color: Colors.black87, fontSize: 16),
                            decoration: InputDecoration(
                              labelText: esCompra ? "Proveedor" : "Cliente",
                              hintText: esCompra ? "Selecciona un proveedor" : "Selecciona un cliente",
                              labelStyle: const TextStyle(
                                color: Color(0xFF8A8A8A),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ctrl.nombreInvalido ? Colors.red : const Color(0xFFE0E0E0),
                                  width: 1.3,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ctrl.nombreInvalido
                                      ? Colors.red
                                      : Theme.of(context).colorScheme.primary,
                                  width: 1.6,
                                ),
                              ),
                              errorText: ctrl.nombreInvalido
                                ? 'El ${esCompra ? 'proveedor' : 'cliente'} es obligatorio'
                                : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                          
                            final selectedPartner = await _openPartnerSelector(
                              context,
                              esCompra: esCompra,
                            );
                            if (selectedPartner != null && context.mounted) {
                              context.read<BuySellAddController>().setPartnerSeleccionado(selectedPartner);
                            }
                          },
                          child: const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

// --- Row de Producto + botón “+” ---
Row(
  children: [
    Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          controller: ctrl.producto,
          readOnly: false, // o ctrl.productoSeleccionado si quieres que pase a solo-lectura tras elegir
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          decoration: InputDecoration(
            labelText: 'Producto',
            hintText: 'Selecciona o escribe un producto',
            labelStyle: const TextStyle(
              color: Color(0xFF8A8A8A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          
          ),
        ),
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      flex: 1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () async {
          // Aquí abres tu selector de productos (similiar a _openPartnerSelector)
          if (ctrl.producto.text.trim().length > 0) {
            
          }else{ 
            print("AGREGANDO LLISTAAAAA");
          }
          // final selectedProduct = await _openProductSelector(context);
          // if (selectedProduct != null && context.mounted) {
          //   context.read<BuySellAddController>().addProduct(selectedProduct);
          // }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    ),
  ],
),
if (ctrl.detalles.isNotEmpty) ...[
  Text('Detalles:', style: TextStyle(fontWeight: FontWeight.bold)),
  const SizedBox(height: 8),
  ListView.separated(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: ctrl.detalles.length,
    separatorBuilder: (_, __) => const Divider(),
    itemBuilder: (_, i) {
      final d = ctrl.detalles[i];
      return ListTile(
        leading: Text('${d.linea}.'),
        title: Text('Producto ID: ${d.productoId}'),
        subtitle: Text(
          'Precio: ${d.precio.toStringAsFixed(2)}  ×  Cantidad: ${d.cantidad.toStringAsFixed(2)}  ×  Factor: ${d.factor.toStringAsFixed(2)}',
        ),
        trailing: Text('\$${d.total.toStringAsFixed(2)}'),
        onTap: () {
          // Opcional: abrir un diálogo para editar precio/cant/factor y luego:
          // ctrl.updateDetalle(index: i, precio: nuevoPrecio, cantidad: nuevaCant, factor: nuevoFactor);
        },
      );
    },
  ),
  const SizedBox(height: 20),
],
const SizedBox(height: 20),

Row(
  children: [
    Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ctrl.pago == PaymentType.contado
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          foregroundColor: ctrl.pago == PaymentType.contado
              ? Colors.white
              : Theme.of(context).colorScheme.primary,
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          elevation: 0,
        ),
        onPressed: () => ctrl.setPaymentType(PaymentType.contado),
        child: const Text('Contado'),
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ctrl.pago == PaymentType.credito
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          foregroundColor: ctrl.pago == PaymentType.credito
              ? Colors.white
              : Theme.of(context).colorScheme.primary,
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          elevation: 0,
        ),
        onPressed: () => ctrl.setPaymentType(PaymentType.credito),
        child: const Text('Crédito'),
      ),
    ),
  ],
),

const SizedBox(height: 30),
                  SizedBox(
    width: double.infinity,
    height: 50,
    child: FilledButton(
      onPressed: () async {
        // Llama a tu método de validación/guardado en el controller
        await ctrl.validateAndSave();
      },
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      // Aquí renderizamos el texto según esCompra
      child: Text("GUARDAR ${esCompra ? 'COMPRA' : 'VENTA'}"),
    ),
  ),

                  // ... aquí irán el resto de campos de la compra/venta (productos, totales, etc.)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Abre un modal con la lista de socios (clientes o proveedores)
 Future<PartnerModel?> _openPartnerSelector(BuildContext context, {required bool esCompra}) async {
  return showModalBottomSheet<PartnerModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return PartnerScreen(
        onSelect: (partner) {
          Navigator.pop(context, partner);
        },
           initialName: esCompra
            ? ServiceStrings.proveedores
            : ServiceStrings.clientes, 
      );
    },
  );
}
}

/// ------- Hoja modal para seleccionar socio --------
class _PartnerPickerSheet extends StatelessWidget {
  const _PartnerPickerSheet({required this.isProveedor});

  final bool isProveedor;

  @override
  Widget build(BuildContext context) {
    final service = PartnerService();

    return ChangeNotifierProvider(
      create: (_) => PartnerController(
        service,
        name: isProveedor ? ServiceStrings.proveedores : ServiceStrings.clientes,
      ),
      builder: (context, _) {
        final ctrl = context.watch<PartnerController>();
        return SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isProveedor ? "Selecciona un proveedor" : "Selecciona un cliente",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ctrl.loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: ctrl.partners.length,
                        itemBuilder: (context, index) {
                          final partner = ctrl.partners[index];
                          return ListTile(
                            title: Text(partner.nombre),
                            subtitle: Text((partner.telefono ?? '').isEmpty
                                ? (partner.dni ?? '')
                                : '${partner.telefono}  ${partner.dni ?? ''}'),
                            onTap: () {
                              Navigator.pop(context, partner);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
