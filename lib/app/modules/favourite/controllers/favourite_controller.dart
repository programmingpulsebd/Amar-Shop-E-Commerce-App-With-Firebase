import 'package:firebase_ecom_app/app/common/widgets/app_snackbar.dart';
import 'package:get/get.dart';

import '../../../data/model/product_model.dart';
import '../../../data/services/wishlist_services.dart';

class FavouriteController extends GetxController {
  final WishlistService _service = WishlistService();


  // সম্পূর্ণ প্রোডাক্ট ডাটা রাখার জন্য
  var wishlistItems = <Map<String, dynamic>>[].obs;

  // ফেভারিট প্রোডাক্ট আইডি গুলোর সেট (Set ব্যবহার করা হয়েছে দ্রুত চেক করার জন্য)
  var favoriteIds = <String>{}.obs;
  var isLoading = false.obs;




  @override
  void onInit() {
    super.onInit();
    _listenToWishlist();
  }

  void _listenToWishlist() {
    isLoading.value = true;
    _service.getWishlistStream().listen((snapshot) {
      // এটি আইডি গুলো সেভ রাখছে (হোম পেজে চেক করার জন্য)
      favoriteIds.value = snapshot.docs.map((doc) => doc.id).toSet();

      // এটি পুরো ডাটা সেভ রাখছে (উইশলিস্ট পেজে দেখানোর জন্য)
      wishlistItems.value = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);
  }


  // ফেভারিট টগল (Add/Remove) করার ফাংশন
  void toggleWishlist(ProductModel product) async {
    final bool isCurrentlyFav = favoriteIds.contains(product.id);

    try {
      // ফায়ারবেসে ডাটা আপডেট পাঠানো
      await _service.toggleFavorite(product, !isCurrentlyFav);

      // সফল হলে কাস্টম স্নাকবার দেখানো
      customSnackBar(
        title: 'Wishlist',
        message: isCurrentlyFav
            ? '${product.name} removed from favorites'
            : '${product.name} added to favorites',
      );

    } catch (e) {
      // এরর হলে এরর স্নাকবার
      customSnackBar(
        title: 'Error',
        message: 'Failed to update wishlist. Please try again.',
        isError: true,
      );
    }
  }

  // কোন প্রোডাক্ট ফেভারিট কি না তা চেক করার মেথড
  bool isFavorite(String productId) => favoriteIds.contains(productId);
}