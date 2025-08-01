import 'package:edu_app/models/buy-sell-details.dart';
import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/presentation/Buy-Sell/add/buysell_add_controller.dart';
import 'package:edu_app/presentation/partner/list/partner_screen.dart';
import 'package:edu_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddBuySellScreen extends StatefulWidget {
  final bool esCompra;
  final int? id;
 const AddBuySellScreen({
    Key? key,
    required this.esCompra,
    this.id,
  }) : super(key: key);

  @override
  State<AddBuySellScreen> createState() => _AddBuySellScreenState();
}

class _AddBuySellScreenState extends State<AddBuySellScreen> {
  late final ScrollController _scrollCtrl;
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController()
      ..addListener(() {
        final shouldShow = _scrollCtrl.offset > 200;
        if (shouldShow != _showFab) {
          setState(() => _showFab = shouldShow);
        }
      });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
    Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BuySellAddController(
        esCompra: widget.esCompra,
        id: widget.id,
      ),
      builder: (context, child) {
        return Scaffold(
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
            widget.id == null
                ? (widget.esCompra ? "Agregar compra" : "Agregar venta")
                : (widget.esCompra ? "Detalles compra" : "Detalles venta"),
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
        ),

        // CUERPO SCROLLABLE
        body: Consumer<BuySellAddController>(
           builder: (context, ctrl, _) => SingleChildScrollView(
          controller: _scrollCtrl,             // 1) ASOCIA el controller
            padding: const EdgeInsets.only(
              left: 20, right: 20, top: 14, bottom: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Socio
                Text(
                  widget.esCompra
                      ? "Información del proveedor"
                      : "Información del cliente",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        readOnly: ctrl.seleccionado,
                        controller: ctrl.socio,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                          labelText:
                              widget.esCompra ? "Proveedor" : "Cliente",
                          hintText: widget.esCompra
                              ? "Selecciona un proveedor"
                              : "Selecciona un cliente",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ctrl.nombreInvalido
                                  ? Colors.red
                                  : const Color(0xFFE0E0E0),
                              width: 1.3,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ctrl.nombreInvalido
                                  ? Colors.red
                                  : Theme.of(context)
                                      .colorScheme
                                      .primary,
                              width: 1.6,
                            ),
                          ),
                          errorText: ctrl.nombreInvalido
                              ? 'El ${widget.esCompra ? 'proveedor' : 'cliente'} es obligatorio'
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8))),
                        onPressed: () async {
                          final selectedPartner =
                              await _openPartnerSelector(
                            context,
                            esCompra: widget.esCompra,
                          );
                          if (selectedPartner != null &&
                              context.mounted) {
                            ctrl.setPartnerSeleccionado(
                                selectedPartner);
                          }
                        },
                        child: const Icon(Icons.search,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                // Producto
                 Visibility(
                visible: !_showFab,             // solo se ve cuando NO hemos scrolleado
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: ctrl.producto,
                        decoration: const InputDecoration(
                          labelText: 'Producto',
                          hintText: 'Selecciona o escribe un producto',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (ctrl.producto.text.trim().isNotEmpty) {
                            ctrl.saveProducto();
                          }
                        },
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
                const SizedBox(height: 20),

                // Pago tipo
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor: ctrl.pago ==
                                  PaymentType.contado
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                              : Colors.transparent,
                          foregroundColor: ctrl.pago ==
                                  PaymentType.contado
                              ? Colors.white
                              : Theme.of(context)
                                  .colorScheme
                                  .primary,
                          side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary),
                          elevation: 0,
                        ),
                        onPressed: () => ctrl
                            .setPaymentType(
                                PaymentType.contado),
                        child: const Text('Contado'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor: ctrl.pago ==
                                  PaymentType.credito
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                              : Colors.transparent,
                          foregroundColor: ctrl.pago ==
                                  PaymentType.credito
                              ? Colors.white
                              : Theme.of(context)
                                  .colorScheme
                                  .primary,
                          side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary),
                          elevation: 0,
                        ),
                        onPressed: () => ctrl
                            .setPaymentType(
                                PaymentType.credito),
                        child: const Text('Crédito'),
                      ),
                    ),
                  ],
                ),
            Visibility(
  visible: ctrl.pago == PaymentType.credito,
  child: TextField(
    controller: ctrl.fecha,
    readOnly: true,
    decoration: InputDecoration(
      labelText: 'Fecha de vencimiento',
      hintText: 'Selecciona la fecha',
      suffixIcon: const Icon(Icons.calendar_today),
      border: const UnderlineInputBorder(),
      errorText: ctrl.fechaInvalida
          ? 'La fecha es obligatoria'
          : null,
    ),
    onTap: () => ctrl.pickFechaVencimiento(context),
  ),
),
                const SizedBox(height: 20),

                // Detalles
                if (ctrl.detalles.isNotEmpty) ...[
                  Text('Detalles:',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ctrl.detalles.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final d = ctrl.detalles[i];
                      return _DetalleCard(
                        detalle: d,
                        index: i,
                        esCompra: widget.esCompra,
                        onUpdate: ctrl.updateDetalle,
                        onInc: ctrl.incrementQuantity,
                        onDec: ctrl.decrementQuantity,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),

        // FOOTER FIJO: total general + GUARDAR
        bottomNavigationBar:
            Consumer<BuySellAddController>(
          builder: (context, ctrl, _) {
            final totalGeneral = ctrl.detalles
                .fold<double>(0, (s, d) => s + d.total);

            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4)
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total: LPS ${totalGeneral.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      await ctrl.validateAndSave();
 
                      // feedback / navegación
                    },
                    child: Text(
                      'GUARDAR ${widget.esCompra ? 'COMPRA' : 'VENTA'}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            );
          },
        ),
         floatingActionButton: _showFab
        ? FloatingActionButton(
            onPressed: () {
              final ctrl = context.read<BuySellAddController>();
                print("HOLA CABRON");
            },
            child: const Icon(Icons.add),
          )
        : null,
    
      );
    }
    );
     
  }

  Future<PartnerModel?> _openPartnerSelector(
      BuildContext context,
      {required bool esCompra}) {
    return showModalBottomSheet<PartnerModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PartnerScreen(
        onSelect: (p) => Navigator.pop(context, p),
        initialName: esCompra
            ? ServiceStrings.proveedores
            : ServiceStrings.clientes,
      ),
    );
  }
}

/// Card de cada detalle de línea
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

/// Botón circular personalizado para “–” / “+”
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({
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
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
