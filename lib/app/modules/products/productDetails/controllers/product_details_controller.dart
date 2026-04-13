import 'package:firebase_ecom_app/app/common/widgets/app_snackbar.dart';
import 'package:get/get.dart';

import '../../../../data/model/product_model.dart';
import '../../../../data/services/cart_services.dart';

class ProductDetailsController extends GetxController {
  late ProductModel product;

  final isLoadings = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToCart();
    product = Get.arguments;
  }

  final CartService _cartService = CartService();

  // কার্টের প্রোডাক্টগুলো রিয়েল-টাইমে রাখার জন্য
  var cartItems = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;


  void _listenToCart() {
    _cartService.getCartStream().listen((snapshot) {
      cartItems.value = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return data;
      }).toList();
    });
  }

  void addToCart(ProductModel product) async {
    try {
      isLoadings.value = true;
      await _cartService.addToFirestore(product, 1);
      customSnackBar(title: 'Success', message: 'Added to your online cart');
    } catch (e) {
      customSnackBar(title: 'Error', message: 'Something went wrong!',isError: true);

    } finally {
      isLoadings.value = false;
    }
  }

  // কোয়ান্টিটি বাড়ানো (+)
  void incrementQty(String productId) {
    _cartService.updateQuantity(productId, 1);
  }

  // কোয়ান্টিটি কমানো (-)
  void decrementQty(String productId, int currentQty) {
    if (currentQty > 1) {
      _cartService.updateQuantity(productId, -1);
    } else {
      deleteItem(productId);
    }
  }

  // আইটেম ডিলিট করা
  void deleteItem(String productId) {
    _cartService.removeFromFirestore(productId);
  }

  // টোটাল প্রাইস ক্যালকুলেশন
  double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      double price = double.tryParse(item['discount_price'].toString()) ?? 0;
      int qty = item['quantity'] ?? 0;
      total += price * qty;
    }
    return total;
  }

}