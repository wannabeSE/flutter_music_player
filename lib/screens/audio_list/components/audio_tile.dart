import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:flutter_music_player/screens/audio_player/audio_player_screen.dart';
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
    return StreamBuilder(
      stream: audioHandler.mediaItem,
      builder: (_, itemSnapshot){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16)
              ),
              child: QueryArtworkWidget(
                id: item.extras?['song_id'], 
                type: ArtworkType.AUDIO,
                nullArtworkWidget: const Icon(Icons.music_note, color: Colors.white,),
              ),
            ),
            title: Text(
              item.title,
              maxLines: 1,
            ),
            subtitle: Text(item.artist ?? 'unknown artist'),
            shape: Border(
              bottom: BorderSide(
                color: TColor.primaryText35
              )
            ),
            contentPadding: EdgeInsets.zero,
            onTap: (){
              if(itemSnapshot.data! != item){
                audioHandler.skipToQueueItem(index);
              }
              Get.to(AudioPlayerScreen(audioHandler: audioHandler,));
            },
          ),
        );
      }
    );
  }
}
