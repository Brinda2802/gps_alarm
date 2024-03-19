import 'package:flutter/material.dart';

import '../Firstpage.dart';
import '../Map screen page.dart';
import '../exampleMyhomepage.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>MyHomePage()),
          );
        }, child:Text("Swipe to continue"),

        ),
      ),
    );
  }
}
