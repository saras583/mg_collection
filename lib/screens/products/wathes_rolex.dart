import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/bottomnavigationbarScreen.dart';
import 'package:mgcollection_app/screens/theme_controller.dart';


class WathesRolex extends StatelessWidget {
  const WathesRolex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EFEF),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //backbutton
            Align(
              alignment: Alignment.centerLeft,

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (_) => Bottomnavigationbarscreen(controller: ThemeController())),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),

            _buildImage(),
            _buildDetails(),
          ],
        ),
      ),
    );
  }

  // image
  Widget _buildImage() {
    return Container(
      height: 300,
      width: double.infinity,
      child: Image.asset("assets/images/watch.jpg", fit: BoxFit.contain),
    );
  }

  //details
  Widget _buildDetails() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "BEST SELLER",
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ),

            SizedBox(height: 5),

            Text(
              "rolex",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 5),

            Text(
              "\$967.80",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Text(
              "Rolex is a Swiss luxury watchmaker and manufacturer based in Geneva, Switzerland. Founded in 1905 as Wilsdorf and Davis by German businessman Hans Wilsdorf and his eventual brother-in-law Alfred Davis in London,",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 15),

            _buildSizes(),
            SizedBox(height: 15),
            _buildNumbers(),

            Spacer(),

            _buildBottom(),
          ],
        ),
      ),
    );
  }

  //size
  Widget _buildSizes() {
    return Row(children: [_box("S"), _box("M"), _box("XL")]);
  }

  Widget _box(String text) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
    );
  }

  //numbersize
  Widget _buildNumbers() {
    return Row(
      children: [
        _circle("38"),
        _circle("39"),
        _circle("40", selected: true),
        _circle("41"),
      ],
    );
  }

  Widget _circle(String text, {bool selected = false}) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: selected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  //
  Widget _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price", style: TextStyle(color: Colors.grey)),
            Text("\$849.69", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),

        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text("Add to Cart", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
