import 'package:edu_app/models/socio_model.dart';
import 'package:edu_app/presentation/partner/list/partner_screen_controller.dart';
import 'package:edu_app/routes/app_routes.dart';
import 'package:edu_app/services/partnerService.dart';
import 'package:edu_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PartnerScreen extends StatefulWidget {
  final void Function(PartnerModel)? onSelect; // Callback para selección
  final bool isPicker; // Modo selector

  const PartnerScreen({
    Key? key,
    this.onSelect,
  })  : isPicker = onSelect != null, // Inicializa correctamente
        super(key: key);

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  final PartnerService _partnerService = PartnerService();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PartnerController(
        _partnerService,
        name: ServiceStrings.clientes,
      ),
      builder: (context, child) {
        final ctrl = context.watch<PartnerController>();
        final filteredPartners = ctrl.partners.where((partner) {
          return partner.nombre.toLowerCase().contains(_query.toLowerCase()) ||
              (partner.telefono ?? '').toLowerCase().contains(_query.toLowerCase()) ||
              (partner.dni ?? '').toLowerCase().contains(_query.toLowerCase());
        }).toList();

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: _buildAppBar(context),
          body: Column(
            children: [
              _buildSearchBar(context),
              Expanded(
                child: ctrl.loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredPartners.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final partner = filteredPartners[index];
                          return _partnerCardWidget(partner, context);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      centerTitle: true,
      title: Consumer<PartnerController>(
        builder: (context, controller, _) {
          return Text(
            controller.isProveedores ? "Proveedores" : "Clientes",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          );
        },
      ),
      actions: [
        if (widget.isPicker)
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
      ],
    );
  }

  /// Barra de búsqueda
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
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
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Buscar...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _query = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Consumer<PartnerController>(
            builder: (context, controller, child) {
              return Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  icon: Text(
                    controller.isProveedores ? "P" : "C",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    controller.togglePartnerType();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Tarjeta de socio
  Widget _partnerCardWidget(PartnerModel partner, BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if (widget.isPicker) {
          // Devolver el socio seleccionado
          Navigator.pop(context, partner);
        } else {
          // Abrir la pantalla de edición
          Get.toNamed(MainRoutes.addPartner, arguments: {
            'id': partner.id,
            'esProveedor': partner.esProveedor,
          });
        }
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, size: 34),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      partner.nombre,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (partner.telefono?.isNotEmpty ?? false)
                      Text(
                        'Tel: ${partner.telefono!} DNI: ${partner.dni ?? ''}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey.shade700),
                      ),
                    if (partner.notas?.isNotEmpty ?? false)
                      Text(
                        partner.notas!,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey.shade500),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: null,
                icon: const Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
