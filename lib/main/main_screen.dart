import 'package:edu_app/main/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final _controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }

  Widget _buildWidget() {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: _controller.selectedPage.value,
          children: _controller.stackPages,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() {
      int selectedIndex = _controller.selectedPage.value;

      return Stack(
        children: [
          // Fondo blanco con borde solo arriba, extendido abajo
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                ],
              ),
            ),
          ),
          // Barra real dentro de SafeArea, pero sin borde ni color extra
          SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: true,
            child: SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  bool isSelected = selectedIndex == index;

                  IconData iconData;
                  switch (index) {
                    case 0:
                      iconData = isSelected ? Icons.home : Icons.home_outlined;
                      break;
                    case 1:
                      iconData = isSelected
                          ? Icons.groups_rounded
                          : Icons.groups_outlined;
                      break;
                    case 2:
                      iconData = isSelected
                          ? Icons.attach_money_rounded
                          : Icons.attach_money_outlined;
                      break;

                    case 3:
                      iconData = isSelected
                          ? Icons.inventory_2_rounded
                          : Icons.inventory_2_outlined;
                      break;
                    case 4:
                      iconData = isSelected
                          ? Icons.shopping_cart_checkout_rounded
                          : Icons.shopping_cart_outlined;
                      break;
                    default:
                      iconData = Icons.circle;
                  }

                  Color iconColor = isSelected ? Colors.black : Colors.black45;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _controller.switchTab(index);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: isSelected ? 8 : 0,
                              width: isSelected ? 8 : 0,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 1.0,
                              end: isSelected ? 1.2 : 1.0,
                            ),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.elasticOut,
                            builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child:
                                    Icon(iconData, color: iconColor, size: 26),
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Text(
                            [
                              'Inicio',
                              'Clientes',
                              'Ventas',
                              'Productos',
                              'Compra',
                            ][index],
                            style: TextStyle(
                              color: iconColor,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      );
    });
  }
}
