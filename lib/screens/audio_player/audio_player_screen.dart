import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/common/ui_components.dart';
import 'package:flutter_music_player/screens/audio_player/components/audio_controls.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:flutter_music_player/screens/audio_player/components/audio_progress_bar.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

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
        appBar: Components.appbar,
        body: StreamBuilder<MediaItem?>(
          stream: audioHandler.mediaItem,
          builder: (context, mediaSnapshot){
            if(mediaSnapshot.data != null){
              MediaItem item = mediaSnapshot.data!;
              return Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.4,
                    width: Get.width * 0.8,
                    child: QueryArtworkWidget(
                      id: item.extras?['song_id'],
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(Icons.music_note, color: Colors.white,),
                    ),
                  ),
                  // Audio Information
                  Text(item.title),
                  //Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: AudioProgressBar(item: item, audioHandler: audioHandler,),
                  ),
                  //Audio Controls
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
