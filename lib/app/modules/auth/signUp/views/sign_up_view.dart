import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_outline_button.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/theme/app_colors.dart';
import '../../../../utils/theme/app_typography.dart';
import '../../../../utils/theme/size.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

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
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineMedium(
                      color: AppColors.primary,
                    ).copyWith(fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Create an account so you can explore all the existing jobs',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLarge(),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.xl3),

              AppTextFromField(
                controller: controller.nameController,
                label: 'Enter your name',
                hintText: 'Name',
                keyboardType: TextInputType.name,
              ),

              SizedBox(height: AppSpacing.md),

              AppTextFromField(
                controller: controller.emailController,
                label: 'Enter your email',
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: AppSpacing.md),

              AppTextFromField(
                controller: controller.passwordController,
                label: 'Enter your password',
                hintText: 'Password',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),

              SizedBox(height: AppSpacing.md),

              AppTextFromField(
                controller: controller.confirmPasswordController,
                label: 'Enter your confirm password',
                hintText: 'Confirm Password',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),


              SizedBox(height: AppSpacing.xl),

              Obx(
                () => AppButton(
                  label: 'Register',
                  isLoading: controller.isLoading.value,
                  onPressed: () => controller.signUp(),
                ),
              ),

              SizedBox(height: AppSpacing.sm),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text('Already have an account?'),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.LOGIN),
                    child: const Text('Sign In'),
                  ),



                ],
              ),

              SizedBox(height: AppSpacing.md),





            ],
          ),
        ),
      ),
    );
  }
}
