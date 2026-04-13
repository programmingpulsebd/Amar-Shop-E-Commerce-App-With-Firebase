class CategoryModel {
  final String id;
  final String name;
  final String icon;

  CategoryModel({required this.id, required this.name, required this.icon});

  // ফায়ারস্টোর থেকে ডাটা কনভার্ট করার জন্য
  factory CategoryModel.fromSnapshot(Map<String, dynamic> data) {
    return CategoryModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
    );
  }
}