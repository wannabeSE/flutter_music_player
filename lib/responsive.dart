import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  const Responsive({super.key,
      required this.mobile,
      required this.tablet,
      required this.desktop});
  static bool isMobile(BuildContext context) => Get.width < 650;
  static bool isTablet(BuildContext context) =>
      Get.width >= 650 && Get.width < 1100;
  static bool isDesktop(BuildContext context) => Get.width >= 1100;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth >= 1100) {
        return mobile;
      } else if (constraint.maxWidth >= 650) {
        return tablet;
      } else {
        return mobile;
      }
    });
  }
}
