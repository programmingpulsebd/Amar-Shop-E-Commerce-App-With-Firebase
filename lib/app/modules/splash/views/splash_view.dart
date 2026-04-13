import 'package:firebase_ecom_app/app/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/theme/app_colors.dart';
import '../../../utils/theme/app_typography.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: Image.asset(
                      'assets/logo/logo.png', fit: BoxFit.contain),
                ),
                const SizedBox(height: 15),
                Text(
                  AppConfig.appName,
                  style: AppTypography.headlineSmall(
                    color: AppColors.white,
                  ).copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
