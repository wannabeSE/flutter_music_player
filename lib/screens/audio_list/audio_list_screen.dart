import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/common/ui_components.dart';
import 'package:flutter_music_player/getx_services/audio_player_getx_service.dart';
import 'package:get/get.dart';
import 'components/audio_tile.dart';

class AudioListScreen extends StatelessWidget {
  const AudioListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    debugPrint('rebuild');
    final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();
    final songList = audioPlayerService.songController.deviceSongs;
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: Components.appbar,
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: songList.length,
          itemBuilder: (_, index) {
            MediaItem item = songList[index];
            return AudioTile(
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

