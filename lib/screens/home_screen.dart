import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = ["All", "Women", "Men", "Kids", "watches"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///  (Menu)
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.grid_view, color: Colors.black),
                  ),

                  ///  LOCATION
                  Column(
                    children: [
                      Text(
                        "Store location",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red, size: 16),
                          SizedBox(width: 4),
                          Text(
                            "Mondolibug, Sylhet",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// ICONS
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(Icons.favorite_border, color: Colors.black),
                      ),
                      SizedBox(width: 10),

                      /// CART
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey.shade200,
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.black,
                            ),
                          ),

                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                  "assets/images/getstarted.jpeg",
                                ),
                              ),
                              SizedBox(height: 5),

                              /// CATEGORY
                              Text(
                                categories[index],
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Looking for shoes",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12, 
  mainAxisSpacing: 12, 
  childAspectRatio: 0.7
                ),
                itemCount: 2,

                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(20)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //product image 
                      Expanded(child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        child: Image.asset(
                        'assets/images/black_shirt.jpg' ,
                        fit: BoxFit.cover ,
                        width: double.infinity, 
                        ),

                        
                      )),Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Linen-Blend Shirt in Standard Fit",textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("\$899",textAlign: TextAlign.center,),
            ),

            SizedBox(height: 8),
            
                    ],),
                  );
                },
              ),
            ),
            Container(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),

  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [

      /// LEFT TEXT PART
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [

          Text(
            "BEST CHOICE",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "Nike Air Jordan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "\$849.69",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),

      /// RIGHT IMAGE
      Image.asset(
        "assets/images/air1.jpg", 
        height: 70,
      ),
    ],
  ),
)
          ],
        ),
      ),
    );
  }
}
