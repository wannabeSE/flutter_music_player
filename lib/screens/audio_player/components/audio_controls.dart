import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/getx_controllers/audio_control_controller.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:get/get.dart';

class AudioControls extends StatelessWidget {
  const AudioControls({
    super.key,
    required this.audioHandler
  });
  final JustAudioPlayerHandler audioHandler;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioControlController());
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
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1)
                        ]
                      )
                    ),
                    // audio control buttons
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: IconButton(
                            onPressed: (){
                              controller.shuffleMode.value = !controller.shuffleMode.value;
                              controller.toggleShuffleMode(audioHandler);
                            },
                            icon: Obx(() =>
                              controller.shuffleMode.value
                                  ? _controlButtonStyle(Icons.shuffle_on_rounded, 28)
                                  : _controlButtonStyle(Icons.shuffle_rounded, 28)
                            )
                          ),
                        ),
                        IconButton(
                          onPressed: () async{

                            if(controller.repeatMode.value == AudioServiceRepeatMode.one){
                              await audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
                              audioHandler.skipToPrevious();
                              await audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
                            }else{
                              audioHandler.skipToPrevious();
                            }

                          },
                          icon: _controlButtonStyle(Icons.skip_previous_rounded, 40)
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
                          onPressed: () async{

                            if(controller.repeatMode.value == AudioServiceRepeatMode.one){
                              await audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
                              audioHandler.skipToNext();
                              await audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
                            }else{
                              audioHandler.skipToNext();
                            }

                          },
                          icon: _controlButtonStyle(Icons.skip_next_rounded, 40)
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: IconButton(
                            onPressed: ()async{
                              await controller.toggleRepeatMode(audioHandler);
                            },
                            icon: Obx(() =>
                              _controlButtonStyle(controller.getRepeatModeIcon(), 28)
                            )
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
  Widget _controlButtonStyle(IconData iconData, double iconSize){
    return Icon(
      iconData,
      size: iconSize,
      color: TColor.primary,
    );
  }
}
