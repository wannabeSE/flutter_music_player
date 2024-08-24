import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: const _CustomAppbar(),
        body: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraint){
              return const Column(
                children: [
                  Text('Hello')
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
class _CustomAppbar extends StatelessWidget implements PreferredSizeWidget{
  const _CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = Get.width;
    double contentPadding = deviceWidth * 0.02;
    contentPadding = contentPadding.clamp(10, 15);
    double borderRadius = deviceWidth * 0.1;
    borderRadius = borderRadius.clamp(10, 30);
    double generalPadding = deviceWidth * 0.04;
    generalPadding = generalPadding.clamp(10, 14);
    return AppBar(
      elevation: 0,
      leading: Expanded(
        //width: Get.width * 0.7,
        child: Row(
          children: [
            CircleAvatar(backgroundColor: Colors.blue,),
            Text('Hi, Samir')
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Get.height * 0.15);
}
