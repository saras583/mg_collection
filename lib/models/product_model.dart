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
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      category: json['category'],
      rating: (json['rating'] as num).toDouble(),
      description: json['description'],
    );
  }
}