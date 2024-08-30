import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/getx_controllers/player_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioPlayerScreen extends StatelessWidget {
  final List songList;
  const AudioPlayerScreen({
    super.key,
    required this.songList,
  });

  @override
  Widget build(BuildContext context) {
    PlayerController playerController = Get.find<PlayerController>();
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                'assets/icons/left_arrow.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Obx(() => Expanded(
                flex: 3,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  //? cover image
                  child: QueryArtworkWidget(
                    id: songList[playerController.currentPlayingSongIndex.value]
                        .id,
                    type: ArtworkType.AUDIO,
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: const Icon(
                      Icons.music_note,
                      size: 52,
                      color: Colors.white,
                    ),
                  ),
                ))),
            Obx(() => Expanded(
                flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        songList[playerController.currentPlayingSongIndex.value]
                            .displayNameWOExt,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis),
                      ),
                      //? artist name
                      Text(
                        songList[playerController.currentPlayingSongIndex.value]
                            .artist
                            .toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ))),

            //? audio player controls

            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      color: Colors.white.withOpacity(0.2)),
                  child: Column(
                    children: [
                      //? slider and time
                      Obx(() => Row(
                            children: [
                              Text(playerController.position.value),
                              Expanded(
                                  child: Slider(
                                      thumbColor: const Color(0xff6D1A74),
                                      activeColor: const Color(0xff6D1A74),
                                      max: playerController.maxDuration
                                          .toDouble(),
                                      min: const Duration(seconds: 0)
                                          .inSeconds
                                          .toDouble(),
                                      value: playerController
                                          .currentSliderVal.value,
                                      onChanged: (v) {
                                        playerController
                                            .changeDurationToSecToSeek(
                                                v.toInt());
                                        v = v;
                                      })),
                              Text(playerController.duration.value)
                            ],
                          )),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //TODO: shuffle button
                          //? previous button
                          IconButton(
                            icon:
                                controlButtonStyle(Icons.skip_previous_rounded),
                            onPressed: () {
                              playerController.playSong(
                                  songList[playerController
                                              .currentPlayingSongIndex.value -
                                          1]
                                      .uri,
                                  playerController
                                          .currentPlayingSongIndex.value -
                                      1);
                            },
                          ),
                          //? play/ pause button
                          Obx(() => CircleAvatar(
                                radius: 36,
                                backgroundColor: const Color(0xff6D1A74),
                                child: Transform.scale(
                                  scale: 2.8,
                                  child: IconButton(
                                      onPressed: () {
                                        if (playerController.isPlaying.value) {
                                          playerController.audioPlayer.pause();
                                          playerController.isPlaying(false);
                                        } else {
                                          playerController.audioPlayer.play();
                                          playerController.isPlaying(true);
                                        }
                                      },
                                      icon: playerController.isPlaying.value
                                          ? const Icon(Icons.pause_rounded,
                                              color: Colors.white)
                                          : const Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.white,
                                            )),
                                ),
                              )),
                          //? next button
                          IconButton(
                            icon: controlButtonStyle(Icons.skip_next_rounded),
                            onPressed: () {
                              playerController.playSong(
                                  songList[playerController
                                              .currentPlayingSongIndex.value +
                                          1]
                                      .uri,
                                  playerController
                                          .currentPlayingSongIndex.value +
                                      1);
                            },
                          ),
                          // TODO: Repeat Button
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

Widget controlButtonStyle(IconData iconName) {
  return Icon(
    iconName,
    size: 40,
    color: const Color(0xff6D1A74),
  );
}
