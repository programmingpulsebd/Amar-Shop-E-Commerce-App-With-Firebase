import 'package:get/get.dart';

import '../../../../data/model/product_model.dart';
import '../../../../data/services/product_services.dart';

class CategoriesByProductsController extends GetxController {


  final ProductServices _service = ProductServices();
  var products = <ProductModel>[].obs;
  late String categoryId;
  late String categoryName;

  @override
  void onInit() {
    super.onInit();
    categoryId = Get.arguments['catId'];
    categoryName = Get.arguments['catName'];

    products.bindStream(_service.getProductsByCategory(categoryId));
  }


}
