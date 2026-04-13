import 'package:firebase_ecom_app/app/common/widgets/app_button.dart';
import 'package:firebase_ecom_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/app_snackbar.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../utils/theme/app_typography.dart';
import '../../../utils/theme/size.dart';
import '../../home/views/widgets/app_drawer.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final controller = Get.put(CartController());

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(title: const Text('My Cart'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cartItems.isEmpty) {
          return const Center(child: Text('Your cart is empty!'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(AppSpacing.lg),
                itemCount: controller.cartItems.length,
                separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  final String productId = item['id'].toString();
                  final int qty = item['quantity'] ?? 1;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // --- Product Image ---
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item['image'] ?? '',
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return SizedBox(
                                height: 80,
                                width: 80,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),

                        // --- Title & Price ---
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'] ?? 'Product Name',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '৳${item['discount_price']}',
                                style: AppTypography.titleMedium().copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // --- Actions (Delete & Qty) ---
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => controller.deleteItem(productId),
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.redAccent,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildQuantityBtn(
                                  Icons.remove,
                                  theme,
                                  onTap: () =>
                                      controller.decrementQty(productId, qty),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Text(
                                    '$qty',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                _buildQuantityBtn(
                                  Icons.add,
                                  theme,
                                  isPrimary: true,
                                  onTap: () =>
                                      controller.incrementQty(productId),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // নিচের চেকআউট সেকশন
            _buildCheckoutSection(theme),
          ],
        );
      }),
    );
  }

  // কোয়ান্টিটি বাটনের জন্য কাস্টম উইজেট
  Widget _buildQuantityBtn(
    IconData icon,
    ThemeData theme, {
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isPrimary
              ? theme.primaryColor
              : theme.dividerColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isPrimary ? Colors.white : theme.iconTheme.color,
        ),
      ),
    );
  }

  // চেকআউট সেকশন
  Widget _buildCheckoutSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total (${controller.cartItems.length} items):',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                '৳${controller.totalPrice.toStringAsFixed(0)}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: Obx(
              () => AppButton(
                label: 'Buy Now',
                isLoading: controller.isLoading.value,
                onPressed: () {
                  Get.toNamed(
                    Routes.PAYMENT,
                    arguments: {
                      'totalAmount': controller.totalPrice,
                      'items': controller.cartItems,
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
