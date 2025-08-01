// partner_screen.dart

import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/presentation/partner/list/partner_screen_controller.dart';
import 'package:edu_app/routes/app_routes.dart';
import 'package:edu_app/services/partnerService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PartnerScreen extends StatefulWidget {
  final void Function(PartnerModel)? onSelect;
  final bool isPicker;
  final String initialName;

  const PartnerScreen({
    Key? key,
    this.onSelect,
    this.initialName = "Clientes",
  })  : isPicker = onSelect != null,
        super(key: key);

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  late final PartnerController controller;
  final TextEditingController _searchController = TextEditingController();
  final RxString query = ''.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      PartnerController(PartnerService(), initialName: widget.initialName),
    );
  }

  void _showFilterPanel() {
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
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
            child: _PanelFiltros(controller: controller),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              // ✅ Estas son Rx dentro del Obx:
              if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final filtro = query.value.toLowerCase();
              final listaFiltrada = controller.socios.where((p) {
                final matchSearch = p.nombre.toLowerCase().contains(filtro) ||
                    (p.notas ?? '').toLowerCase().contains(filtro) ||
                    (p.dni ?? '').toLowerCase().contains(filtro);

                final matchTipo = switch (controller.tipoFiltro.value) {
                  SocioTipo.clientes   => !p.esProveedor,
                  SocioTipo.proveedores => p.esProveedor,
                  SocioTipo.todos       => true,
                };
                return matchSearch && matchTipo;
              }).toList();

              if (listaFiltrada.isEmpty) {
                return const Center(child: Text("No hay resultados"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: listaFiltrada.length,
                itemBuilder: (_, i) => _partnerCard(listaFiltrada[i]),
              );
            }),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(() {
        // isProveedores es RxBool
        return Text(
          controller.isProveedores.value ? "Proveedores" : "Clientes",
          style: const TextStyle(color: Colors.black87),
        );
      }),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
        onPressed: () => Get.back(),
      ),
      actions: [
        if (!widget.isPicker)
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87),
            onPressed: () async {
              final result = await Get.toNamed(MainRoutes.addPartner);
              if (result == true) {
                controller.loadPartners();
              }
            },
          ),
        if (widget.isPicker)
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Buscar...',
                        border: InputBorder.none,
                      ),
                      onChanged: (v) => query.value = v,
                    ),
                  ),
                ],  
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _showFilterPanel,
          ),
        ],
      ),
    );
  }

  Widget _partnerCard(PartnerModel p) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: () {
          if (widget.isPicker) {
            Navigator.pop(context, p);
          } else {
            Get.toNamed(MainRoutes.addPartner, arguments: {
              'id': p.id,
              'esProveedor': p.esProveedor,
            });
          }
        },
        leading: CircleAvatar(child: const Icon(Icons.person)),
        title: Text(p.nombre, style: theme.textTheme.titleMedium),
        subtitle: Text(
          [
            if ((p.telefono ?? '').isNotEmpty) 'Tel: ${p.telefono}',
            if ((p.dni      ?? '').isNotEmpty) 'DNI: ${p.dni}',
            if ((p.notas    ?? '').isNotEmpty) p.notas!,
          ].join(' • '),
        ),
        trailing: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
      ),
    );
  }
}

// Panel de filtros
class _PanelFiltros extends StatelessWidget {
  final PartnerController controller;
  const _PanelFiltros({required this.controller});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                const Text("Filtros", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    controller.aplicarFiltros(SocioTipo.todos);
                    Navigator.pop(context);
                  },
                  child: const Text("Limpiar"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Obx(() {
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: SocioTipo.values.map((tipo) {
                  final sel = controller.tipoFiltro.value == tipo;
                  return GestureDetector(
                    onTap: () => controller.aplicarFiltros(tipo),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: sel ? primary : Colors.grey[200],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        tipo.name.capitalizeFirst!,
                        style: TextStyle(color: sel ? Colors.white : Colors.black87),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
