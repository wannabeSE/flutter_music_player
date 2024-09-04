import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/getx_services/audio_player_getx_service.dart';
import 'package:flutter_music_player/test_screen/test_components/test_music_tile.dart';
import 'package:get/get.dart';

class TestMusicScreen extends StatelessWidget {
  const TestMusicScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();
    final songList = audioPlayerService.songController.deviceSongs;
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: songList.length,
          itemBuilder: (_, index) {
            MediaItem item = songList[index];
            return TestMusicTile(
              index: index,
              item: item,
              audioHandler: audioPlayerService.justAudioPlayerHandler
            );
          }
        ),
      ),
    );
  }
}

