// lib/presentation/Buy-Sell/list/buysell_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:edu_app/models/buy-sell.dart';
import 'package:edu_app/presentation/Buy-Sell/list/buysell_controller.dart';
import 'package:edu_app/routes/app_routes.dart';

final _fmtLps = NumberFormat.currency(
  locale: 'es_HN', // o 'es_ES'
  symbol: 'LPS ',
  decimalDigits: 2,
);

// Estados para filtrar en UI
enum BuyFiltroEstado { todos, anuladas, pagadas, credito }

// Badge/estado visual calculado por registro (el controller lo define)
enum BuyEstadoVisual { anulada, pagada, credito }

class BuySellScreen extends StatelessWidget {
  final bool esCompra;
  BuySellScreen({super.key, this.esCompra = false});

  final controller = Get.put(BuySellController());
  final searchController = TextEditingController();
  final RxString query = ''.obs;

  @override
  Widget build(BuildContext context) {
    final titulo = esCompra ? 'Compras' : 'Ventas';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
              elevation: 1,
            ),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
            onPressed: Get.back,
          ),
        ),
        centerTitle: true,
        title: Text(titulo, style: const TextStyle(color: Colors.black87)),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = controller.filtrarYOrdenar(
                esCompra: esCompra,
                search: query.value,
              );
              if (items.isEmpty) {
                return const Center(child: Text('No hay registros'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, i) => _buySellCard(items[i], context),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddPressed(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // -------------------- Buscar --------------------
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar por socio...',
                  border: InputBorder.none,
                ),
                onChanged: (v) => query.value = v,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- Card --------------------
  Widget _buySellCard(BuySell b, BuildContext context) {
    final theme = Theme.of(context);
    final etiquetaTotal = esCompra ? 'Total compra' : 'Total venta';
    final estadoVisual = controller.calcularEstadoVisual(b);
    final isAbonable = (b.esCredito == true) && ((b.saldo ?? 0) > 0);

    // badge
    final (badgeText, badgeBg, badgeFg) = switch (estadoVisual) {
      BuyEstadoVisual.anulada => ('Anulada', theme.colorScheme.primary, Colors.white),
      BuyEstadoVisual.credito => ('Crédito', Colors.red.shade600, Colors.white),
      BuyEstadoVisual.pagada  => ('Pagada', Colors.green.shade600, Colors.white),
    };

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showAccionesDialog(context, b, isAbonable),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // icono de “detalles”
              InkWell(
                onTap: () => _openDetalleModal(context, b),
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.receipt_long_rounded, size: 28),
                ),
              ),
              const SizedBox(width: 16),

              // info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.socios ?? '—',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _infoRow(
                          (estadoVisual == BuyEstadoVisual.credito) ? 'Vence' : 'Fecha',
                          (estadoVisual == BuyEstadoVisual.credito)
                              ? (b.fechaVence ?? '—')
                              : (b.fecha ?? '—'),
                          theme,
                        ),
                        _infoRow(
                          etiquetaTotal,
                          _fmtLps.format(b.total ?? 0),
                          theme,
                        ),
                        if (estadoVisual == BuyEstadoVisual.credito)
                          _infoRow('Saldo', _fmtLps.format(b.saldo ?? 0), theme),
                      ],
                    ),
                  ],
                ),
              ),

              // badge a la derecha
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: badgeFg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String k, String v, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$k: ',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: Colors.grey.shade600)),
        Text(v, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  // -------------------- Dialog Acciones --------------------
  void _showAccionesDialog(BuildContext context, BuySell b, bool isAbonable) {
    final color = Theme.of(context).colorScheme.primary;

    Widget option(IconData icon, String label, VoidCallback onTap) => InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
            onTap();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withAlpha(38),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
        );

    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('¿Qué deseas hacer?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  option(Icons.visibility_rounded, 'Ver detalles', () {
                    _openDetalleModal(context, b);
                  }),
                  option(Icons.mode_comment_outlined, 'Comentario', () async {
                    // TODO: navega a comentario
                    // Get.toNamed(MainRoutes.comentarioBuySell, arguments: b);
                    Get.snackbar('Comentario', 'Abrir comentarios de ${b.id}');
                  }),
                  if (isAbonable)
                    option(Icons.attach_money_rounded, 'Abonar', () async {
                      // TODO: navega a abonos
                      // Get.toNamed(MainRoutes.abonar, arguments: b);
                      Get.snackbar('Abonar', 'Abrir abono de ${b.id}');
                    }),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------- Modal Detalle simple --------------------
  void _openDetalleModal(BuildContext context, BuySell b) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_long_rounded),
                const SizedBox(width: 8),
                Text('Detalle ${b.id ?? ''}',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const Divider(),
            Text('Socio: ${b.socios ?? '—'}'),
            Text('Fecha: ${b.fecha ?? '—'}'),
            Text('Total: ${_fmtLps.format(b.total ?? 0)}'),
            if (b.esCredito == true) ...[
              Text('Saldo: ${_fmtLps.format(b.saldo ?? 0)}'),
              Text('Vence: ${b.fechaVence ?? '—'}'),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // -------------------- Filtro lateral --------------------
  void _showRightFilterPanel(BuildContext context, BuySellController c) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Filtro",
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => Align(
        alignment: Alignment.centerRight,
        child: FractionallySizedBox(
          widthFactor: 0.70,
          child: Material(
            child: _PanelFiltros(controller: c),
          ),
        ),
      ),
      transitionBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  }

  // -------------------- Crear compra/venta --------------------
  Future<void> _onAddPressed(BuildContext context) async {
    final result = await Get.toNamed(
      MainRoutes.addBuySell, // AJUSTA tu ruta real
      arguments: {'esCompra': esCompra},
    );
    if (result == true) {
      controller.loadBuySells(); // refresca al volver
    }
  }
}

// =================== PANEL DE FILTROS ===================
class _PanelFiltros extends StatelessWidget {
  final BuySellController controller;
  const _PanelFiltros({required this.controller});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                const Text("Filtros", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    controller.estadoFiltro.value = BuyFiltroEstado.todos;
                    controller.rangoPrecioFiltro.value = const RangeValues(0, 100000);
                    Navigator.pop(context);
                  },
                  child: const Text("Limpiar"),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Estado: Anuladas / Pagadas / Crédito
            Obx(() {
              final estados = <BuyFiltroEstado>[
                BuyFiltroEstado.anuladas,
                BuyFiltroEstado.pagadas,
                BuyFiltroEstado.credito,
              ];
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: estados.map((estado) {
                  final sel = controller.estadoFiltro.value == estado;
                  final label = switch (estado) {
                    BuyFiltroEstado.anuladas => 'Anuladas',
                    BuyFiltroEstado.pagadas  => 'Pagadas',
                    BuyFiltroEstado.credito  => 'Crédito',
                    _ => 'Todos',
                  };
                  return GestureDetector(
                    onTap: () => controller.estadoFiltro.value = estado,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: sel ? primary : Colors.grey[200],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(label, style: TextStyle(color: sel ? Colors.white : Colors.black87)),
                    ),
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Rango de totales", style: TextStyle(color: Colors.grey)),
            ),
            Obx(() {
              final rv = controller.rangoPrecioFiltro.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RangeSlider(
                    values: rv,
                    min: 0, max: 100000, divisions: 100,
                    labels: RangeLabels(
                      _fmtLps.format(rv.start),
                      _fmtLps.format(rv.end),
                    ),
                    onChanged: (v) => controller.rangoPrecioFiltro.value = v,
                    activeColor: primary,
                  ),
                  Text(
                    "Desde ${_fmtLps.format(rv.start)} hasta ${_fmtLps.format(rv.end)}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              );
            }),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// =================== CHIP ===================
class _FiltroChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _FiltroChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
