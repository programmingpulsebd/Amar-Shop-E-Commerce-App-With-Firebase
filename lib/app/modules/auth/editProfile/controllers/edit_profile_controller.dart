import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../data/services/auth_services.dart';
import '../../../../routes/app_pages.dart';


class EditProfileController extends GetxController {
  final AuthService _authService = AuthService();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  final isLoading = false.obs;

  var displayName = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserData();
    nameController.addListener(() {
      displayName.value = nameController.text;
    });
  }

  // ফায়ারস্টোর থেকে বর্তমান ডাটা নিয়ে এসে টেক্সট ফিল্ডে বসানো
  void _loadCurrentUserData() {
    // এখানে আমরা সরাসরি স্ট্রিম থেকে স্যাম্পল ডাটা নিতে পারি অথবা বর্তমান ইউজার চেক করতে পারি
    _authService.getUserData().first.then((doc) {
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        nameController.text = data['name'] ?? '';
        addressController.text = data['address'] ?? '';
        phoneController.text = data['phone'] ?? '';
      }
    });
  }

  Future<void> updateProfile() async {
    final name = nameController.text.trim();
    final address = addressController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || address.isEmpty || phone.isEmpty) {
      customSnackBar(title: "Required", message: "All fields are mandatory", isError: true);
      return;
    }

    try {
      isLoading.value = true;

      // ডাটা ম্যাপ আকারে তৈরি করা
      Map<String, dynamic> updatedData = {
        'name': name,
        'address': address,
        'phone': phone,
      };

      await _authService.updateProfile(updatedData);

      // আপডেট হওয়ার পর ইউজারকে মেইন অ্যাপে পাঠানো
      Get.back();


    } catch (e) {
      customSnackBar(title: "Update Failed", message: e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}