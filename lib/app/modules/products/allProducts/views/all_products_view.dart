import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/custom_search.dart';
import '../../../../routes/app_pages.dart';
import '../../../favourite/controllers/favourite_controller.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../home/views/widgets/product_item.dart';
import '../controllers/all_products_controller.dart';

class AllProductsView extends GetView<AllProductsController> {
  const AllProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final favController = Get.put(FavouriteController());

    return Scaffold(
      appBar: AppBar(title: const Text('Products List'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),

              CustomSearchBar(
                hintText: "Search for products...",
                onChanged: (value) {
                  controller.searchQuery.value = value;
                },
                onFilterTap: () {
                  print("Filter Clicked");
                },
              ),
              const SizedBox(height: 20),

              Obx(() {
                if (controller.isLoading.value &&
                    controller.filteredProducts.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.filteredProducts.isEmpty) {
                  return const Center(child: Text("No Products Found!"));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];

                    return Obx(() {
                      final isFav = favController.isFavorite(product.id);

                      return CustomProductCard(
                        imageUrl: product.image,
                        title: product.name,
                        originalPrice: double.tryParse(product.price) ?? 0.0,
                        discountPrice:
                            double.tryParse(product.discountPrice) ?? 0.0,
                        discountPercentage: _calculateDiscount(
                          product.price,
                          product.discountPrice,
                        ),
                        isFavorite: isFav,
                        onTap: () => Get.toNamed(
                          Routes.PRODUCT_DETAILS,
                          arguments: product,
                        ),
                        onFavoriteTap: () =>
                            favController.toggleWishlist(product),
                      );
                    });
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateDiscount(String price, String discountPrice) {
    double p = double.tryParse(price) ?? 0;
    double d = double.tryParse(discountPrice) ?? 0;
    if (p <= 0 || d <= 0) return "0";
    double percentage = ((p - d) / p) * 100;
    return percentage.toStringAsFixed(0);
  }
}
