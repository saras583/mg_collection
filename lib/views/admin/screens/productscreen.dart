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
  @override
void initState() {
  super.initState();
  fetchProducts();
}
 

  final supabase = Supabase.instance.client;
List products = [];



  final List<String> categories = [

    "Shirt",
    "Watch",
    "Skincare",
    "Pants",
    "Shoes",
    "Jewellery",
  ];

  String selectedCategory = "Shoes";

  File? selectedImage;

  final ImagePicker picker = ImagePicker();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController =
    TextEditingController();

final stockController =
    TextEditingController();

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

  Future<void> addProduct() async {
  try {
    print("ADDING PRODUCT...");

    final response = await supabase
        .from('products')
        .insert({
      "name": nameController.text,
      "price": int.parse(priceController.text),
      "category": selectedCategory,
      "description": descriptionController.text,
      "stock": 0,
      "image_url": "",
    });

    print("PRODUCT ADDED");
    print(response);

    await fetchProducts();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Product Added Successfully"),
      ),
    );
  } catch (e) {
    print("ADD PRODUCT ERROR => $e");
  }
}
Future<void> fetchProducts() async {
  try {
    final response = await supabase
        .from('products')
        .select();
  
    setState(() {
      products = response;
    });
  } catch (e) {
    print(e);
  }
}

  void editProduct(int index, Map product) {

    nameController.text = product["name"];
    priceController.text = product["price"];

    selectedCategory = product["category"]??'shoes';

    if (product["image"] != "") {

      selectedImage = File(product["image"]);
    }

    showDialog(
      context: context,
      builder: (context) {

        return StatefulBuilder(
          builder: (context, setDialogState) {

            return AlertDialog(

              title: const Text("Edit Product"),

              content: SingleChildScrollView(
                child: Column(
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

                    DropdownButtonFormField(

                      value: selectedCategory,

                      items: categories.map((category) {

                        return DropdownMenuItem(

                          value: category,
                          child: Text(category),
                        );

                      }).toList(),

                      onChanged: (value) {

                        setDialogState(() {

                          selectedCategory = value!;
                        });
                      },

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(

                      onTap: () async {

                        final XFile? image =
                            await picker.pickImage(
                          source: ImageSource.gallery,
                        );

                        if (image != null) {

                          setDialogState(() {

                            selectedImage =
                                File(image.path);
                          });
                        }
                      },

                      child: Container(

                        height: 120,
                        width: double.infinity,

                        decoration: BoxDecoration(

                          border: Border.all(),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),

                        child: selectedImage == null

                            ? const Center(
                                child: Text(
                                  "Select Product Image",
                                ),
                              )

                            : Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [

                ElevatedButton(

                 onPressed: () async {
  await supabase
      .from('products')
      .update({
        "name": nameController.text,
        "price": double.parse(priceController.text),
        "category": selectedCategory,
      })
      .eq('id', product['id']);

  await fetchProducts();

  Navigator.pop(context);
},

                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Products"),
      ),

      floatingActionButton: FloatingActionButton(

        onPressed: () {

          showDialog(
            context: context,
            builder: (context) {

              return StatefulBuilder(
                builder: (context, setDialogState) {

                  return AlertDialog(

                    title: const Text("Add Product"),

                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          TextField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(
                              hintText:
                                  "Product Name",
                            ),
                          ),

                          const SizedBox(height: 10),

                          TextField(
                            controller: priceController,
                            decoration:
                                const InputDecoration(
                              hintText: "Price",
                            ),
                          ),

                          const SizedBox(height: 10),

                          DropdownButtonFormField(

                            value: selectedCategory,

                            items:
                                categories.map((category) {

                              return DropdownMenuItem(

                                value: category,
                                child: Text(category),
                              );

                            }).toList(),

                            onChanged: (value) {

                              setDialogState(() {

                                selectedCategory =
                                    value!;
                              });
                            },

                            decoration:
                                const InputDecoration(
                              border:
                                  OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 10),

                          GestureDetector(

                            onTap: () async {

                              final XFile? image =
                                  await picker.pickImage(
                                source:
                                    ImageSource.gallery,
                              );

                              if (image != null) {

                                setDialogState(() {

                                  selectedImage =
                                      File(image.path);
                                });
                              }
                            },

                            child: Container(

                              height: 120,
                              width: double.infinity,

                              decoration: BoxDecoration(

                                border: Border.all(),
                                borderRadius:
                                    BorderRadius.circular(
                                        10),
                              ),

                              child:
                                  selectedImage == null

                                      ? const Center(
                                          child: Text(
                                            "Select Product Image",
                                          ),
                                        )

                                      : Image.file(
                                          selectedImage!,
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    actions: [

                      ElevatedButton(

                        onPressed: () async{

                         await addProduct();

                          Navigator.pop(context);
                        },

                        child: const Text("Save"),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },

        child: const Icon(Icons.add),
      ),

      body: ListView.builder(

        itemCount: products.length,

        itemBuilder: (context, index) {

          final product = products[index];

          return Card(

            child: ListTile(onTap: () {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (context) =>
            ProductDetailsScreen(
          product: product,
        ),
      ),
    );
  },

              leading:

                  

                   const CircleAvatar(
                      child: Icon(Icons.image),
                    ),

              title: Text(product["name"]),

              subtitle: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text("₹${product["price"]}"),

                  Text(
                    product["category"]??'No Category',
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  IconButton(

                    icon: const Icon(Icons.edit),

                    onPressed: () {

                      editProduct(index, product);
                    },
                  ),

                  IconButton(

                    icon: const Icon(Icons.delete),

                    onPressed: () async{
                     await supabase
    .from('products')
    .delete()
    .eq('id', product['id']);

await fetchProducts();
                      
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}