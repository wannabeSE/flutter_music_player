import 'package:flutter/material.dart';
import 'package:flutter_music_player/screens/music_list/music.dart';
import 'package:flutter_music_player/screens/test_screen.dart';
import 'package:get/get.dart';
import '../screens/home/home.dart';
import 'package:flutter_svg/svg.dart';
class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationController navController = Get.put(NavigationController());
    double iconHeight = 28;
    return Scaffold(
      body: Obx(() => navController.screens[navController.selectedIndex.value]),
      bottomNavigationBar: Obx(() =>
          NavigationBar(
            height: 70,
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
                  'assets/icons/library.svg',
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  height: iconHeight,
                ),
                label: 'Library'
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  'assets/icons/favorite.svg',
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  height: iconHeight,
                ),
                label: 'Favorite'
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
    const MusicListScreen(),
    const TestScreen(),
    //Container(color: Colors.amber,),
    Container(color: Colors.blue,)
  ];
}
