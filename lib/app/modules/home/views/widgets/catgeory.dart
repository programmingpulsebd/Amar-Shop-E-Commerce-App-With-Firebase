import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../routes/app_pages.dart';
import '../../controllers/home_controller.dart';
import '../shimmer/categories_shimmer.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Obx(() {

      if (controller.isLoading.value) {
        return CategoriesShimmer();
      }

      return SizedBox(
        height: 110,
        child: ListView.separated(
          padding: const EdgeInsets.only(right: 10,left: 5),
          scrollDirection: Axis.horizontal,
          itemCount: controller.allCategories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 15),
          itemBuilder: (context, index) {
            final category = controller.allCategories[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed(
                  Routes.CATEGORIES_BY_PRODUCTS,
                  arguments: {"catId": category.id, "catName": category.name},
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.network(
                          category.icon,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.category_outlined),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const CircularProgressIndicator(
                              strokeWidth: 2,
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}