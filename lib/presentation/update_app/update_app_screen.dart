import 'dart:ui';
import 'package:edu_app/presentation/update_app/update_app_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class UpdateAppScreen extends StatelessWidget {
  UpdateAppScreen({super.key});

  final _controller = Get.put(UpdateAppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/back.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: const EdgeInsets.all(48.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 48.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(204),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 1.0,
                    sigmaY: 1.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 50,
                        // width: 64,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/logo-black-timeout.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Actualización Disponible",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                          "Para poder seguir disfrutando de la aplicación por favor actualiza tu versión.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0)),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          // elevation: 0,
                          // highlightElevation: 0,
                          // color: Theme.of(context).colorScheme.secondary,
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(20.0),
                          // ),
                          child: const Text(
                            "Actualizar Ahora",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await _controller.redirectToStore();
                          },
                        ),
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
