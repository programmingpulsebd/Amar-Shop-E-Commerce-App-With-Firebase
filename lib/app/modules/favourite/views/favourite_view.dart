import 'package:firebase_ecom_app/app/modules/favourite/views/widgets/favourite_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/product_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../utils/theme/size.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/views/widgets/app_drawer.dart';
import '../controllers/favourite_controller.dart';

class FavouriteView extends GetView<FavouriteController> {
  const FavouriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartController = Get.put(CartController());
    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text('My Wishlist'),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Obx(() => Text(
                '${controller.wishlistItems.length} Items',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.wishlistItems.isEmpty) {
          return const Center(child: Text('Your wishlist is empty!'));
        }

        return GridView.builder(
          padding: EdgeInsets.all(AppSpacing.lg),
          itemCount: controller.wishlistItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 0.70,
          ),
          itemBuilder: (context, index) {
            final item = controller.wishlistItems[index];
            final product = ProductModel.fromSnapshot(item);

            return FavouriteCard(
              product: product,
              onRemove: () => controller.toggleWishlist(product),
              onTap: () => Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product),
              onAddToCart: () => cartController.addItem(product),
            );
          },
        );
      }),
    );
  }
}