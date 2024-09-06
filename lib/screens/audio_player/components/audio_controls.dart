import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:get/get.dart';

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
          return ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: SizedBox(
              height: Get.height * 0.4,
              width: double.infinity,
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 15,
                      sigmaY: 20
                    ),
                    child: Container(),
                  ),
                  Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1)
                        ]
                      )
                    ),
                    // audio control buttons
                    child: Row(
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
                          maxRadius: 48,
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
                                  ? const Icon(Icons.pause_rounded, color: Colors.white,)
                                  : const Icon(Icons.play_arrow_rounded), color: Colors.white,
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
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }
    );
  }
}
