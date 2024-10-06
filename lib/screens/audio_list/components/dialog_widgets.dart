import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui_color.dart';
import '../../../getx_controllers/playlist_controller.dart';
import '../../audio_library/library_list_screen.dart';
class DialogWidgets extends StatelessWidget {
  const DialogWidgets({
    super.key,
    required this.playlists,
    required this.plController,
    required this.audio
  });

  final List playlists;
  final PlaylistController plController;
  final MediaItem audio;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TColor.primary,
      title: const DialogTitleWidget(),
      content: DialogContents(
        playlists: playlists,
        playlistController: plController,
        audio: audio,
      ),
      actions: [
        DialogActionButton(plController: plController)
      ],
    );
  }
}

class DialogActionButton extends StatelessWidget {
  const DialogActionButton({
    super.key,
    required this.plController,
  });

  final PlaylistController plController;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        showAdaptiveDialog(
          context: context,
          builder: (_){
            return PlaylistCreatorBox(controller: plController);
          }
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
          Text(
            'Create new playlist',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white
            ),
          )
        ],
      )
    );
  }
}

class DialogContents extends StatelessWidget {
  const DialogContents({
    super.key,
    required this.playlists,
    required this.playlistController,
    required this.audio
  });

  final List playlists;
  final PlaylistController playlistController;
  final MediaItem audio;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.2,
      width: Get.width * 0.8,
      child: Obx(() =>
        ListView.builder(
          itemCount: playlists.length,
          itemBuilder: (_, i){
            return DialogBoxPlaylistTile(
              playlistName: playlists[i],
              playlistController: playlistController,
              audio: audio
            );
          }
        )
      ),
    );
  }
}

class DialogBoxPlaylistTile extends StatefulWidget {
  const DialogBoxPlaylistTile({
    super.key,
    required this.playlistName,
    required this.playlistController,
    required this.audio,
  });

  final String playlistName;
  final PlaylistController playlistController;
  final MediaItem audio;

  @override
  State<DialogBoxPlaylistTile> createState() => _DialogBoxPlaylistTileState();
}

class _DialogBoxPlaylistTileState extends State<DialogBoxPlaylistTile> {
  Future handleTap(String plName, MediaItem item)async{
    try{
      await widget.playlistController.addAudioToPlaylist(plName, item);
    }finally{
      if(mounted) Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        widget.playlistName,
        style: const TextStyle(
          fontSize: 14
        ),
      ),
      onTap:()async{
        await handleTap(widget.playlistName, widget.audio);
      }
    );
  }
}

class DialogTitleWidget extends StatelessWidget {
  const DialogTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white70
          )
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text(
              'Add to playlist',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
          IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 32,
            )
          )
        ],
      ),
    );
  }
}