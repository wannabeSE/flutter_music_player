import 'package:flutter/material.dart';

class TColor {
  static Color get primary => const Color(0xffC35BD1);
  static Color get focus => const Color(0xffD9519D);
  static Color get unfocused => const Color(0xff63666E);
  static Color get focusStart => const Color(0xffED8770);

  static Color get secondaryStart => primary;
  static Color get secondaryEnd => const Color(0xff657DDF);

  static Color get org => const Color(0xffE1914B);

  static Color get primaryText => const Color(0xffFFFFFF);
  static Color get primaryText80 => const Color(0xffFFFFFF).withOpacity(0.8);
  static Color get primaryText60 => const Color(0xffFFFFFF).withOpacity(0.6);
  static Color get primaryText35 => const Color(0xffFFFFFF).withOpacity(0.35);
  static Color get primaryText28 => const Color(0xffFFFFFF).withOpacity(0.28);
  static Color get secondaryText => const Color(0xff585A66);


  static List<Color> get primaryG => [ focusStart, focus ];
  static List<Color> get secondaryG => [secondaryStart, secondaryEnd];

  static Color get bg => const Color(0xff6D1A74);
  static Color get darkGray => const Color(0xff383B49);
  static Color get lightGray => const Color(0xffD0D1D4);
  static BoxDecoration get gradientBg =>  BoxDecoration(
    gradient: LinearGradient(
      colors: [
        const Color(0xff6D1A74),
        Colors.black.withOpacity(0.5)
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomLeft
    )
  );
}