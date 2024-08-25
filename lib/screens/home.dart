import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/responsive.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: TColor.gradientBg,
      child: const Scaffold(
        appBar: _CustomAppbar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomAppbar extends StatelessWidget implements PreferredSizeWidget{
  const _CustomAppbar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //elevation: 0,
      backgroundColor: Colors.transparent,
      leadingWidth: double.infinity,
      leading: Row(
        children: [
          Container(
            height: 80,
            padding: const EdgeInsets.all(4),
            child: const CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.orange,
            ),
          ),
          Text(
            'Hi, Samir',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Responsive.isMobile(context) ? 12 : 18
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: (){}, 
          icon: Icon(
            Icons.search_rounded,
            size: Responsive.isMobile(context) ? 24 : 32,
          )
        )
      ],
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kIsWeb ? 40 : Get.height * 0.1);
}
