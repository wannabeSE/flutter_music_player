import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/components/bottom_navbar.dart';
import 'package:flutter_music_player/getx_services/audio_player_getx_service.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Get.put(AudioPlayerService()).init();
  await Get.put(AudioPlayerService()).loadSongs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent
        ),
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Poppins',
          bodyColor: TColor.primaryText,
          displayColor: TColor.primaryText,
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: TColor.primary
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: TColor.primary,
          labelTextStyle: const WidgetStatePropertyAll(TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white
            )
          )
        ),
        useMaterial3: false,
      ),
      home: const BottomNavbar(), //?test splash screen
    );
  }
}

