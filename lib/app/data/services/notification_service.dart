import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../modules/notifications/notification/controllers/notification_controller.dart';
import '../../routes/app_pages.dart';
import 'LocalNotificationService.dart';

class NotificationService {
  static Future<void> init() async {
    // 🔥 Permission
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("🔔 Permission: ${settings.authorizationStatus}");

    // 🔥 Subscribe topic
    await FirebaseMessaging.instance.subscribeToTopic("all_users");

    final controller = Get.find<NotificationController>();

    // 🔥 FOREGROUND (MAIN FIX HERE)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "No Title";
      final body = message.notification?.body ?? "No Body";

      // 1. Save to history
      controller.addNotification(title, body);

      // 2. SHOW SYSTEM NOTIFICATION (IMPORTANT FIX)
      LocalNotificationService.show(title, body);
    });

    // 🔥 BACKGROUND CLICK
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Get.toNamed(Routes.NOTIFICATION);
    });

    // 💀 TERMINATED
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Get.toNamed(Routes.NOTIFICATION);
      }
    });
  }
}