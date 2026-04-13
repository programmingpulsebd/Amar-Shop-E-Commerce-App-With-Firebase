import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/categories_model.dart';

class CategoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<CategoryModel>> getCategoriesStream() {
    return _db
        .collection('categories')
        .orderBy('id',descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CategoryModel.fromSnapshot(doc.data()))
        .toList());
  }



}



