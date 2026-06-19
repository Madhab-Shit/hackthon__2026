import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomPremiumSnackBar({
  required String title,
  required String message, // Eta apnar subtitle hisebe kaaj korbe
  required IconData icon,
  required Color backgroundColor,
}) {
  // Ager kono snackbar open thakle seta close kore dibe
  if (Get.isSnackbarOpen) {
    Get.closeAllSnackbars();
  }

  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: backgroundColor,
    colorText: Colors.white,
    icon: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(
        icon,
        color: Colors.white,
        size: 28,
      ),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    borderRadius: 16,
    duration: const Duration(seconds: 4),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack, // Premium pop-out animation
    boxShadows: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  );
}