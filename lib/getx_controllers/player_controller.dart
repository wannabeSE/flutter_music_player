import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
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
  playSong(String? audioPath){
    try{
      audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(audioPath!)
        ),
      );
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    }on Exception catch(e){
      debugPrint(e.toString());
    }
  }

}