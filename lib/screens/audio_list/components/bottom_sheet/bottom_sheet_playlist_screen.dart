import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/screens/audio_list/components/bottom_sheet/bottom_sheet_main_screen.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:get/get.dart';

import '../../../../common/ui_color.dart';
import '../../../../getx_controllers/playlist_controller.dart';

class BottomSheetWidgetsPlaylistScreen extends StatelessWidget {
  const BottomSheetWidgetsPlaylistScreen({
    super.key,
    required this.item,
    required this.index,
    required this.audioPlayerHandler
  });
  final MediaItem item;
  final int index;
  final JustAudioPlayerHandler audioPlayerHandler;
  @override
  Widget build(BuildContext context) {
    final PlaylistController plController = Get.find();
    final List<String> playlists = plController.allPlaylistsName;
    return Container(
      height: Get.height * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24)
        ),
        color: TColor.primary
      ),
      child: Column(
        children: [
          AudioInfoTile(item: item),
          AddToPlaylistTile(
            item: item,
            playlists: playlists,
            plController: plController,
          ),
          RemoveAudioTile(
            plController: plController,
            index: index,
            audioPlayerHandler: audioPlayerHandler,
          )
        ],
      ),
    );
  }
}

class RemoveAudioTile extends StatefulWidget {
  const RemoveAudioTile({
    super.key,
    required this.plController,
    required this.index,
    required this.audioPlayerHandler
  });

  final PlaylistController plController;
  final int index;
  final JustAudioPlayerHandler audioPlayerHandler;
  @override
  State<RemoveAudioTile> createState() => _RemoveAudioTileState();
}

class _RemoveAudioTileState extends State<RemoveAudioTile> {
  Future handleTap()async{
    List<MediaItem> currentPlaylist = widget.plController.currentLoadedPlaylist;
    try{
      if(widget.audioPlayerHandler.audioPlayer.playing
          && widget.audioPlayerHandler.audioPlayer.currentIndex == widget.index){
        debugPrint('cannot remove currently playing song');
      }else{
        await widget.plController.removeAudioFromPlaylist(widget.index);
        await widget.audioPlayerHandler.modQueue(widget.index,currentPlaylist);
      }
    }finally{
      if(mounted) Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.delete_rounded,
        color: Colors.white,
      ),
      title: const Text(
        'Remove from playlist',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12
        ),
      ),
      onTap: ()async{
        await handleTap();
      },
    );
  }
}