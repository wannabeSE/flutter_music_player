import 'package:flutter/material.dart';
import 'package:flutter_music_player/getx_controllers/playlist_controller.dart';
import 'package:flutter_music_player/screens/playlists/playlist_audio_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common/ui_color.dart';
import '../../getx_services/audio_player_getx_service.dart';

class LibraryListScreen extends StatelessWidget {
  const LibraryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayerService = Get.find<AudioPlayerService>();
    final PlaylistController playlistController = Get.find();
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Your Library',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        body: Obx(() =>
        ListView.builder(
          itemCount: playlistController.allPlaylistsName.length,
          itemBuilder: (_, index){
            String plName = playlistController.allPlaylistsName[index];
            return PlaylistTile(
              audioPlayerService: audioPlayerService,
              index: index,
              playlistName: plName,
              playlistController: playlistController,
            );
          }
        )),
        floatingActionButton: CircleAvatar(
          maxRadius: 28,
          backgroundColor: TColor.primary,
          child: IconButton(
            onPressed: (){
              showAdaptiveDialog(
                context: context,
                builder: (_){
                  return PlaylistCreatorBox(
                    controller: playlistController,
                  );
                }
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            )
          ),
        ),
      ),
    );
  }
}

class PlaylistCreatorBox extends StatefulWidget {
  const PlaylistCreatorBox({
    super.key,
    required this.controller,
  });

  final PlaylistController controller;
  @override
  State<PlaylistCreatorBox> createState() => _PlaylistCreatorBoxState();
}

class _PlaylistCreatorBoxState extends State<PlaylistCreatorBox> {
  final TextEditingController _playlistNameController = TextEditingController();
  bool _isLoading = false;
  Future handleSubmit()async{
    setState(() {
      _isLoading = true;
    });
    try{
      if(_playlistNameController.text.isNotEmpty){
        await widget.controller.createNewPlaylist(_playlistNameController.text);
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    }finally{
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: TColor.primary,
      title: const Text(
        'Create new playlist',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600
        ),
      ),
      content: TextField(
        controller: _playlistNameController,
        style: const TextStyle(
          color: Colors.black87
        ),
        decoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          border: OutlineInputBorder()
        ),
      ),
      actions: [
        SizedBox(
          height: Get.height * 0.028,
          child: ElevatedButton(
            onPressed: _isLoading ? null : handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white
            ),
            child: Text(
              'Add',
              style: TextStyle(
                color: TColor.primary
              ),
            )
          ),
        ),
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white
            ),
          )
        )
      ],
    );
  }
}

class PlaylistTile extends StatelessWidget {
  const PlaylistTile({
    super.key,
    required this.audioPlayerService,
    required this.index,
    required this.playlistName,
    required this.playlistController
  });

  final AudioPlayerService audioPlayerService;
  final int index;
  final String playlistName;
  final PlaylistController playlistController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        leading: index == 0
        ? _folderIconBuilder('assets/icons/folder_liked.svg')
        : _folderIconBuilder('assets/icons/folder.svg'),
        title: Text(playlistName),
        shape: const Border(bottom: BorderSide(color: Colors.white60)),
        trailing: index == 0
        ? null
        : InkWell(
          onTap: ()async{
            await playlistController.deletePlaylist(index);
          },
          child: SvgPicture.asset(
            'assets/icons/delete.svg',
            colorFilter: const ColorFilter.mode(
              Colors.white, BlendMode.srcIn
            ),
          ),
        ),
        onTap: ()async{
          await audioPlayerService.playlistSwitcher(
            playlistName: playlistController.allPlaylistKeys[index]
          );
          Get.to(PlaylistAudioList(
            audioPlayerService: audioPlayerService,
            plController: playlistController,
          ));
        },
      ),
    );
  }
  Widget _folderIconBuilder(String iconPath){
    return SvgPicture.asset(
      iconPath,
      height: 32,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }
}
