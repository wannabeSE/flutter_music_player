import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/getx_controllers/playlist_controller.dart';
import 'package:flutter_music_player/getx_services/audio_player_getx_service.dart';
import 'package:flutter_music_player/screens/audio_list/components/audio_tile.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PlaylistAudioList extends StatelessWidget {
  const PlaylistAudioList({
    super.key,
    required this.plController,
    required this.audioPlayerService
  });
  final PlaylistController plController;
  final AudioPlayerService audioPlayerService;
  @override
  Widget build(BuildContext context) {
    final List<MediaItem> playlist = plController.currentLoadedPlaylist;
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: AppBar(
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
        body: Obx(() =>
          ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (_, index){
              MediaItem item = playlist[index];
              if(playlist.isEmpty){
                return const Center(
                  child: Text(
                    'No songs added yet!',
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
                index: index,
                flag: false
              );
            }
          )
        ),
      ),
    );
  }
}
