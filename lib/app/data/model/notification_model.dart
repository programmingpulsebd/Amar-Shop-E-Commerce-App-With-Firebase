class NotificationModel {
  final String title;
  final String body;
  final DateTime time;

  NotificationModel({
    required this.title,
    required this.body,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "body": body,
    "time": time.toIso8601String(),
  };

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json["title"],
      body: json["body"],
      time: DateTime.parse(json["time"]),
    );
  }
}