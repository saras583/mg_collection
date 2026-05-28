import 'package:mgcollection_app/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final supabase = Supabase.instance.client;

  Future<List<ProductModel>> fetchProducts() async {
    final response = await supabase
        .from('products')
        .select();

    return response
        .map<ProductModel>(
          (json) => ProductModel.fromJson(json),
        )
        .toList();
  }
}