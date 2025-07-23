import 'package:edu_app/presentation/splash/splash_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  // ignore: unused_field
  final _controller = Get.put(SplashController()); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _controller.scaffoldKey,
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
            ),
            child: Icon(
             Icons.home
            ),
          ),
          const SizedBox(height: 20),
          SpinKitThreeBounce(
            color: Theme.of(context).colorScheme.tertiary,
            size: 40,
          ),
        ],
      ),
    );
  }
}
