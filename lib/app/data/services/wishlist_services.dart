import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/product_model.dart';

class WishlistService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // উইশলিস্ট কালেকশন রেফারেন্স
  CollectionReference get _wishlistRef {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    return _db.collection('users').doc(user.uid).collection('wishlist');
  }

  // ফেভারিটে যোগ করা বা রিমুভ করা (Toggle)
  Future<void> toggleFavorite(ProductModel product, bool isFavorite) async {
    if (isFavorite) {
      await _wishlistRef.doc(product.id).set(product.toMap());
    } else {
      await _wishlistRef.doc(product.id).delete();
    }
  }

  // রিয়েল-টাইম উইশলিস্ট ডাটা লিসেন করা
  Stream<QuerySnapshot> getWishlistStream() {
    return _wishlistRef.snapshots();
  }
}