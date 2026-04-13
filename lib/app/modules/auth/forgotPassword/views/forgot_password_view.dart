import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../utils/theme/app_colors.dart';
import '../../../../utils/theme/app_typography.dart';
import '../../../../utils/theme/size.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
              const SizedBox(height: 20),
              // Header
              Column(
                children: [
                  Text(
                    'Forgot Password?',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineMedium(color: AppColors.primary)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppSpacing.md),
                  const Text(
                    'Enter your email address and we will send you a link to reset your password.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.xl3),

              // Email Input
              AppTextFromField(
                controller: controller.emailController,
                label: 'Enter your email',
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: AppSpacing.xl3),

              // Action Button
              Obx(() => AppButton(
                label:  'Send Reset Link',
                isLoading: controller.isLoading.value,
                onPressed:  () {
                  controller.resetPassword();
                  Get.back();

                },

              )),

              SizedBox(height: AppSpacing.lg),

              // Back to Login
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}