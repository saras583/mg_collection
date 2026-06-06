// lib/views/admin/screens/admin_banner_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminBannerScreen extends StatefulWidget {
  const AdminBannerScreen({super.key});

  @override
  State<AdminBannerScreen> createState() => _AdminBannerScreenState();
}

class _AdminBannerScreenState extends State<AdminBannerScreen> {
  final supabase = Supabase.instance.client;
  final ImagePicker picker = ImagePicker();

  List<Map<String, dynamic>> banners = [];
  List<Map<String, dynamic>> products = [];
  bool loading = true;
  bool isUploading = false;

  final titleController = TextEditingController();
  File? selectedImage;
  int? selectedProductId;

  @override
  void initState() {
    super.initState();
    fetchBanners();
    fetchProducts();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<void> fetchBanners() async {
    try {
      final data = await supabase
          .from('banners')
          .select()
          .order('created_at', ascending: false);
      setState(() {
        banners = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print('Fetch banners error: $e');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final data = await supabase
          .from('products')
          .select('id, name')
          .order('name');
      setState(() {
        products = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      print('Fetch products error: $e');
    }
  }

  Future<String?> _uploadBannerImage(File imageFile) async {
    try {
      final fileName =
          'banner_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabase.storage
          .from('banners')
          .upload(fileName, imageFile);
      return supabase.storage.from('banners').getPublicUrl(fileName);
    } catch (e) {
      print('Banner upload error: $e');
      return null;
    }
  }

  Future<void> addBanner() async {
    if (titleController.text.isEmpty || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill title and select an image')),
      );
      return;
    }

    setState(() => isUploading = true);

    try {
      final imageUrl = await _uploadBannerImage(selectedImage!);
      if (imageUrl == null) throw Exception('Image upload failed');

      await supabase.from('banners').insert({
        'title': titleController.text.trim(),
        'image': imageUrl,
        'product_id': selectedProductId,
        'is_active': true,
      });

      await fetchBanners();
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banner added ✅')),
      );
    } catch (e) {
      print('Add banner error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isUploading = false);
    }
  }

  Future<void> toggleBanner(Map<String, dynamic> banner) async {
    try {
      await supabase
          .from('banners')
          .update({'is_active': !(banner['is_active'] as bool)})
          .eq('id', banner['id']);
      await fetchBanners();
    } catch (e) {
      print('Toggle error: $e');
    }
  }

  Future<void> deleteBanner(Map<String, dynamic> banner) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Banner'),
        content: Text('Delete "${banner['title']}"?'),
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
      await supabase.from('banners').delete().eq('id', banner['id']);
      await fetchBanners();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banner deleted')),
      );
    } catch (e) {
      print('Delete error: $e');
    }
  }

  void showAddDialog() {
    titleController.clear();
    selectedImage = null;
    selectedProductId = null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Banner'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Banner Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Link to product dropdown
                DropdownButtonFormField<int?>(
                  value: selectedProductId,
                  decoration: const InputDecoration(
                    labelText: 'Link to Product (optional)',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('No product link'),
                    ),
                    ...products.map((p) => DropdownMenuItem(
                          value: p['id'] as int,
                          child: Text(
                            p['name'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                  ],
                  onChanged: (val) {
                    setDialogState(() => selectedProductId = val);
                  },
                ),
                const SizedBox(height: 12),

                // Image picker
                GestureDetector(
                  onTap: () async {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      setDialogState(
                          () => selectedImage = File(image.path));
                    }
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined,
                                  size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Tap to select banner image',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isUploading ? null : addBanner,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Banner Management'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '${banners.length} banners',
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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : banners.isEmpty
              ? const Center(
                  child: Text('No banners yet. Tap + to add.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    final isActive = banner['is_active'] as bool;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner image preview
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14),
                            ),
                            child: Image.network(
                              banner['image'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 150,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        banner['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      if (banner['product_id'] != null)
                                        Text(
                                          'Linked to product #${banner['product_id']}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                ),

                                // Active toggle
                                Row(
                                  children: [
                                    Text(
                                      isActive ? 'Active' : 'Inactive',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isActive
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                    ),
                                    Switch(
                                      value: isActive,
                                      activeColor: Colors.green,
                                      onChanged: (_) => toggleBanner(banner),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => deleteBanner(banner),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}