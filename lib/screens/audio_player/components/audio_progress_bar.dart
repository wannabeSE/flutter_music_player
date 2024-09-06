import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({
    super.key,
    required this.item,
    required this.audioHandler
  });
  final JustAudioPlayerHandler audioHandler;
  final MediaItem item;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AudioService.position,
      builder: (_, positionSnapshot){
        if(positionSnapshot.data != null){
          return ProgressBar(
            thumbGlowRadius: 10,
            progress: positionSnapshot.data! ,
            total: item.duration!,
            onSeek: (position){
              audioHandler.seek(position);
            },
          );
        }
        return ProgressBar(
          progress: Duration.zero, total: item.duration!
        );
      }
    );
  }
}
