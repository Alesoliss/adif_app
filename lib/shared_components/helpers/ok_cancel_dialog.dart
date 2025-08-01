import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OkCancelDialog extends StatelessWidget {
  const OkCancelDialog({
    super.key,
    required this.message,
    this.icon,
    this.title = 'Atención',
    this.okString = 'Aceptar',
    this.cancelString = 'Cancelar',
    this.onlyOk = false,
  });

  final IconData? icon;
  final String title;
  final String message;
  final String okString;
  final String cancelString;
  final bool onlyOk;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.only(
        top: 0,
        left: 20,
        right: 5,
        bottom: 0,
      ),
      contentPadding: const EdgeInsets.only(
        top: 25,
        left: 24,
        right: 24,
        bottom: 30,
      ),
      title: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              splashRadius: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 20),
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.close,
                size: 22,
                color: colorScheme.tertiary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28),
            child: Row(
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    size: 22,
                    color: colorScheme.tertiary,
                  ),
                if (icon != null) const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: colorScheme.tertiary,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          children: [
            if (!onlyOk)
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .tertiary, 
                    foregroundColor: Theme.of(context)
                        .colorScheme
                        .secondary, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Get.back(result: false),
                  child: Text(
                    cancelString,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary, 
                    ),
                  ),
                ),
              ),
            if (!onlyOk) const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary, 
                  foregroundColor: colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Get.back(result: true),
                child: Text(
                  okString,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
