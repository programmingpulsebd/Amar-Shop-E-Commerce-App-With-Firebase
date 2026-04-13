import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_snackbar.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Sign Up ---
  Future<UserCredential?> signUp(String name, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'name': name,
          'email': email,
          'phone': '',
          'address': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        customSnackBar(title: "Success", message: "Account created successfully!");
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      customSnackBar(title: "Error", message: e.toString(), isError: true);
      return null;
    }
  }

  // --- Login ---
  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      customSnackBar(title: "Welcome Back", message: "Login successful");
      return credential;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    }
  }


  // এটি আপনার AuthService ক্লাসের ভেতরে থাকবে
  Stream<DocumentSnapshot> getUserData() {
    try {
      // বর্তমানে লগইন থাকা ইউজারের UID নেওয়া হচ্ছে
      String? uid = _auth.currentUser?.uid;

      if (uid != null) {
        // 'users' কালেকশন থেকে ওই নির্দিষ্ট UID-র ডাটা স্ট্রিম হিসেবে রিটার্ন করছে
        return _firestore.collection('users').doc(uid).snapshots();
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      rethrow;
    }
  }

  // --- Forgot Password ---
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      customSnackBar(title: "Success", message: "Password reset link sent to your email");
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      rethrow;
    }
  }
  // --- Update Profile ---
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(uid).update(data);
      customSnackBar(title: "Updated", message: "Profile saved successfully");
    } catch (e) {
      customSnackBar(title: "Update Failed", message: e.toString(), isError: true);
    }
  }


  // AuthService ক্লাসে এটি যোগ করুন
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;
      String email = user!.email!;

      // ১. রি-অথেন্টিকেশন (সিকিউরিটির জন্য জরুরি)
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: currentPassword);
      await user.reauthenticateWithCredential(credential);

      // ২. নতুন পাসওয়ার্ড সেট করা
      await user.updatePassword(newPassword);

      customSnackBar(title: "Success", message: "Password updated successfully");
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e); // আপনার আগের তৈরি করা এরর হ্যান্ডেলার
      rethrow;
    }
  }



  // --- Error Handler Helper ---
  void _handleAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found': message = "No user found with this email."; break;
      case 'wrong-password': message = "Incorrect password."; break;
      case 'email-already-in-use': message = "Email already registered."; break;
      case 'invalid-email': message = "Invalid email format."; break;
      default: message = e.message ?? "Authentication failed.";
    }
    customSnackBar(title: "Auth Error", message: message, isError: true);
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    customSnackBar(title: "Logged Out", message: "See you again!");
  }
}