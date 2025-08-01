import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SnackbarHelper {
  static void show({
    String? title,
    required String message,
    required SnackType type,
    int? duration,
  }) {
    switch (type) {
      case SnackType.info:
        Get.snackbar(
          '',
          '',
          backgroundColor: Get.theme.colorScheme.primary.withAlpha(230),
          titleText: Text(
            title ?? 'Información',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          messageText: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: duration ?? 5),
        );
        break;
      case SnackType.success:
        Get.snackbar(
          '',
          '',
          backgroundColor: Get.theme.colorScheme.primary.withAlpha(230),
          titleText: Text(
            title ?? 'Exito',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          messageText: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          // icon: const Icon(Icons.check_box, color: Colors.white),
          duration: Duration(seconds: duration ?? 5),
        );
        break;
      case SnackType.error:
        Get.snackbar(
          '',
          '',
          backgroundColor: Colors.red.withAlpha(230),
          titleText: Text(
            title ?? 'Error',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          messageText: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          icon: const Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: duration ?? 5),
        );
        break;
      // default:
      //   break;
    }
  }
}

enum SnackType { success, error, info }
