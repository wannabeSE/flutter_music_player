import 'package:flutter/material.dart';
import 'package:flutter_music_player/dummy_data/dummy_playlist.dart';
import 'package:flutter_music_player/screens/playlists/liked_songs_playlist_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common/ui_color.dart';
import '../../getx_services/audio_player_getx_service.dart';

class LibraryListScreen extends StatelessWidget {
  const LibraryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayerService = Get.find<AudioPlayerService>();
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: dummyPlaylist.length,
          itemBuilder: (_, index){
            if(index == 0){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/folder_liked.svg',
                    height: 32,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  title: Text(dummyPlaylist[index]),
                  shape: const Border(bottom: BorderSide(color: Colors.white60)),
                  onTap: ()async{
                    await audioPlayerService.playlistSwitcher(playlistName: 'liked_songs');
                    Get.to(LikedSongsPlaylistScreen(audioPlayerService: audioPlayerService));
                  },
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/folder.svg',
                  height: 32,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                title: Text(dummyPlaylist[index]),
                shape: const Border(bottom: BorderSide(color: Colors.white60)),
              ),
            );
          }
        ),
      ),
    );
  }
}
