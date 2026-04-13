import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../utils/theme/app_colors.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Order Summary Card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('৳${controller.totalAmount}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text('Select Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            /// --- Payment Options ---
            Obx(() => Column(
              children: [
                _buildPaymentTile(0, 'Cash on Delivery', Icons.delivery_dining),
                const SizedBox(height: 10),
                _buildPaymentTile(1, 'Online Payment', Icons.payment),
              ],
            )),

            const Spacer(),

            /// --- Confirm Button ---
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isProcessing.value ? null : () => controller.processOrder(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: controller.isProcessing.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirm Order', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTile(int index, String title, IconData icon) {
    bool isSelected = controller.selectedMethod.value == index;
    return GestureDetector(
      onTap: () => controller.changePaymentMethod(index),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300, width: 2),
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : Colors.grey),
            const SizedBox(width: 15),
            Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}