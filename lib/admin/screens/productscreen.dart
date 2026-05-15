import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  final productBox = Hive.box('products');

  final nameController = TextEditingController();

  final priceController = TextEditingController();

  final imageController = TextEditingController();

  File? selectedImage;

final ImagePicker picker = ImagePicker();

Future pickImage() async {

  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (image != null) {

    setState(() {

      selectedImage = File(image.path);
    });
  }
}

  void addProduct() {

  productBox.add({

    "name": nameController.text,
    "price": priceController.text,
    "image": imageController.text,
  });

  setState(() {});

  nameController.clear();
  priceController.clear();
  imageController.clear();
}
void editProduct(int index, Map product) {

  nameController.text = product["name"];
  priceController.text = product["price"];
  imageController.text = product["image"];

  showDialog(
    context: context,
    builder: (context) {

      return AlertDialog(

        title: const Text("Edit Product"),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Product Name",
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                hintText: "Price",
              ),
            ),

            const SizedBox(height: 10),

GestureDetector(

  onTap: () {

    pickImage();
  },

  child: Container(

    height: 120,
    width: double.infinity,

    decoration: BoxDecoration(

      border: Border.all(),
      borderRadius: BorderRadius.circular(10),
    ),

    child: selectedImage == null

        ? const Center(
            child: Text("Select Product Image"),
          )

        : Image.file(
            selectedImage!,
            fit: BoxFit.cover,
          ),
  ),
),

            
          ],
        ),

        actions: [

          ElevatedButton(

            onPressed: () {

              productBox.putAt(index, {

                "name": nameController.text,
                "price": priceController.text,
                "image": imageController.text,
              });

              setState(() {});

              nameController.clear();
              priceController.clear();
              imageController.clear();

              Navigator.pop(context);
            },

            child: const Text("Update"),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Products"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {

          showDialog(
            context: context,
            builder: (context) {

              return AlertDialog(

                title: const Text("Add Product"),

                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: "Product Name",
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        hintText: "Price",
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: imageController,
                      decoration: const InputDecoration(
                        hintText: "Image URL",
                      ),
                    ),
                  ],
                ),

                actions: [

                  ElevatedButton(
                    onPressed: () {

                      addProduct();

                      Navigator.pop(context);
                    },

                    child: const Text("Save"),
                  ),
                ],
              );
            },
          );
        },

        child: const Icon(Icons.add),
      ),

      body: ListView.builder(

itemCount: productBox.length,

        itemBuilder: (context, index) {

          final product = productBox.getAt(index);

          return Card(

            child: ListTile(

              leading: CircleAvatar(
backgroundImage: FileImage(
  File(product["image"]),
),              ),

              title: Text(product["name"]),

              subtitle: Text("₹${product["price"]}"),
              

              trailing: IconButton(

  icon: const Icon(Icons.delete),

  onPressed: () {

    setState(() {

      productBox.deleteAt(index);
    });
  },
              ))
          );
        },
      ),
    );
  }
}