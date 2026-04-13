import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_outline_button.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/theme/app_colors.dart';
import '../../../../utils/theme/app_typography.dart';
import '../../../../utils/theme/size.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
          child: Column(
            children: [
              const Spacer(),

              Image.asset(
                'assets/images/welcome.png',
                height: context.height * 0.35,
                fit: BoxFit.contain,
              ),

              const Spacer(),

              Column(
                children: [
                  Text(
                    'Discover Your\nDream Job Here',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineLarge(
                      color: AppColors.primary,
                    ).copyWith(fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Explore all the existing job roles based on your interest and study major',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Sign In',
                      onPressed: () => Get.toNamed(Routes.LOGIN),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppOutlineButton(
                      label: 'Register',
                      onPressed: () => Get.toNamed(Routes.SIGN_UP),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.xl4),
            ],
          ),
        ),
      ),
    );
  }
}
