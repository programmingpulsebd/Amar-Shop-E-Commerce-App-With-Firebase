import 'package:firebase_ecom_app/app/modules/home/views/widgets/app_drawer.dart';
import 'package:firebase_ecom_app/app/modules/home/views/widgets/catgeory.dart';
import 'package:firebase_ecom_app/app/modules/home/views/widgets/product.dart';
import 'package:firebase_ecom_app/app/modules/home/views/widgets/slider.dart';
import 'package:firebase_ecom_app/app/utils/theme/app_colors.dart';
import 'package:firebase_ecom_app/app/utils/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/constants/app_config.dart';
import '../../../utils/theme/size.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.appName),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            Get.toNamed(Routes.NOTIFICATION);

          }, icon: Icon(Iconsax.notification)),
        ],
      ),

      drawer: const AppDrawer(),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: AppSpacing.xl, right: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.md),

            CarouselSliderBanners(),

            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Text('Categories', style: AppTypography.titleMedium()),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.CATEGORIES);
                  },
                  child: Text(
                    'See all',
                    style: AppTypography.bodyMedium(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),

            CategoriesSection(),

            SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Text('Products', style: AppTypography.titleMedium()),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.ALL_PRODUCTS);
                  },
                  child: Text(
                    'See all',
                    style: AppTypography.bodyMedium(color: AppColors.primary),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.md),
            Product(),
            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
