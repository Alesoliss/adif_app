import 'package:edu_app/presentation/home/widgets/home_card_widget.dart';
import 'package:edu_app/presentation/home/widgets/premium_banner_widget.dart';
import 'package:edu_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    const PremiumBannerWidget(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 2,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(28),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.shield,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Tus datos solo se guardan en este teléfono. Puedes descargar una copia de seguridad siempre que lo necesites.",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.tertiaryContainer,
                                  fontFamily: 'Poppins',
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.07,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 18,
                            ),
                        children: [
                          HomeCard(
                            icon: LucideIcons.userPlus,
                            label: "Clientes",
                            color: Theme.of(context).colorScheme.primary,
                            iconColor: Theme.of(context).colorScheme.primary,
                            onTap: () => Get.toNamed(MainRoutes.addPartner, arguments: {'esProveedor': false}),
                          ),
                          HomeCard(
                            icon: LucideIcons.userPlus,
                            label: "Proveedores",
                            color: Theme.of(context).colorScheme.primary,
                            iconColor: Theme.of(context).colorScheme.primary,
                            onTap: () => Get.toNamed(MainRoutes.addPartner, arguments: {'esProveedor': true}),
                          ),
                          HomeCard(
                            icon: LucideIcons.box,
                            label: "Productos",
                            color: Theme.of(context).colorScheme.secondary,
                            iconColor: Theme.of(context).colorScheme.primary,
                            onTap: () => Get.toNamed(MainRoutes.addProduct),
                          ),
                          HomeCard(
                            icon: LucideIcons.dollarSign,
                            label: "Registrar venta",
                            color: Theme.of(context).colorScheme.secondary,
                            iconColor: Theme.of(context).colorScheme.primary,
                               onTap: () => Get.toNamed(MainRoutes.addBuySell, arguments: {'esCompra': false}),
                          ),
                          HomeCard(
                            icon: LucideIcons.shoppingCart,
                            label: "Registrar compra",
                            color: Theme.of(context).colorScheme.secondary,
                            iconColor: Theme.of(context).colorScheme.primary,
                            onTap: () => Get.toNamed(MainRoutes.addBuySell, arguments: {'esCompra': true}),
                          ),
                          HomeCard(
                            icon: LucideIcons.barChart,
                            label: "Reporte",
                            color: Theme.of(context).colorScheme.secondary,
                            iconColor: Theme.of(context).colorScheme.primary,
                            
                          ),
                          HomeCard(
                            icon: LucideIcons.downloadCloud,
                            label: "Copia de seguridad",
                            color: Theme.of(context).colorScheme.primary,
                            iconColor: Theme.of(context).colorScheme.secondary,
                            highlight: true,
                          ),
                        ],
                      ),
                    ),

                    _soporteWidget(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.cover,
                    width: 48,
                    height: 48,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        LucideIcons.user,
                        size: 30,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "¡Bienvenido de nuevo!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "Eduardo Varela",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(LucideIcons.bell, size: 26),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(LucideIcons.downloadCloud, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Buscar...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  icon: const Icon(
                    LucideIcons.slidersHorizontal,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding _soporteWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 6),
      child: Row(
        children: [
          Icon(
            Icons.support_agent_rounded,
            color: Theme.of(context).colorScheme.tertiaryContainer,
            size: 26,
          ),
          const SizedBox(width: 8),
          Text(
            "Soporte",
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          const Spacer(),
          Text(
            "v1.0",
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
