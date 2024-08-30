import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxInt currentPlayingSongIndex = 0.obs;
  RxString duration = ''.obs;
  RxString position = ''.obs;
  RxDouble maxDuration = 0.0.obs;
  RxDouble currentSliderVal = 0.0.obs;

  updatePosition(){
    //todo: turn duration info into min:sec
    audioPlayer.durationStream.listen((d){
      // print('duration -> ${d.toString().split('.')[0]}');
      duration.value = d.toString().split('.')[0];
      maxDuration.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p){
      position.value = p.toString().split('.')[0];
      currentSliderVal.value = p.inSeconds.toDouble();
    });
  }
  changeDurationToSecToSeek(int sec){
    Duration duration = Duration(seconds: sec);
    audioPlayer.seek(duration);
  }

  playSong(String? audioPath, int index){
    currentPlayingSongIndex.value = index;
    try{
      audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(audioPath!)
        ),
      );
      debugPrint('audio path-> $audioPath');
      debugPrint('index ->>> ${currentPlayingSongIndex.value}');
      audioPlayer.play();
      isPlaying(true);
      //currentPlayingSongIndex.value = index;
      updatePosition();
    }on Exception catch(e){
      debugPrint(e.toString());
    }
  }

}