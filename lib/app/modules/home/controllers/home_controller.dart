import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:async'; // StreamSubscription এর জন্য
import '../../../common/widgets/app_snackbar.dart';
import '../../../data/internet/internet_check.dart';
import '../../../data/model/banner_model.dart';
import '../../../data/model/categories_model.dart';
import '../../../data/model/product_model.dart';
import '../../../data/services/banners_services.dart';
import '../../../data/services/category_services.dart';
import '../../../data/services/product_services.dart';

class HomeController extends GetxController {
  // সার্ভিসসমূহ
  final CategoryService _categoryService = CategoryService();
  final BannerService _bannerService = BannerService();
  final ProductServices _productService = ProductServices();
  final ConnectivityService _connectivity = ConnectivityService();

  // ডাটা লিস্ট
  var allCategories = <CategoryModel>[].obs;
  var allBanners = <BannerModel>[].obs;
  var allProducts = <ProductModel>[].obs;

  // স্টেট
  var isLoading = true.obs;
  StreamSubscription? _categorySubscription;

  var searchQuery = "".obs; // সার্চ কি-ওয়ার্ড রাখার জন্য

  @override
  void onInit() {
    super.onInit();
    _loadHomeData();
  }

  List<CategoryModel> get filteredCategories {
    if (searchQuery.value.isEmpty) {
      return allCategories;
    } else {
      return allCategories.where((category) {
        return category.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  List<ProductModel> get filteredProducts {
    if (searchQuery.value.isEmpty) {
      return allProducts;
    } else {
      return allProducts.where((product) {
        return product.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  void _loadHomeData() async {
    try {
      bool connected = await _connectivity.hasInternet();
      if (!connected) {
        isLoading.value = false;
        customSnackBar(
          title: "No Internet",
          message: "Please check your internet connection",
          isError: true
        );
        return;
      }

      allCategories.bindStream(_categoryService.getCategoriesStream());
      allBanners.bindStream(_bannerService.getBannersStream());
      allProducts.bindStream(_productService.getProductsStream());

      _categorySubscription = _categoryService.getCategoriesStream().listen(
        (data) {
          isLoading.value = false;
        },
        onError: (err) {
          isLoading.value = false;
          debugPrint("Stream Error: $err");
        },
      );

      Future.delayed(const Duration(seconds: 5), () {
        if (isLoading.value) isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      debugPrint("General Error: $e");
    }
  }

  @override
  void onClose() {
    _categorySubscription?.cancel();
    super.onClose();
  }
}
