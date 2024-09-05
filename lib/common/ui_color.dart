import 'package:flutter/material.dart';

class TColor {
  static Color get primary => const Color(0xff6D1A74);

  static Color get primaryText => const Color(0xffFFFFFF);
  static Color get primaryText80 => const Color(0xffFFFFFF).withOpacity(0.8);
  static Color get primaryText60 => const Color(0xffFFFFFF).withOpacity(0.6);
  static Color get primaryText35 => const Color(0xffFFFFFF).withOpacity(0.35);
  static Color get primaryText28 => const Color(0xffFFFFFF).withOpacity(0.28);

  static BoxDecoration get gradientBg =>  BoxDecoration(
    gradient: LinearGradient(
      colors: [
        primary,
        Colors.black.withOpacity(0.5)
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomLeft
    )
  );
}