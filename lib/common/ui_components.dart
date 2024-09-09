import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
class Components{
  static AppBar get appbar => AppBar(
    leading: IconButton(
        onPressed: (){
          Get.back();
        },
        icon: SvgPicture.asset(
          'assets/icons/left_arrow.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        )
    ),
  );
}