import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/banner_model.dart';

class BannerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<BannerModel>> getBannersStream() {
    return _db
        .collection('banners')
        .orderBy('id', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => BannerModel.fromSnapshot(doc.data()))
        .toList());
  }
}