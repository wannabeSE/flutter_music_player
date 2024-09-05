import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/screens/audio_player/components/audio_controls.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:flutter_music_player/screens/audio_player/components/test_progress.dart';
import 'package:get/get.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen ({
    super.key,
    required this.audioHandler,
  });
  final JustAudioPlayerHandler audioHandler;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<MediaItem?>(
          stream: audioHandler.mediaItem,
          builder: (context, mediaSnapshot){
            if(mediaSnapshot.data != null){
              MediaItem item = mediaSnapshot.data!;
              return Column(
                children: [
                  Container(
                    height: Get.height * 0.4,
                    width: Get.width * 0.8,
                    color: Colors.amberAccent,
                  ),
                  Text(item.title),
                  TestProgressBar(item: item, audioHandler: audioHandler,),
                  //Controls
                  AudioControls(audioHandler: audioHandler,)
                ],
              );
            }
            return const Center(child: Text('Unable to play'),);
          }
        ),
      ),
    );
  }
}
