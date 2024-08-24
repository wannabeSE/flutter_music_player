import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: AppBar(),
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
