import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_infinite_marquee/flutter_infinite_marquee.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_music_player/screens/audio_player/components/audio_controls.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:flutter_music_player/screens/audio_player/components/audio_progress_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen ({
    super.key,
    required this.audioHandler,
  });
  final JustAudioPlayerHandler audioHandler;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: ()async{
                await audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
                await audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
                Get.back();
              },
              icon: SvgPicture.asset(
                'assets/icons/left_arrow.svg',
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              )
          ),
        ),
        body: StreamBuilder<MediaItem?>(
          stream: audioHandler.mediaItem,
          builder: (context, mediaSnapshot){
            if(mediaSnapshot.data != null){
              MediaItem item = mediaSnapshot.data!;
              return Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.only(bottom: 4),
                      child: CoverImage(item: item),
                    ),
                  ),
                  // Audio Information
                  AudioInfo(item: item),
                  //Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                    child: AudioProgressBar(item: item, audioHandler: audioHandler,),
                  ),
                  //Audio Controls
                  Expanded(
                    flex: 2,
                    child: AudioControls(
                      audioHandler: audioHandler,
                    )
                  )
                ],
              );
            }
            return const Center(child: Text('Unable to play'),);
          }
        ),
      ),
    );
  }
}

class AudioInfo extends StatelessWidget {
  const AudioInfo({
    super.key,
    required this.item,
  });

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.title.length > 40 ?
          SizedBox(
            height: Get.height * 0.05,
            width: Get.width * 0.9,
            child: InfiniteMarquee(
              frequency: const Duration(milliseconds: 20),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index){
                return Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20
                  ),
                );
              }
            ),
          ) : SizedBox(
            height: Get.height * 0.05,
            width: Get.width * 0.9,
            child: Text(
              item.title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20
              ),
            ),
          ),
          Text(
            item.artist ?? 'unknown artist',
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey
            ),
          ),
        ],
      )
    );
  }
}

class CoverImage extends StatelessWidget {
  const CoverImage({
    super.key,
    required this.item,
  });

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: item.extras?['song_id'],
      type: ArtworkType.AUDIO,
      artworkWidth: double.infinity,
      artworkHeight: double.infinity,
      artworkFit: BoxFit.contain,
      artworkQuality: FilterQuality.high,
      size: 500,
      quality: 100,
      nullArtworkWidget: CircleAvatar(
        backgroundColor: Colors.black54,
        maxRadius: double.infinity,
        child: Icon(
          Icons.music_note_rounded,
          color: Colors.white,
          size: Get.height * 0.2,
        ),
      ),
    );
  }
}

