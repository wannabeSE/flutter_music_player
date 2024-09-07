import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:get/get.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // checkPermission(PermissionStatus status)async{
    //   if(status.isDenied){
    //     debugPrint('denied');
    //     await Permission.audio.request();
    //   }else if(status.isGranted){
    //     debugPrint('Granted');
    //     Get.to(const BottomNavbar());
    //   }else{
    //     openAppSettings();
    //   }
    // }
    // Future requestPermission()async{
    //   final androidInfo = await DeviceInfoPlugin().androidInfo;
    //   if(Platform.isAndroid){
    //     //? for android version 12 or below
    //     if(androidInfo.version.sdkInt <= 31){
    //       PermissionStatus permStat = await Permission.storage.request();
    //       checkPermission(permStat);
    //     }
    //     //? for android version 13 or greater
    //     else{
    //       PermissionStatus permissionStatus = await Permission.audio.request();
    //       checkPermission(permissionStatus);
    //     }
    //   }
    // }
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
                  //await requestPermission();
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
