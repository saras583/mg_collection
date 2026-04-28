import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final nameController = TextEditingController();

  final priceController = TextEditingController();

  final imageController = TextEditingController();

  final productBox = Hive.box('products');

  void addproduct() {
    final price = double.tryParse(priceController.text);

    if (nameController.text.isEmpty ||
        price == null ||
        imageController.text.isEmpty) {
      return;
    }
    productBox.add({
      'name': nameController.text,
      'price': double.parse(priceController.text),
      "image": imageController.text,
    });

    nameController.clear();
    priceController.clear();
    imageController.clear();

    setState(() {});
  }

  void deleteProduct(int index) {
    productBox.deleteAt(index);
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
                    trailing: IconButton(
                      onPressed: () {
                        deleteProduct(index);
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(onPressed: addproduct, child: Text("Add Product")),
          ],
        ),
      ),
    );
  }
}
