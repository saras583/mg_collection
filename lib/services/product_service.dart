import 'package:mgcollection_app/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final supabase = Supabase.instance.client;

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await supabase
          .from('products')
          .select()
          .order('id', ascending: false);

      print('RAW PRODUCTS COUNT: ${response.length}');

      return response.map<ProductModel>((json) {
        try {
          return ProductModel.fromJson(json);
        } catch (e) {
          print('PARSE ERROR for product ${json['id']}: $e');
          print('RAW JSON: $json');
          // ✅ return a placeholder instead of crashing the whole list
          return ProductModel(
            id: json['id'] ?? 0,
            name: json['name']?.toString() ?? 'Unknown',
            price: (json['price'] as num?)?.toDouble() ?? 0.0,
            image: json['image']?.toString() ?? '',
            category: json['category']?.toString() ?? '',
            rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
            description: json['description']?.toString() ?? '',
          );
        }
      }).toList();
    } catch (e) {
      print('FETCH PRODUCTS ERROR: $e');
      return [];
    }
  }

  Future<ProductModel?> fetchProductById(int id) async {
    try {
      final data = await supabase
          .from('products')
          .select()
          .eq('id', id)
          .single();
      return ProductModel.fromJson(data);
    } catch (e) {
      print('Fetch product by id error: $e');
      return null;
    }
  }

  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    try {
      final response = await supabase
          .from('products')
          .select()
          .eq('category', category)
          .order('id', ascending: false);
      return response
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Fetch by category error: $e');
      return [];
    }
  }
}