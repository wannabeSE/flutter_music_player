import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/home.dart';
import 'package:flutter_svg/svg.dart';
class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationController navController = Get.put(NavigationController());
    double iconHeight = Get.height * 0.035;
    return Scaffold(
      body: Obx(() => navController.screens[navController.selectedIndex.value]),
      bottomNavigationBar: Obx(() =>
          NavigationBar(
            height: Get.height * 0.1,
            selectedIndex: navController.selectedIndex.value,
            onDestinationSelected: (index) => navController.selectedIndex.value = index,
            destinations: [
              NavigationDestination(
                  icon: SvgPicture.asset(
                    'assets/icons/home.svg',
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: iconHeight,
                  ),
                  label: 'Home'
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/icons/music.svg',
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  height: iconHeight,
                ),
                label: 'Music',),
              NavigationDestination(
                  icon: SvgPicture.asset(
                    'assets/icons/fav.svg',
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: iconHeight,
                  ),
                  label: 'Favourite'
            ),
          ]),
      ),
    );
  }
}
class NavigationController extends GetxController{
  RxInt selectedIndex = 0.obs;
  final screens = [
    const Home(),
    Container(color: Colors.redAccent,),
    Container(color: Colors.amber,)
  ];
}
