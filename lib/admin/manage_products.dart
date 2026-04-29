import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  int? editingIndex;

  File? selectedImage;
  
  final ImagePicker picker = ImagePicker();

  final nameController = TextEditingController();

  final priceController = TextEditingController();

  final imageController = TextEditingController();

  final productBox = Hive.box('products');

  void saveProduct() {
    final price = double.tryParse(priceController.text);

    if (nameController.text.isEmpty ||
        price == null ||
        imageController.text.isEmpty) {
      return;
    }

    final productData = {
      'name': nameController.text,
      'price': price,
      'image': imageController.text,
    };
    if (editingIndex == null) {
      productBox.add(productData);
    } else {
      productBox.putAt(editingIndex!, productData);

      editingIndex = null;
    }

    nameController.clear();
    priceController.clear();
    imageController.clear();

    setState(() {});
  }

  void deleteProduct(int index) {
    productBox.deleteAt(index);
    setState(() {});
  }

  void editProduct(int index) {
    final product = productBox.getAt(index);

    nameController.text = product['name'];
    priceController.text = product['price'].toString();
    imageController.text = product['image'];

    editingIndex = index;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Management')),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Product Name"),
            ),
            SizedBox(height: 10),

            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Price"),
            ),

            SizedBox(height: 10),

            TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: "imagepath"),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: productBox.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = productBox.getAt(index);
                  return ListTile(
                    leading: Image.asset(product['image'], width: 50),
                    title: Text(product['name']),
                    subtitle: Text("₹${product['price']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            editProduct(index);
                          },
                          icon: Icon(Icons.edit, color: Colors.red),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteProduct(index);
                          },
                          icon: Icon(Icons.delete,color: Colors.red,),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: saveProduct,
              child: Text(
                editingIndex == null ? 'Add Product' : "updat Product",
              ),
            ),
            ElevatedButton(
  onPressed: pickImage,
  child: Text("Pick Image"),
),
          ],
        ),
      ),
    );
  }
  Future<void> pickImage() async {
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (picked != null) {
    setState(() {
      selectedImage = File(picked.path);
      imageController.text = picked.path;
    });
  }
}
}
