class ProductModel {
  final String id;
  final String categoryId;
  final String description;
  final String discountPrice;
  final String image;
  final String name;
  final String price;
  final String stock;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.description,
    required this.discountPrice,
    required this.image,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory ProductModel.fromSnapshot(Map<String, dynamic>? data) {
    return ProductModel(
      id: data?['id']?.toString() ?? '',
      categoryId: data?['categories_id']?.toString() ?? '',
      description: data?['description']?.toString() ?? '',
      discountPrice: data?['discount_price']?.toString() ?? '0',
      image: data?['image']?.toString() ?? '',
      name: data?['name']?.toString() ?? '',
      price: data?['price']?.toString() ?? '0',
      stock: data?['stock']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categories_id': categoryId,
      'description': description,
      'discount_price': discountPrice,
      'image': image,
      'name': name,
      'price': price,
      'stock': stock,
    };
  }


}