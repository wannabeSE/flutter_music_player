import 'package:flutter/material.dart';
import 'package:flutter_music_player/screens/audio_player/audio_player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../music.dart';

class MusicTile extends StatelessWidget {
  final SongModel song;
  //final List songList;
  const MusicTile({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final audioController = Get.put(PlayerController());
    return InkWell(
      onTap: () {
        Get.to(AudioPlayerScreen(song: song));
        audioController.playSong(song.uri);
      },
      child: Container(
        width: Get.width * 0.9,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.white38, width: 2))),
        child: Row(
          children: [
            //music cover image
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: QueryArtworkWidget(
                id: song.id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: Get.width * 0.6,
              margin: const EdgeInsets.only(left: 4, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Track title
                  SizedBox(
                    width: 100,
                    child: Text(
                      song.displayNameWOExt,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(
                      song.artist.toString(),
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis, fontSize: 10),
                    ),
                  )
                ],
              ),
            ),
            SvgPicture.asset(
              'assets/icons/favorite.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 20,
            ),
            // const SizedBox(
            //   width: 8,
            // ),
            //! Test IconButton
            // IconButton(
            //   onPressed: (){
            //     audioController.isPlaying.value = !audioController.isPlaying.value;
            //
            //     audioController.isPlaying.value
            //         ? audioController.playSong(songList[index].uri)
            //         : audioController.pauseSong(songList[index].uri);
            //   },
            //   icon: SvgPicture.asset(
            //     'assets/icons/play.svg',
            //     colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            //     height: 16,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
