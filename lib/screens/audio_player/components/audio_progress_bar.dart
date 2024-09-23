import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';

import '../../../common/ui_color.dart';

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
            thumbColor: TColor.primary,
            progressBarColor: TColor.primary,
            progress: positionSnapshot.data! ,
            baseBarColor: Colors.white,
            barHeight: 2,
            timeLabelTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white70
            ),
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
