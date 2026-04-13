import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../../favourite/controllers/favourite_controller.dart';
import '../../controllers/home_controller.dart';
import '../shimmer/product_shimmer.dart';
import './product_item.dart';

class Product extends StatelessWidget {
  const Product({super.key});



  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final favController = Get.put(FavouriteController());
    return Obx(() {
      if (controller.isLoading.value && controller.allProducts.isEmpty) {
        return ProductShimmer();
      }

      if (controller.allProducts.isEmpty) {
        return const Center(child: Text("No Products Found!"));
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.allProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          final product = controller.allProducts[index];

          return Obx(() {
            final isFav = favController.isFavorite(product.id);

            return CustomProductCard(
              imageUrl: product.image,
              title: product.name,
              originalPrice: double.tryParse(product.price) ?? 0.0,
              discountPrice: double.tryParse(product.discountPrice) ?? 0.0,
              discountPercentage: _calculateDiscount(product.price, product.discountPrice),
              isFavorite: isFav, // নতুন প্যারামিটার
              onTap: () => Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product),
              onFavoriteTap: () => favController.toggleWishlist(product),
            );
          });
        },
      );
    });
  }

  String _calculateDiscount(String price, String discountPrice) {
    double p = double.tryParse(price) ?? 0;
    double d = double.tryParse(discountPrice) ?? 0;
    if (p <= 0 || d <= 0) return "0";
    double percentage = ((p - d) / p) * 100;
    return percentage.toStringAsFixed(0);
  }



}
