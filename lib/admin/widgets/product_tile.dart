import 'package:flutter/material.dart';
import '../products/edit_product.dart';

class ProductTile extends StatelessWidget {
  final String name;
  final String price;

  const ProductTile({super.key, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        color: Colors.grey[200],
        child: const Icon(Icons.checkroom),
      ),
      title: Text(name),
      subtitle: Text(price),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProductScreen()));
        },
      ),
    );
  }
}
