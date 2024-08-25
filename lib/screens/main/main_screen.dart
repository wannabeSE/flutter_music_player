import 'package:flutter/material.dart';
import 'package:flutter_music_player/responsive.dart';
import 'package:flutter_music_player/screens/home/home.dart';
//import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Size _size = Get.size;
    return Scaffold(
      body: Responsive(
        mobile: const Home(), 
        tablet: Container(color: Colors.amber,), 
        desktop: Container(color: Colors.blue,)
      ),
    );
  }
}
