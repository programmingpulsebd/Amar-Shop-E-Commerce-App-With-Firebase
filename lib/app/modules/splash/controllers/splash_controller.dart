import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {

    await Future.delayed(const Duration(seconds: 2));

    User? user = _auth.currentUser;

    if (user != null) {
      Get.offAllNamed(Routes.BOTTOM_NAV);
    } else {
      Get.offAllNamed(Routes.WELCOME);
    }
  }
}