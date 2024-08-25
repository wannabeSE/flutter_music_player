import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/dummy_data/song_list.dart';
import 'package:flutter_svg/svg.dart';

import 'components/music_tile.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    double arrowPadding = 8;
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.all(arrowPadding),
              child: SvgPicture.asset(
                'assets/icons/left_arrow.svg',
                colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ListView.builder(
                  itemCount: musics.length,
                  itemBuilder: (context, index) => MusicTile(
                        index: index,
                      )))),
    );
  }
}
