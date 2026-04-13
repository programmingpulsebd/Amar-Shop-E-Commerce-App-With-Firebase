import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../utils/theme/app_colors.dart';
import '../../../../utils/theme/app_typography.dart';
import '../../../../utils/theme/size.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

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
              // Header
              Column(
                children: [
                  Text('Profile Setup',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineMedium(color: AppColors.primary)
                        .copyWith(fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  SizedBox(height: AppSpacing.md),
                  const Text('Please fill the below details to complete your profile.', textAlign: TextAlign.center),
                ],
              ),

              SizedBox(height: AppSpacing.xl3),

              // Dynamic Initial Avatar
              Container(
                height: 110, width: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.15),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Center(
                  child: Obx(() {
                    // এখানে .value ব্যবহার করার কারণে GetX আর এরর দিবে না
                    String name = controller.displayName.value.trim();

                    return Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: AppTypography.headlineLarge(
                        color: AppColors.primary,
                      ).copyWith(fontWeight: FontWeight.bold),
                    );
                  }),
                ),
              ),
              SizedBox(height: AppSpacing.xl),

              // Inputs
              AppTextFromField(
                controller: controller.nameController,
                label: 'Enter your name',
                hintText: 'Name',
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: AppSpacing.md),

              AppTextFromField(
                controller: controller.addressController,
                label: 'Enter your address',
                hintText: 'Address',
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: AppSpacing.md),

              AppTextFromField(
                controller: controller.phoneController,
                label: 'Enter your number',
                hintText: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: AppSpacing.xl3),

              Obx(() => AppButton(
                label:  'Complete Setup',
                isLoading: controller.isLoading.value,
                onPressed: () => controller.updateProfile(),
              )),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}