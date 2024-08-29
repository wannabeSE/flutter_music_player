import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'components/music_tile.dart';

class MusicListScreen extends StatelessWidget {
  const MusicListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double arrowPadding = 8;
    final audioQueryController = Get.put(PlayerController());
    return Container(
      decoration: TColor.gradientBg,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.all(arrowPadding),
            child: SvgPicture.asset(
              'assets/icons/left_arrow.svg',
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FutureBuilder(
            future: audioQueryController.audioQuery.querySongs(
              ignoreCase: false,
              orderType: OrderType.ASC_OR_SMALLER,
              sortType: null,
              uriType: UriType.INTERNAL //TODO: change it to external for physical devices
            ),
            builder: (BuildContext ctx, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return const Center(child: Text('No Songs Found'));
              } else {
                return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) =>
                MusicTile(
                  song: snapshot.data![index],
                  )
                );
              }
            }
          ),
        ),
      ),
    );
  }
}
class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
  playSong(String? audioPath){
    try{
      audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(audioPath!)
        ),
      );
      audioPlayer.play();
      isPlaying(true);
    }on Exception catch(e){
      debugPrint(e.toString());
    }
  }
  // pauseSong(String? audioPath){
  //   try{
  //     audioPlayer.setAudioSource(
  //       AudioSource.uri(Uri.parse(audioPath!)
  //       ),
  //     );
  //     audioPlayer.pause();
  //   }on Exception catch(e){
  //     debugPrint(e.toString());
  //   }
  // }
}