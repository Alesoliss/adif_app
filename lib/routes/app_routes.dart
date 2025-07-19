import 'package:edu_app/presentation/main/main_screen.dart';
import 'package:edu_app/presentation/splash/splash_screen.dart';
import 'package:edu_app/presentation/update_app/update_app_screen.dart';
import 'package:get/get.dart';


class MainRoutes {
  static const String splash = "/splash";
  static const String main = "/main";
  static const String updateApp = '/updateApp';


 
}

class MainPages {
  static final pages = [
    GetPage(name: MainRoutes.splash, page: () => SplashScreen()),
    GetPage(name: MainRoutes.updateApp, page: () => UpdateAppScreen()),
    GetPage(name: MainRoutes.main, page: () => MainScreen()),

    
  ];
}
