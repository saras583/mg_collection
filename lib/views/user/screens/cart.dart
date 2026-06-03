import 'package:flutter/material.dart';
import 'package:mgcollection_app/models/product_model.dart';
import 'package:mgcollection_app/views/user/screens/productdetailedscreens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final user = supabase.auth.currentUser;

    if (user == null) return [];

    final data = await supabase
        .from('cart')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> deleteItem(int id) async {
    try {
      await supabase.from('cart').delete().eq('id', id);

      if (!mounted) return;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> openProductDetails(Map<String, dynamic> cartItem) async {
    try {
      final productId = cartItem['product_id'];

      if (productId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product id not found')),
        );
        return;
      }

      final data = await supabase
          .from('products')
          .select()
          .eq('id', productId)
          .single();

      final product = ProductModel(
        id: data['id'],
        name: data['name']?.toString() ?? '',
        price: (data['price'] as num?)?.toDouble() ?? 0.0,
        image: data['image']?.toString() ?? '',
        description: data['description']?.toString() ?? '',
        category: data['category']?.toString() ?? '',
        rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Widget cartImage(String image) {
    return Image.network(
      image,
      width: 70,
      height: 70,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 70,
          height: 70,
          color: Colors.grey.shade300,
          child: const Icon(Icons.image_not_supported),
        );
      },
    );
  }

  double calculateTotal(List<Map<String, dynamic>> items) {
    double total = 0;

    for (final item in items) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final quantity = (item['quantity'] as num?)?.toInt() ?? 1;

      total += price * quantity;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text('Cart is Empty'),
            );
          }

          final total = calculateTotal(items);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () {
                          openProductDetails(item);
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: cartImage(item['image']?.toString() ?? ''),
                        ),
                        title: Text(
                          item['product_name']?.toString() ?? 'No Name',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '₹${item['price'] ?? 0}  |  Qty: ${item['quantity'] ?? 1}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await deleteItem(item['id']);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total: ₹${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add checkout navigation here if needed
                      },
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}