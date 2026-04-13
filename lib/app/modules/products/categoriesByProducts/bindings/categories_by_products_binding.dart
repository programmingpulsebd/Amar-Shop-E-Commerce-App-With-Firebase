import 'package:get/get.dart';

import '../controllers/categories_by_products_controller.dart';

class CategoriesByProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoriesByProductsController>(
      () => CategoriesByProductsController(),
    );
  }
}
