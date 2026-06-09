import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mgcollection_app/views/admin/screens/product_detailed_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<AdminProductScreen> {
  final supabase = Supabase.instance.client;
  final ImagePicker picker = ImagePicker();

  List<Map<String, dynamic>> products = [];
  bool loadingProducts = true;

  final List<String> categories = [
    "Shirt", "Watch", "Skincare", "Pants", "Shoes", "Jewellery",
  ];

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final stockController = TextEditingController();

  String selectedCategory = "Shoes";
  File? selectedImage;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    stockController.clear();
    selectedImage = null;
    selectedCategory = "Shoes";
  }

  Future<void> fetchProducts() async {
    try {
      final response = await supabase
          .from('products')
          .select()
          .order('id', ascending: false);
      setState(() {
        products = List<Map<String, dynamic>>.from(response);
        loadingProducts = false;
      });
    } catch (e) {
      setState(() => loadingProducts = false);
      print('Fetch error: $e');
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      await supabase.storage.from('products').upload(fileName, imageFile);
      return supabase.storage.from('products').getPublicUrl(fileName);
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void> addProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    setState(() => isUploading = true);

    try {
      final imageUrl = await _uploadImage(selectedImage!);
      if (imageUrl == null) throw Exception('Image upload failed');

      await supabase.from('products').insert({
        "name": nameController.text.trim(),
        "price": double.parse(priceController.text.trim()),
        "category": selectedCategory,
        "description": descriptionController.text.trim(),
        "stock": int.tryParse(stockController.text.trim()) ?? 0,
        "image": imageUrl,
      });

      await fetchProducts();
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully ')),
      );
    } catch (e) {
      print('Add error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isUploading = false);
    }
  }

  Future<void> updateProduct(Map product) async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => isUploading = true);

    try {
      String? imageUrl = product['image'];
      if (selectedImage != null) {
        imageUrl = await _uploadImage(selectedImage!);
      }

      await supabase.from('products').update({
        "name": nameController.text.trim(),
        "price": double.parse(priceController.text.trim()),
        "category": selectedCategory,
        "description": descriptionController.text.trim(),
        "stock": int.tryParse(stockController.text.trim()) ?? 0,
        "image": imageUrl,
      }).eq('id', product['id']);

      await fetchProducts();
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully ')),
      );
    } catch (e) {
      print('Update error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isUploading = false);
    }
  }

  Future<void> deleteProduct(Map product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Delete "${product['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await supabase.from('products').delete().eq('id', product['id']);
      await fetchProducts();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted')),
      );
    } catch (e) {
      print('Delete error: $e');
    }
  }

  Widget _buildProductForm(StateSetter setDialogState) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Product Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Price (₹)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: stockController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Stock',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            items: categories.map((cat) {
              return DropdownMenuItem(value: cat, child: Text(cat));
            }).toList(),
            onChanged: (value) {
              setDialogState(() => selectedCategory = value!);
            },
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 80,
              );
              if (image != null) {
                setDialogState(() => selectedImage = File(image.path));
              }
            },
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              child: selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(selectedImage!, fit: BoxFit.cover),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined,
                            size: 36, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Tap to select image',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void showAddDialog() {
    _clearControllers();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Product'),
          content: _buildProductForm(setDialogState),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isUploading ? null : addProduct,
              child: isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void showEditDialog(Map product) {
    nameController.text = product['name'] ?? '';
    priceController.text = product['price']?.toString() ?? '';
    descriptionController.text = product['description'] ?? '';
    stockController.text = product['stock']?.toString() ?? '0';
    selectedCategory = categories.contains(product['category'])
        ? product['category']
        : categories.first;
    selectedImage = null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show existing image
              if (selectedImage == null && product['image'] != null)
                Container(
                  height: 80,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(product['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              _buildProductForm(setDialogState),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isUploading ? null : () => updateProduct(product),
              child: isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '${products.length} items',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: loadingProducts
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text('No products yet. Tap + to add.'))
              : RefreshIndicator(
                  onRefresh: fetchProducts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: product['image'] != null &&
                                    product['image'].toString().isNotEmpty
                                ? Image.network(
                                    product['image'],
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const CircleAvatar(
                                      child: Icon(Icons.image),
                                    ),
                                  )
                                : const CircleAvatar(
                                    child: Icon(Icons.image)),
                          ),
                          title: Text(
                            product['name'] ?? '',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('₹${product["price"]}'),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius:
                                          BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      product['category'] ?? '',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.blue.shade700),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Stock: ${product['stock'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: (product['stock'] ?? 0) == 0
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blue),
                                onPressed: () => showEditDialog(product),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () => deleteProduct(product),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}