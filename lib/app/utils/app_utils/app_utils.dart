import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUtils {
  static void showSuccess(String message) {
    _showDefaultToast(
      message: message,
      color: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  static void showError(String message) {
    _showDefaultToast(
      message: message,
      color: Colors.red,
      icon: Icons.error_outline,
    );
  }

  static void showWarning(String message) {
    _showDefaultToast(
      message: message,
      color: Colors.orange,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void _showDefaultToast({
    required String message,
    required Color color,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(Get.context!).clearSnackBars();

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}