import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  final box = GetStorage();

  var notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void addNotification(String title, String body) {
    final data = {
      "title": title,
      "body": body,
      "time": DateTime.now().toIso8601String(),
    };

    notifications.insert(0, data);
    box.write("notifications", notifications.toList());
  }

  void loadNotifications() {
    final data = box.read("notifications");
    if (data != null) {
      notifications.value = List<Map<String, dynamic>>.from(data);
    }
  }

  void clearAll() {
    notifications.clear();
    box.remove("notifications");
  }
}