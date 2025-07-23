import 'package:edu_app/presentation/home/home_screen.dart';
import 'package:edu_app/presentation/products/list/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  MainController();

  final RxInt selectedPage = 0.obs;
  final RxList<Widget> stackPages = <Widget>[].obs;

  @override
  void onReady() {
    stackPages.value = [
      HomeScreen(),
      _PlaceholderScreen(title: 'Categorías'),
      _PlaceholderScreen(title: 'Favoritos'),
      const ProductsScreen(),
      _PlaceholderScreen(title: 'Perfil'),
    ];
    selectedPage.value = 0;
    super.onReady();
  }

  Future<void> switchTab(int index) async {
    selectedPage.value = index;
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 32, color: Colors.grey),
        ),
      ),
    );
  }
}
