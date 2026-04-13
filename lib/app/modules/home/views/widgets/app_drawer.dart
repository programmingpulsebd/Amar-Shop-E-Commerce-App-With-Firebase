import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../utils/theme/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (user == null) return const Drawer(child: Center(child: Text("Please Login")));

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [

          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
            builder: (context, snapshot) {
              String userName = "User";
              if (snapshot.hasData && snapshot.data!.exists) {
                userName = snapshot.data!.get('name') ?? user.displayName ?? "User";
              } else {
                userName = user.displayName ?? user.email?.split('@').first ?? "User";
              }

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          'https://ui-avatars.com/api/?name=$userName&background=random&length=2&bold=true',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// User Name
                    Text(
                      userName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// User Email
                    Text(
                      user.email ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white70 : Colors.black54,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          /// --- Drawer Items ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              children: [
                _buildDrawerItem(
                  icon: Iconsax.home_1,
                  title: 'Home',
                  onTap: () => Get.back(),
                ),
                _buildDrawerItem(
                  icon: Iconsax.bag_2,
                  title: 'My Orders',
                  onTap: () => Get.toNamed(Routes.MY_ORDERS),
                ),
                _buildDrawerItem(
                  icon: Iconsax.heart,
                  title: 'Wishlist',
                  onTap: () => Get.toNamed(Routes.FAVOURITE),
                ),

                _buildDrawerItem(
                  icon: Iconsax.category,
                  title: 'Categories List',
                  onTap: () => Get.toNamed(Routes.CATEGORIES),
                ),

                _buildDrawerItem(
                  icon: Iconsax.shop,
                  title: 'Product List',
                  onTap: () => Get.toNamed(Routes.ALL_PRODUCTS),
                ),

                _buildDrawerItem(
                  icon: Iconsax.notification,
                  title: 'Notifications',
                  onTap: () => Get.toNamed(Routes.NOTIFICATION),
                ),


                const Divider(indent: 10, endIndent: 10),

                _buildDrawerItem(
                  icon: Iconsax.logout,
                  title: 'Logout',
                  iconColor: Colors.redAccent,
                  onTap: () async {
                    await auth.signOut();
                    Get.offAllNamed(Routes.LOGIN);
                  },
                ),
              ],
            ),
          ),

          /// --- Version ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Version 1.0.0',
              style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22, color: iconColor ?? AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
      visualDensity: const VisualDensity(vertical: -1),
    );
  }
}