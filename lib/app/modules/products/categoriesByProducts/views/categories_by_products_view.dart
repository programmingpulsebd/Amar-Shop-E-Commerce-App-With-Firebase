import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../home/views/widgets/product_item.dart';
import '../controllers/categories_by_products_controller.dart';

class CategoriesByProductsView extends GetView<CategoriesByProductsController> {
  const CategoriesByProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.categoryName)),
      body: Obx(() {
        if (controller.products.isEmpty) {
          return const Center(child: Text("No products found in this category!"));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return CustomProductCard(
              imageUrl: product.image,
              title: product.name,
              originalPrice: double.tryParse(product.price) ?? 0.0,
              discountPrice: double.tryParse(product.discountPrice) ?? 0.0,
              discountPercentage: _calculateDiscount(product.price, product.discountPrice),
              onTap: () {
                Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product);
              },
            );
          },
        );
      }),
    );
  }

  // ডিসকাউন্ট ক্যালকুলেশন হেল্পার
  String _calculateDiscount(String price, String dPrice) {
    double p = double.tryParse(price) ?? 0;
    double d = double.tryParse(dPrice) ?? 0;
    if (p <= 0 || d <= 0) return "0";
    return (((p - d) / p) * 100).toStringAsFixed(0);
  }
}