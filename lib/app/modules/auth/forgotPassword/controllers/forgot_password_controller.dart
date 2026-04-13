import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../data/services/auth_services.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final isLoading = false.obs;

  Future<void> resetPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      customSnackBar(title: "Invalid Email", message: "Please enter a valid email address", isError: true);
      return;
    }

    try {
      isLoading.value = true;
      await _authService.sendPasswordResetEmail(email);
      customSnackBar(title: "Success", message: "Password reset link sent to your email");
    } catch (e) {
      customSnackBar(title: "Error", message: e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }



  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}