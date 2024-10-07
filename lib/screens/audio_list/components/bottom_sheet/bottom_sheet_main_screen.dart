import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui_color.dart';
import '../../../../getx_controllers/playlist_controller.dart';
import '../audio_tile.dart';
import '../dialog_widgets.dart';
class BottomSheetWidgetsMainScreen extends StatelessWidget {
  const BottomSheetWidgetsMainScreen({
    super.key,
    required this.item,
  });

  final MediaItem item;

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
            plController: plController
          )
        ],
      ),
    );
  }
}

class AudioInfoTile extends StatelessWidget {
  const AudioInfoTile({
    super.key,
    required this.item,
  });

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white
          )
        )
      ),
      child: ListTile(
        leading: LeadingImage(
          item: item,
          imgHeight: 40,
          imgWidth: 40
        ),
        title: Text(
          item.title,
          maxLines: 2,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14
          ),
        ),
        subtitle: SubtitleWidgets(
          item: item,
          fSize: 12
        ),
      ),
    );
  }
}

class AddToPlaylistTile extends StatelessWidget {
  const AddToPlaylistTile({
    super.key,
    required this.item,
    required this.playlists,
    required this.plController,
  });

  final MediaItem item;
  final List<String> playlists;
  final PlaylistController plController;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.add_box_rounded,
        color: Colors.white,
      ),
      title: const Text(
        'Add to playlist',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12
        ),
      ),
      onTap: (){
        //popping the BottomSheet then rendering the DialogBox
        Navigator.of(context).pop();
        showAdaptiveDialog(
          context: context,
          builder: (_){
            return DialogWidgets(
              audio: item,
              playlists: playlists,
              plController: plController
            );
          }
        );
      },
    );
  }
}