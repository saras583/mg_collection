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

  List<Map<String, dynamic>> cartItems = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() => loading = false);
        return;
      }

      final data = await supabase
          .from('cart')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      setState(() {
        cartItems = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      print('Fetch cart error: $e');
      setState(() => loading = false);
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await supabase.from('cart').delete().eq('id', id);
      setState(() {
        cartItems.removeWhere((item) => item['id'] == id);
      });
      if (!mounted) return;
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

  Future<void> updateQuantity(int id, int newQty) async {
    if (newQty < 1) {
      await deleteItem(id);
      return;
    }
    try {
      await supabase
          .from('cart')
          .update({'quantity': newQty})
          .eq('id', id);
      setState(() {
        final index = cartItems.indexWhere((item) => item['id'] == id);
        if (index != -1) cartItems[index]['quantity'] = newQty;
      });
    } catch (e) {
      print('Update quantity error: $e');
    }
  }

  Future<void> openProductDetails(Map<String, dynamic> cartItem) async {
    try {
      final productId = cartItem['product_id'];
      if (productId == null) return;

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
          builder: (_) =>  ProductDetailScreen(
                                      product: product.toJson(),
                                    ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  double get totalPrice {
    double total = 0;
    for (final item in cartItems) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final qty = (item['quantity'] as num?)?.toInt() ?? 1;
      total += price * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(
                  '${cartItems.length} items',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text(
                        'Your cart is empty',
                        style:
                            TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Add items to get started',
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: fetchCartItems,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            final qty =
                                (item['quantity'] as num?)?.toInt() ?? 1;
                            final price =
                                (item['price'] as num?)?.toDouble() ?? 0.0;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    
                                    GestureDetector(
                                      onTap: () =>
                                          openProductDetails(item),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        child: Image.network(
                                          item['image']?.toString() ?? '',
                                          width: 75,
                                          height: 75,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            width: 75,
                                            height: 75,
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                                Icons.image_not_supported),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['product_name']
                                                    ?.toString() ??
                                                'No Name',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '₹${price.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF5DA9E9),
                                            ),
                                          ),
                                          const SizedBox(height: 8),

                                          
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => updateQuantity(
                                                    item['id'], qty - 1),
                                                child: Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: BoxDecoration(
                                                    color: isDark
                                                        ? Colors.grey.shade700
                                                        : Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Icon(
                                                      Icons.remove,
                                                      size: 16),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                child: Text(
                                                  '$qty',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => updateQuantity(
                                                    item['id'], qty + 1),
                                                child: Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                        0xFF5DA9E9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Icon(
                                                      Icons.add,
                                                      size: 16,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () =>
                                          deleteItem(item['id']),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // ── TOTAL + CHECKOUT ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.08),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(),
                          const SizedBox(height: 12),
                          SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}