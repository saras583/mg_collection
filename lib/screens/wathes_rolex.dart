import 'package:flutter/material.dart';

class WathesRolex extends StatelessWidget {
  const WathesRolex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EFEF),
      body: SafeArea(child: Column(children: [_buildImage(), _buildDetails()])),
    );
  }
  
  _buildImage() {
    return Container(
    height: 300,
    width: double.infinity,
    child: Image.asset(
      "assets/images/black_shirt.jpg",
      fit: BoxFit.contain,
    ),
  );
  }
  
  _buildDetails() {
    Widget _buildDetails() {
  return Expanded(
    child: Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
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
            "Nike Air Jordan",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 5),

          Text(
            "\$967.80",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10),

          Text(
            "Air Jordan is an American brand of basketball shoes athletic, casual, and style clothing produced by Nike.",
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
  }
  
  _buildSizes() {}
  
  _buildNumbers() {}
  
  _buildBottom() {}

  
}
