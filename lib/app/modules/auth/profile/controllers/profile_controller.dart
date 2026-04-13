import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/app_snackbar.dart';
import '../../../../data/services/auth_services.dart';
import '../../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();

  final Rxn<Map<String, dynamic>> userData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    // Firestore থেকে রিয়েল-টাইম ডাটা লিসেন করা
    userData.bindStream(
        _authService.getUserData().map((doc) => doc.data() as Map<String, dynamic>?)
    );
  }

  void handleLogout() async {
    try {
      await _authService.logout();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      customSnackBar(title: "Error", message: "Logout failed", isError: true);
    }
  }

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;

  Future<void> updatePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      customSnackBar(title: "Error", message: "New passwords do not match", isError: true);
      return;
    }

    try {
      isLoading.value = true;
      await _authService.changePassword(
        currentPasswordController.text.trim(),
        newPasswordController.text.trim(),
      );
      Get.back();
      customSnackBar(title: "Success", message: "Password updated successfully");

    } catch (e) {
      throw Exception("Password update failed");
    } finally {
      isLoading.value = false;
    }
  }

}