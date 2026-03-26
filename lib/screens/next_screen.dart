import 'package:flutter/material.dart';
import 'package:mgcollection_app/screens/letstart.dart';


class NextScreen extends StatefulWidget {
  const NextScreen({super.key});

  @override
  State<NextScreen> createState() => _GetstartscreenState();
}

class _GetstartscreenState extends State<NextScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [
      //backgroundimage
      SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset('assets/images/next.jpg',fit: BoxFit.cover,),
        

      )
      ,Container(color: Colors.black.withOpacity(0.2),),
      //content 
      Padding(padding: EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
         Spacer(),
         Text('Follow For \n Lastest Fashion',style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),)
                  ,SizedBox(height: 100,),
                   Row(
                  children: [
                    Container(
                      width: 20,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                     SizedBox(width: 5),
                    Container(
                      width: 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                     SizedBox(width: 5),
                    Container(
                      width: 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ), SizedBox(height: 20),

                /// Button
                Align(
                  
                  alignment: Alignment.centerRight,child: GestureDetector(
    onTap: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>  Letstart(),
        ),
      );
    },
                  child: Container(
                    padding:  EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child:  Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                  )
                ),

                

)],),)
    ],));
  }
}
