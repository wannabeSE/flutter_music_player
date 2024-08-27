import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/components/bottom_navbar.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future checkPermissions()async{
      PermissionStatus permissionStatus = await Permission.audio.request();
      if(permissionStatus.isDenied){
        debugPrint('denied');
        await Permission.audio.request();
      }else if(permissionStatus.isGranted){
        debugPrint('Granted');
        Get.to(const BottomNavbar());
      }else{
        openAppSettings();
      }
    }
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset('assets/icons/logo.png'),
            const Spacer(),
            SizedBox(
              height: Get.height * 0.06,
              width: Get.width * 0.8,
              child: ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  backgroundColor: Colors.white
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Color(0xff6D1A74),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            TextButton(
                onPressed: ()async{
                  await checkPermissions();
                },
                child: const Text(
                  'Device files only',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                  ),
                )
            )
          ],
        )
      ),
    );
  }
}
