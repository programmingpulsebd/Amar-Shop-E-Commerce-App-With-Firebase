import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/product_model.dart';

class CartService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _cartRef =>
      _db.collection('users').doc(_auth.currentUser!.uid).collection('cart');

  Future<void> addToFirestore(ProductModel product, int quantity) async {
    await _cartRef.doc(product.id).set({
      ...product.toMap(), // আপনার মডেলের toMap মেথডটি লাগবে
      'quantity': FieldValue.increment(quantity),
      'added_at': FieldValue.serverTimestamp(),

    }, SetOptions(merge: true));
  }

  // ২. কোয়ান্টিটি আপডেট করা (+ অথবা -)
  Future<void> updateQuantity(String productId, int delta) async {
    await _cartRef.doc(productId).update({
      'quantity': FieldValue.increment(delta),
    });
  }

  // ৩. কার্ট থেকে প্রোডাক্ট ডিলিট করা
  Future<void> removeFromFirestore(String productId) async {
    await _cartRef.doc(productId).delete();
  }

  // ৪. রিয়েল-টাইম কার্ট ডাটা লিসেন করা
  Stream<QuerySnapshot> getCartStream() {
    return _cartRef.orderBy('added_at', descending: true).snapshots();
  }
}