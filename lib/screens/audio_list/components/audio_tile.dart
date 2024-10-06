import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/getx_controllers/playlist_controller.dart';
import 'package:flutter_music_player/getx_services/audio_player_getx_service.dart';
import 'package:flutter_music_player/screens/audio_player/audio_player_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../utils/formatter_utility.dart';
import 'dialog_widgets.dart';

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

    Future<void> handleTap()async{
      try{
        if(audioPlayerService.songController.currentPlayingSongIndex.value == index){
          if(audioPlayerService.songController.isPlaying.value){
            await audioHandler.pause();
            audioPlayerService.songController.isPlaying(false);
          }else{
            await audioHandler.play();
            audioPlayerService.songController.isPlaying(true);
          }
        }else{
          await audioHandler.skipToQueueItem(index);
          audioPlayerService.songController.isPlaying(true);
          audioPlayerService.songController.currentPlayingSongIndex(index);
        }
        await Get.to(
          AudioPlayerScreen(audioHandler: audioHandler,),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 250)
        );
      }catch(e){
        debugPrint('Error in handleTap() $e');
      }
    }
    return StreamBuilder(
      stream: audioHandler.mediaItem,
      builder: (_, itemSnapshot){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            leading: LeadingImage(
              item: item,
              imgHeight: 44,
              imgWidth: 44,
            ),
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
            subtitle: SubtitleWidgets(
              item: item,
              fSize: 12,
            ),
            trailing: InkWell(
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_){
                    return BottomSheetWidgets(item: item);
                  }
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                child: SvgPicture.asset(
                  'assets/icons/menu_vert.svg',
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                ),
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

class BottomSheetWidgets extends StatelessWidget {
  const BottomSheetWidgets({
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
          Container(
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
          ),
          ListTile(
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
          )
        ],
      ),
    );
  }
}



class SubtitleWidgets extends StatelessWidget {
  const SubtitleWidgets({
    super.key,
    required this.item,
    required this.fSize
  });

  final MediaItem item;
  final double fSize;
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
            style: TextStyle(
              fontSize: fSize
            ),
          ),
        ) : Text(
          item.artist ?? 'Unknown artist',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: fSize
          ),
        ),
        SvgPicture.asset(
          'assets/icons/dot.svg',
          colorFilter: const ColorFilter.mode(
            Colors.white, BlendMode.srcIn
          )
        ),
        Text(
          FormatterUtility.durationFormatter(item.duration ?? Duration.zero),
          style: TextStyle(
            fontSize: fSize
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
    required this.imgHeight,
    required this.imgWidth,
  });

  final MediaItem item;
  final double imgHeight;
  final double imgWidth;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: imgHeight,
      width: imgWidth,
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

