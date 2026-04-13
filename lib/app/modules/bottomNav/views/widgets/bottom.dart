import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../utils/theme/app_colors.dart';
import '../../controllers/bottom_nav_controller.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final BottomNavController controller = Get.put(BottomNavController());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => NavigationBar(
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) {
              controller.changeIndex(index);
            },
            indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            destinations: [
              const NavigationDestination(
                icon: Icon(Iconsax.home),
                selectedIcon: Icon(Iconsax.home_1, color: AppColors.primary),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Iconsax.heart),
                selectedIcon: Icon(Iconsax.heart, color: AppColors.primary),
                label: 'Favourites',
              ),
              NavigationDestination(
                icon: const Icon(Iconsax.shopping_cart),
                selectedIcon: const Icon(Iconsax.shopping_cart, color: AppColors.primary,
                ),
                label: 'Carts',
              ),
              const NavigationDestination(
                icon: Icon(Iconsax.user),
                selectedIcon: Icon(Iconsax.user_edit, color: AppColors.primary),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
