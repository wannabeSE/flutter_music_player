import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/getx_controllers/liked_songs_controller.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:flutter_music_player/screens/audio_player/audio_player_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioTile extends StatelessWidget {
  const AudioTile({
    super.key,
    required this.item,
    required this.audioHandler,
    required this.index
  });
  final JustAudioPlayerHandler audioHandler;
  final MediaItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    //debugPrint(index.toString());
    final LikedSongsController likedSongsController = Get.find();
    return StreamBuilder(
      stream: audioHandler.mediaItem,
      builder: (_, itemSnapshot){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            leading: SizedBox(
              height: 44,
              width: 44,
              child: QueryArtworkWidget(
                id: item.extras?['song_id'],
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Icon(Icons.music_note, color: Colors.white,),
              ),
            ),
            title: SizedBox(
              width: Get.width * 0.3,
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            subtitle: Text(
              item.artist ?? 'unknown artist',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FavButton(
                item: item, 
                likedSongsController: likedSongsController,
                audioPlayerHandler: audioHandler,
              ),
            ),
            shape: Border(
              bottom: BorderSide(
                color: TColor.primaryText35
              )
            ),
            contentPadding: EdgeInsets.zero,
            onTap: ()async{
              //? play/pause logic needs to be implemented
              await audioHandler.skipToQueueItem(index);
              //! autoplay issue if the item index = 0
              // if(itemSnapshot.data! != item){
              //   //print('index from audio tile =$index');
              //   await audioHandler.skipToQueueItem(index);
              // }
              Get.to(
                AudioPlayerScreen(audioHandler: audioHandler,),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 250)
              );
            },
          ),
        );
      }
    );
  }
}

class FavButton extends StatefulWidget {
  const FavButton({
    super.key,
    required this.item,
    required this.likedSongsController, 
    required this.audioPlayerHandler,
  });
  final MediaItem item;
  final LikedSongsController likedSongsController;
  final JustAudioPlayerHandler audioPlayerHandler;
  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {
  @override
  Widget build(BuildContext context) {
    //debugPrint('icon rebuild');
    return IconButton(
      onPressed: ()async{
        await toggleLike();
        setState(() {});
      }, 
      icon: widget.item.extras?['isFav'] ?? false 
          ? _favIcon('assets/icons/fav_filled.svg')
          : _favIcon('assets/icons/favorite.svg')
    );
  }
  Widget _favIcon(String iconPath){
    return SvgPicture.asset(
      iconPath,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)
    );
  }

  Future toggleLike() async{
    widget.item.extras?['isFav'] = !widget.item.extras?['isFav'];
    await widget.likedSongsController.toggleLike(widget.item);
    await widget.audioPlayerHandler.updateQueue(widget.likedSongsController.likedSongs);
  }

}
