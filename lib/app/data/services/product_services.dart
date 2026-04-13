import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../model/product_model.dart';

class ProductServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ProductModel>> getProductsStream() {
    return _db
        .collection('products')
        .orderBy('id', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ProductModel.fromSnapshot(data);
      }).toList();
    })
        .handleError((error) {
      debugPrint("❌ Firestore Stream Error: $error");
      return <ProductModel>[];
    });
  }



  Stream<List<ProductModel>> getProductsByCategory(String categoryId) {
    return _db
        .collection('products')
        .where('categories_id', isEqualTo: categoryId) // এখানে ফিল্টার হচ্ছে
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ProductModel.fromSnapshot(doc.data()))
        .toList());
  }
}