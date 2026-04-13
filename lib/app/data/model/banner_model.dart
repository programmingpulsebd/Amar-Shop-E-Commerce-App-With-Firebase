class BannerModel {
  final String id;
  final String image;

  BannerModel({required this.id, required this.image});

  factory BannerModel.fromSnapshot(Map<String, dynamic> data) {
    return BannerModel(
      id: data['id'] ?? '',
      image: data['image'] ?? '',
    );
  }
}