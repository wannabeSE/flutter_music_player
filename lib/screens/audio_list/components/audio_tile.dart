import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/getx_controllers/liked_songs_controller.dart';
import 'package:flutter_music_player/getx_services/audio_player_getx_service.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:flutter_music_player/screens/audio_player/audio_player_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../utils/formatter_utility.dart';

class AudioTile extends StatelessWidget {
  const AudioTile({
    super.key,
    required this.item,
    required this.audioPlayerService,
    required this.index,
    required this.flag
  });
  final AudioPlayerService audioPlayerService;
  final MediaItem item;
  final int index;
  final bool flag;
  @override
  Widget build(BuildContext context) {
    final audioHandler = audioPlayerService.justAudioPlayerHandler;
    final LikedSongsController likedSongsController = Get.find();

    Future<void> handleTap()async{
      if(audioPlayerService.songController.currentPlayingSongIndex.value == index &&
          audioPlayerService.songController.isPlaying.value){
        await audioHandler.pause();
        audioPlayerService.songController.isPlaying(false);
      }
      else if(audioPlayerService.songController.currentPlayingSongIndex.value == index &&
          !audioPlayerService.songController.isPlaying.value){
        await audioHandler.play();
        audioPlayerService.songController.isPlaying(true);
      }
      else{
        await audioHandler.skipToQueueItem(index);
        audioPlayerService.songController.isPlaying(true);
        audioPlayerService.songController.currentPlayingSongIndex(index);
      }
      Get.to(
        AudioPlayerScreen(audioHandler: audioHandler,),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 250)
      );
    }
    return StreamBuilder(
      stream: audioHandler.mediaItem,
      builder: (_, itemSnapshot){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            leading: LeadingImage(item: item),
            title: SizedBox(
              width: Get.width * 0.3,
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            subtitle: SubtitleWidgets(item: item),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FavButton(
                item: item, 
                likedSongsController: likedSongsController,
                audioPlayerHandler: audioHandler,
                flag: flag,
              ),
            ),
            shape: Border(
              bottom: BorderSide(
                color: TColor.primaryText35
              )
            ),
            contentPadding: EdgeInsets.zero,
            onTap: ()async{
              await handleTap();
            },
          ),
        );
      }
    );
  }
}

class SubtitleWidgets extends StatelessWidget {
  const SubtitleWidgets({
    super.key,
    required this.item,
  });

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        item.artist!.length > 25 ?
        SizedBox(
          width: Get.width * 0.4,
          child: Text(
            item.artist ?? 'Unknown artist',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12
            ),
          ),
        ) : Text(
          item.artist ?? 'Unknown artist',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 12
          ),
        ),
        SvgPicture.asset(
          'assets/icons/dot.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn
          )
        ),
        Text(
          FormatterUtility.durationFormatter(item.duration ?? Duration.zero),
          style: const TextStyle(
            fontSize: 12
          ),
        )
      ],
    );
  }
}

class LeadingImage extends StatelessWidget {
  const LeadingImage({
    super.key,
    required this.item,
  });

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: 44,
      child: QueryArtworkWidget(
        id: item.extras?['song_id'],
        type: ArtworkType.AUDIO,
        nullArtworkWidget: const CircleAvatar(
          backgroundColor: Colors.black87,
          child: Icon(
            Icons.music_note_rounded,
            color: Colors.white,
          )
        ),
      ),
    );
  }
}

class FavButton extends StatefulWidget {
  const FavButton({
    super.key,
    required this.item,
    required this.likedSongsController, 
    required this.audioPlayerHandler,
    required this.flag
  });
  final MediaItem item;
  final LikedSongsController likedSongsController;
  final JustAudioPlayerHandler audioPlayerHandler;
  final bool flag;
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
    if(widget.flag){
      await widget.audioPlayerHandler.updateQueue(widget.likedSongsController.likedSongs);
    }
  }

}
