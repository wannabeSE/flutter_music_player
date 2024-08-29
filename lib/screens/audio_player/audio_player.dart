import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/screens/music_list/music.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioPlayerScreen extends StatelessWidget {
  final SongModel song;
  const AudioPlayerScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    var playerController = Get.find<PlayerController>();
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
                colorFilter:  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  //color: Colors.red
                ),
                child: QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  artworkFit: BoxFit.cover,
                  nullArtworkWidget: const Icon(
                    Icons.music_note,
                    size: 52,
                    color: Colors.white,
                  ),
                ),
              )
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.displayNameWOExt,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Text(
                      song.artist.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                ),
              )
            ),
            //? audio player controls
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.white.withOpacity(0.2)
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('00:00'),
                        Expanded(
                            child: Slider(value: 0.0, onChanged: (v) {})),
                        const Text('04:00')
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //TODO: shuffle button
                        IconButton(
                          icon:
                              controlButtonStyle(Icons.skip_previous_rounded),
                          onPressed: () {},
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
                              )
                            ),
                          ),
                        )
                          ),
                        IconButton(
                          icon: controlButtonStyle(Icons.skip_next_rounded),
                          onPressed: () {},
                        ),
                        // TODO: Repeat Button
                      ],
                    )
                  ],
                ),
              )
            )
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
