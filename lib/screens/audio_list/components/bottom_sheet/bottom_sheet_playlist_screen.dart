import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/screens/audio_list/components/bottom_sheet/bottom_sheet_main_screen.dart';
import 'package:get/get.dart';

import '../../../../common/ui_color.dart';
import '../../../../getx_controllers/playlist_controller.dart';

class BottomSheetWidgetsPlaylistScreen extends StatelessWidget {
  const BottomSheetWidgetsPlaylistScreen({
    super.key,
    required this.item,
    required this.index
  });
  final MediaItem item;
  final int index;
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
          ListTile(
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
            onTap: (){
              plController.removeAudioFromPlaylist(index);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}