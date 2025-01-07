import 'package:flutter/material.dart';
class profilescreen extends StatefulWidget {
  const profilescreen({super.key});

  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(

          ),
      body: Column(
        children: [
          Image.asset('assets/images/ganeshji.png',width: 275,),
          SizedBox(height: 30,),
          Container(
            width: 350,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.21),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.black), // Icon to blue
              title: Text(
                '',
                style: TextStyle(color: Colors.black), // Text color to white
              ),
              // Icon to blue
               // Add functionality if needed
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 350,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.21),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.phone, color: Colors.black), // Icon to blue
              title: Text(
                '',
                style: TextStyle(color: Colors.black), // Text color to white
              ),
              // Icon to blue
              // Add functionality if needed
            ),
          ),
          SizedBox(height: 10,),
          Container(
            width: 350,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.21),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(Icons.pin_drop_outlined, color: Colors.black), // Icon to blue
              title: Text(
                '',
                style: TextStyle(color: Colors.black), // Text color to white
              ),
              // Icon to blue
              // Add functionality if needed
            ),
          ),
          SizedBox(height: 50,),
          Image.asset('assets/images/logo2.png',width: 275,),
        ],
      ),
    ));
  }
}
