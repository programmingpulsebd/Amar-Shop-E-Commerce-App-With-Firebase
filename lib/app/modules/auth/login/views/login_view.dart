import 'package:firebase_ecom_app/app/common/widgets/app_text_field.dart';
import 'package:firebase_ecom_app/app/utils/theme/app_typography.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_outline_button.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/theme/app_colors.dart';
import '../../../../utils/theme/size.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'Login here',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineMedium(
                      color: AppColors.primary,
                    ).copyWith(fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Welcome back you’ve \nbeen missed!',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLarge(),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.xl3),

              AppTextFromField(
                label: 'Enter your email',
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                controller: controller.emailController,
              ),

              SizedBox(height: AppSpacing.md),

              AppTextFromField(
                label: 'Enter your password',
                hintText: 'Password',
                obscureText: true,
                controller: controller.passwordController,
                keyboardType: TextInputType.visiblePassword,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.FORGOT_PASSWORD);
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),

              SizedBox(height: AppSpacing.lg),

              Obx(
                () => AppButton(
                  label: 'Sign In',
                  isLoading: controller.isLoading.value,
                  onPressed: () => controller.logIn(),
                ),
              ),


              SizedBox(height: AppSpacing.sm),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text('If you don’t have an account?'),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.SIGN_UP),
                    child: const Text('Sign Up'),
                  ),



                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
