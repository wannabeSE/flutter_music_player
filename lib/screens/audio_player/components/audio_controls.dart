import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
class AudioControls extends StatelessWidget {
  const AudioControls({super.key, required this.audioHandler});
  final JustAudioPlayerHandler audioHandler;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: audioHandler.playbackState.stream,
      builder: (_, snapshot) {
        if(snapshot.data != null){
          bool playing = snapshot.data!.playing;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    audioHandler.skipToPrevious();
                  },
                  icon: Icon(
                    Icons.skip_previous_rounded,
                    size: 40,
                    color: TColor.primary,
                  )
              ),
              CircleAvatar(
                maxRadius: 32,
                backgroundColor: TColor.primary,
                child: Transform.scale(
                  scale: 2.5,
                  child: IconButton(
                      onPressed: () {
                        if(playing){
                          audioHandler.pause();
                        }else {
                          audioHandler.play();
                        }
                      },
                      icon: playing
                          ? const Icon(Icons.pause_rounded)
                          : const Icon(Icons.play_arrow_rounded)
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    audioHandler.skipToNext();
                  },
                  icon: Icon(
                    Icons.skip_next_rounded,
                    color: TColor.primary,
                    size: 40,
                  )
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      }
    );
  }
}
