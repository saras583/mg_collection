import 'package:flutter/material.dart';
import 'package:mgcollection_app/views/user/screens/orderstatusScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Orderbagscreen extends StatelessWidget {
  const Orderbagscreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      appBar: AppBar(

        centerTitle: true,

        title: const Text(
          "My Orders",
        ),
      ),

      body: FutureBuilder(

  future: Supabase.instance.client
      .from('orders')
      .select()
      .eq(
        'user_id',
        Supabase.instance.client.auth.currentUser!.id,
      )
      .order(
        'created_at',
        ascending: false,
      ),

  builder: (context, snapshot) {

    if (!snapshot.hasData) {

      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final orders =
        List<Map<String, dynamic>>.from(
      snapshot.data as List,
    );

    if (orders.isEmpty) {

      return const Center(
        child: Text(
          "No Orders Yet",
        ),
      );
    }

    return ListView.builder(

      itemCount: orders.length,

      itemBuilder: (context, index) {

        final item = orders[index];

        return ListTile(

          title: Text(
            item['product_name'] ?? '',
            
          ),

          subtitle: Text(
            item['status'] ?? 'Pending',
          ),

          trailing: Text(
            "₹${item['price']}",
          ),

          onTap: () {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (_) =>
                    OrderStatusScreen(
                  order: item,
                ),
              ),
            );
          },
        );
      },
    );
  },
),
    );
  }
}