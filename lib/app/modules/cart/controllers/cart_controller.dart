import 'package:get/get.dart';
import '../../../common/widgets/app_snackbar.dart';
import '../../../data/model/product_model.dart';
import '../../../data/services/cart_services.dart';

class CartController extends GetxController {
  final CartService _cartService = CartService();

  var cartItems = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToCart();
  }

  Future<void> addItem(ProductModel product) async {
    try {
      isLoading.value = true;
      await _cartService.addToFirestore(product, 1);
      customSnackBar(title: 'Success', message: '${product.name} added to cart');
    } catch (e) {
      customSnackBar(title: 'Error', message: 'Failed to add to cart', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void _listenToCart() {
    isLoading.value = true;

    _cartService.getCartStream().listen((snapshot) {
      cartItems.value = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      // ডাটা রিসিভ করার পর loading false
      isLoading.value = false;
    }, onError: (error) {
      // এরর আসলেও লোডিং বন্ধ করতে হবে
      isLoading.value = false;
    });
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