import 'package:firebase_ecom_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../utils/theme/app_colors.dart';
import '../../../../utils/theme/size.dart';
import '../../../home/views/widgets/app_drawer.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.EDIT_PROFILE),
            icon: const Icon(Iconsax.edit_2, size: 22),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.onInit(),
        child: Obx(() {
          // ডাটা লোড না হওয়া পর্যন্ত লোডার
          if (controller.userData.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = controller.userData.value!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            child: Column(
              children: [
                // --- Profile Image Section ---
                _buildProfileHeader(data, theme),

                const SizedBox(height: 30),

                // --- Account Information ---
                _buildSectionTitle('Account Information', theme),
                const SizedBox(height: 12),

                _buildInfoCard(
                  items: [
                    _ProfileTile(
                      icon: Iconsax.user,
                      label: 'Name',
                      value: data['name'],
                    ),
                    _ProfileTile(
                      icon: Iconsax.sms,
                      label: 'Email',
                      value: data['email'],
                    ),
                    _ProfileTile(
                      icon: Iconsax.call,
                      label: 'Phone',
                      value: data['phone'] ?? 'Not set',
                    ),
                    _ProfileTile(
                      icon: Iconsax.location,
                      label: 'Address',
                      value: data['address'] ?? 'Not set',
                      isLast: true,
                    ),
                  ],
                  theme: theme,
                ),

                const SizedBox(height: 25),

                // --- Actions Section ---
                _buildSectionTitle('Settings', theme),
                const SizedBox(height: 12),

                _buildInfoCard(
                  items: [
                    _ProfileTile(
                      icon: Iconsax.setting_2,
                      label: 'App Settings',
                      value: 'Theme, Notifications',
                    ),
                    _ProfileTile(
                      icon: Iconsax.lock,
                      label: 'Security',
                      value: 'Change Password',
                      isLast: true,
                      onTap: () => showChangePasswordSheet(context),
                    ),
                  ],
                  theme: theme,
                ),

                const SizedBox(height: 40),

                // --- Logout Button ---
                _buildLogoutButton(),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  void showChangePasswordSheet(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),

              AppTextFromField(
                controller: controller.currentPasswordController,
                label: "Current Password",
                obscureText: true,
                hintText: 'Current Password',
              ),
              const SizedBox(height: 15),

              AppTextFromField(
                controller: controller.newPasswordController,
                label: "New Password",
                obscureText: true,
                hintText: 'New Password',
              ),
              const SizedBox(height: 15),

              AppTextFromField(
                controller: controller.confirmPasswordController,
                label: "Confirm New Password",
                obscureText: true,
                hintText: 'Confirm New Password',
              ),
              const SizedBox(height: 25),

              Obx(
                    () => AppButton(
                  label:  "Update Password",
                  isLoading: controller.isLoading.value,
                  onPressed:  () {
                    controller.updatePassword();
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }


  // --- UI Helper Methods ---

  Widget _buildProfileHeader(Map data, ThemeData theme) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          data['name'] ?? '',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          data['email'] ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required List<Widget> items,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: items),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => controller.handleLogout(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withOpacity(0.1),
          foregroundColor: Colors.red,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: const Icon(Iconsax.logout, size: 20),
        label: const Text(
          'Sign Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }




}

// --- Custom Reusable Tile ---
class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isLast;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.label,
    this.value,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          title: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          subtitle: Text(
            value ?? 'N/A',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Iconsax.arrow_right_3,
            size: 16,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            indent: 70,
            endIndent: 20,
            height: 1,
            color: Colors.grey.withOpacity(0.1),
          ),
      ],
    );
  }

}
