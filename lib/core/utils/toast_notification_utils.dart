import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

enum ToastType {
  info,
  error,
}

class ToastNotificationUtils {
  static void showToast(
    BuildContext context, {
    required String message,
    required ToastType toastType,
  }) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 5),
      builder: (context, controller) {
        late final Widget icon;
        if (toastType == ToastType.error) {
          icon = const Icon(
            Icons.not_interested,
            color: Colors.red,
          );
        }
        if (toastType == ToastType.info) {
          icon = const Icon(
            Icons.info_outline,
            color: Colors.black,
          );
        }
        return Flash(
          controller: controller,
          behavior: FlashBehavior.floating,
          position: FlashPosition.bottom,
          borderRadius: BorderRadius.circular(10),
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          child: FlashBar(
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: icon,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(message),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                        onTap: controller.dismiss,
                        child: const Icon(Icons.close)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
