import 'package:firebase_ecom_app/app/modules/auth/profile/views/profile_view.dart';
import 'package:firebase_ecom_app/app/modules/cart/views/cart_view.dart';
import 'package:firebase_ecom_app/app/modules/favourite/views/favourite_view.dart';
import 'package:firebase_ecom_app/app/modules/home/views/home_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../notifications/notification/controllers/notification_controller.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  List<Widget> pages = [
    HomeView(),
    FavouriteView(),
    CartView(),
    ProfileView()
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }



}