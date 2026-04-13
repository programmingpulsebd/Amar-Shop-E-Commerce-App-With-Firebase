import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sslcommerz/model/SSLCEMITransactionInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/NonPhysicalGoods.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../data/services/bkash_services.dart';

class PaymentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final BkashPaymentService _bkashService = BkashPaymentService();

  final double totalAmount = Get.arguments['totalAmount'] ?? 0.0;
  final List items = Get.arguments['items'] ?? [];

  var selectedMethod = 0.obs; // 0 = COD, 1 = Online
  var isProcessing = false.obs;

  void changePaymentMethod(int index) {
    selectedMethod.value = index;
  }

  void processOrder() async {
    if (items.isEmpty) {
      customSnackBar(
        title: 'Error',
        message: 'আপনার কার্ট খালি!',
        isError: true,
      );
      return;
    }
    isProcessing.value = true;
    try {
      if (selectedMethod.value == 0) {
        await _saveOrderToFirestore("Cash on Delivery");
      } else {
        await _processOnlinePayment();
      }
    } catch (e) {
      customSnackBar(
        title: 'Error',
        message: 'অর্ডার সম্পন্ন হয়নি: $e',
        isError: true,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _saveOrderToFirestore(String paymentType) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      String userAddress = "Address not found";

      var userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        // আপনার Firestore-এর 'users' ডকুমেন্টে ফিল্ডের নাম 'address' হতে হবে
        userAddress = userDoc.data()!['address'] ?? "No address provided";
      }

      String orderId = "ORD${DateTime.now().millisecondsSinceEpoch}";

      // ২. অর্ডারের ডাটা ম্যাপ তৈরি
      Map<String, dynamic> orderData = {
        'userId': user.uid,
        'userEmail': user.email ?? '',
        'items': items,
        'totalAmount': totalAmount,
        'paymentMethod': paymentType,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
        'orderId': orderId,
        'address': userAddress, // এখানে অ্যাড্রেসটি পাঠানো হলো
      };

      // ৩. Firestore-এ অর্ডার সেভ করা
      await _firestore.collection('orders').doc(orderId).set(orderData);

      // ৪. কার্ট খালি করা
      await _clearUserCart(user.uid);

      _showOrderSuccess();
    } catch (e) {
      print("Firestore Error: $e");
      rethrow;
    }
  }

  Future<void> _clearUserCart(String userId) async {
    try {
      var cartRef = _firestore
          .collection('carts')
          .doc(userId)
          .collection('items');
      var snapshot = await cartRef.get();
      WriteBatch batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      print("Cart Clear Error: $e");
    }
  }

  /// --- বিকাশ পেমেন্ট প্রসেস ---
  Future<void> _processOnlinePayment() async {
    try {
      String invoiceId = "INV${DateTime.now().millisecondsSinceEpoch}";

      // বিকাশ সার্ভিস কল করা
      final response = await _bkashService.payWithBkash(
        amount: totalAmount,
        invoice: invoiceId,
      );

      // বিকাশ রেসপন্স চেক (প্যাকেজ অনুযায়ী সাধারণত সফল হলে ট্রানজেকশন আইডি থাকে)
      if (response != null ) {
        // পেমেন্ট সফল হলে অর্ডারের তথ্য সেভ করা
        await _saveOrderToFirestore("bKash (TrxID: ${response.trxId})");
      } else {
        customSnackBar(title: 'Payment Failed', message: 'পেমেন্ট সম্পন্ন হয়নি।', isError: true);
      }
    } catch (e) {
      print("bKash Error: $e");
      customSnackBar(title: 'Payment Error', message: e.toString(), isError: true);
    }
  }
  void _showOrderSuccess() {
    customSnackBar(
      title: 'Success!',
      message: 'আপনার অর্ডারটি সফলভাবে গ্রহণ করা হয়েছে।',
    );
  }
}
