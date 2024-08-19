import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/components/bottom_navbar.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: TColor.primaryText,
          displayColor: TColor.primaryText
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: TColor.primary
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: Color(0xff632568),
          labelTextStyle: WidgetStatePropertyAll(TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white
            )
          )
        ),
        useMaterial3: false,
      ),
      home: const BottomNavbar(),
    );
  }
}

