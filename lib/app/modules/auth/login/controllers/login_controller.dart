import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../data/internet/internet_check.dart';
import '../../../../data/services/auth_services.dart';
import '../../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();

  final ConnectivityService _connectivity = Get.put(ConnectivityService());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  Future<void> logIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // ১. ভ্যালিডেশন
    if (email.isEmpty || password.isEmpty) {
      customSnackBar(
        title: "Warning",
        message: "Please fill all fields",
        isError: true,
      );
      return;
    }

    // ২. ইন্টারনেট চেক
    bool hasNet = await _connectivity.hasInternet();
    if (!hasNet) {
      customSnackBar(
        title: "No Internet",
        message: "Please check your connection",
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;
      var user = await _authService.login(email, password);

      if (user != null) {
        Get.offAllNamed(Routes.BOTTOM_NAV);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
