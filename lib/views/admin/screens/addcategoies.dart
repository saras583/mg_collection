

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<AdminCategoryScreen> createState() =>
      _AdminCategoryScreenState();
}

class _AdminCategoryScreenState
    extends State<AdminCategoryScreen> {
  final supabase = Supabase.instance.client;

  final TextEditingController categoryController =
      TextEditingController();

  List categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final data = await supabase
          .from('categories')
          .select()
          .order('id');

      setState(() {
        categories = data;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addCategory() async {
    if (categoryController.text.trim().isEmpty) return;

    try {
      await supabase.from('categories').insert({
        "name": categoryController.text.trim(),
      });

      categoryController.clear();

      fetchCategories();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Category Added"),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await supabase
          .from('categories')
          .delete()
          .eq('id', id);

      fetchCategories();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Category Deleted"),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: "Category Name",
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: addCategory,
                child: const Text(
                  "Add Category",
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: categories.isEmpty
                  ? const Center(
                      child: Text(
                        "No Categories Found",
                      ),
                    )
                  : ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category =
                            categories[index];

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                "${index + 1}",
                              ),
                            ),
                            title: Text(
                              category['name'],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                deleteCategory(
                                  category['id'],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}