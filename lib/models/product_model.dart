class ProductModel {
  final int id;
  final String name;
  final double price;
  final String image;
  final String category;
  final double rating;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.rating,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      // ✅ handles both 'image' and 'image_url' column names
      image: json['image']?.toString() ??
          json['image_url']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? '',
    );
  }

  // ✅ useful for passing to detail screens
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'category': category,
      'rating': rating,
      'description': description,
    };
  }
}