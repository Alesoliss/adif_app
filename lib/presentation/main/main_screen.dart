import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:edu_app/presentation/main/main_controller.dart';

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

      return Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
          ],
        ),
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
                iconData = isSelected ? Icons.category : Icons.category_outlined;
                break;
              case 2:
                iconData = isSelected ? Icons.favorite : Icons.favorite_border_outlined;
                break;
              case 3:
                iconData = isSelected ? Icons.shopping_bag : Icons.shopping_bag_outlined;
                break;
              case 4:
                iconData = isSelected ? Icons.person : Icons.person_outline;
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
                          child: Icon(iconData, color: iconColor, size: 26),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        'Inicio',
                        'Categorías',
                        'Favoritos',
                        'Pedidos',
                        'Perfil',
                      ][index],
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
