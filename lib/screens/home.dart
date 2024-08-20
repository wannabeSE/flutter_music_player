import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = Get.width;
    double borderRadius = deviceWidth * 0.1;
    borderRadius = borderRadius.clamp(10, 30);
    double searchPadding = deviceWidth * 0.04;
    searchPadding = searchPadding.clamp(10, 20);
    double contentPadding = deviceWidth * 0.02;
    contentPadding = contentPadding.clamp(10, 15);
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: TColor.gradientBg,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(searchPadding),
                child: SizedBox(
                  height: Get.height * 0.06,
                  child: TextField(
                    //textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search for songs...',
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins'
                      ),
                      suffixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.only(top: contentPadding, left: contentPadding),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                        borderSide: BorderSide.none
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
