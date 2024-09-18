import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/getx_controllers/liked_songs_controller.dart';
import 'package:flutter_music_player/getx_services/audio_player_getx_service.dart';
import 'package:flutter_music_player/screens/audio_list/components/audio_tile.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../common/ui_color.dart';

class LikedSongsPlaylistScreen extends StatelessWidget {
  const LikedSongsPlaylistScreen({
    super.key,
    required this.audioPlayerService
  });
  final AudioPlayerService audioPlayerService;
  @override
  Widget build(BuildContext context) {
    final LikedSongsController likedSongsController = Get.find();
    final songList = likedSongsController.likedSongs;
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'L I K E D  S O N G S',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),
          ),
          leading: IconButton(
            onPressed: ()async{
              await audioPlayerService.playlistSwitcher();
              Get.back();
            },
            icon: SvgPicture.asset(
              'assets/icons/left_arrow.svg',
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            )
          )
        ),
        body: Obx(() => ListView.builder(
          itemCount: songList.length,
          itemBuilder: (_, index){
            MediaItem item = songList[index];
            if(songList.isEmpty){
              return const Center(
                child: Text(
                  'No liked songs yet',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20
                  ),
                ),
              );
            }
            return AudioTile(
              item: item,
              audioPlayerService: audioPlayerService,
              index: index
            );
          }
        )),
      ),
    );
  }
}

