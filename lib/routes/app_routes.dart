import 'package:edu_app/main/main_screen.dart';
import 'package:edu_app/presentation/Buy-Sell/add/buysell_add_screen.dart';
import 'package:edu_app/presentation/home/home_screen.dart';
import 'package:edu_app/presentation/partner/add/partner_add_screen.dart';
import 'package:edu_app/presentation/products/add/product_add_screen.dart';
import 'package:edu_app/presentation/products/add/widgets/add_photo_widget.dart';
import 'package:edu_app/presentation/splash/splash_screen.dart';
import 'package:edu_app/presentation/update_app/update_app_screen.dart';
import 'package:get/get.dart';

class MainRoutes {
  static const String splash = "/splash";
  static const String main = "/main";
  static const String updateApp = '/updateApp';
  static const String addPartner = "/addPartner";
  static const String addProduct = "/addProduct";
  static const String addBuySell = "/addProduct";
  static const String seleccionarFoto = "/addPhoto";
  static const String home = "/home";
}

class MainPages {
  static final pages = [
    GetPage(name: MainRoutes.splash, page: () => SplashScreen()),
    GetPage(name: MainRoutes.updateApp, page: () => UpdateAppScreen()),
    GetPage(name: MainRoutes.main, page: () => MainScreen()),
    GetPage(name: MainRoutes.home, page: () => HomeScreen()),
    GetPage(name: MainRoutes.addPartner, page: () => AddPartnerScreen()),
    GetPage(name: MainRoutes.addBuySell, page: () => AddBuySellScreen()),
    GetPage(name: MainRoutes.addProduct, page: () => AgregarProductoScreen()),
    GetPage(name: MainRoutes.seleccionarFoto, page: () => AddPhotoScreen()),

  ];
}
