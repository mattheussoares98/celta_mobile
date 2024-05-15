class NotificationsModel {
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final String id;

  NotificationsModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "imageUrl": imageUrl,
        "id": id,
      };

  factory NotificationsModel.fromJson(Map json) => NotificationsModel(
        title: json["title"],
        subtitle: json["subtitle"],
        imageUrl: json["imageUrl"],
        id: json["id"],
      );
}
