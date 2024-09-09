import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:get/get.dart';

class AudioControlController extends GetxController{
  Rx<AudioServiceRepeatMode> repeatMode = AudioServiceRepeatMode.none.obs;
  RxBool shuffleMode = false.obs;

  //? might convert method return type to void
  Future<void> toggleRepeatMode(JustAudioPlayerHandler audioHandler)async{

    if(repeatMode.value == AudioServiceRepeatMode.none){
      await audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
      repeatMode(AudioServiceRepeatMode.all);
    }else if(repeatMode.value == AudioServiceRepeatMode.all){
      await audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
      repeatMode(AudioServiceRepeatMode.one);
    }else{
      await audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
      repeatMode(AudioServiceRepeatMode.none);
    }

  }

  IconData getRepeatModeIcon(){
    if(repeatMode.value == AudioServiceRepeatMode.all){
      return Icons.repeat_on_rounded;
    }else if(repeatMode.value == AudioServiceRepeatMode.one){
      return Icons.repeat_one_on_rounded;
    }else{
      return Icons.repeat_rounded;
    }
  }

  toggleShuffleMode(JustAudioPlayerHandler audioHandler){
    if(shuffleMode.value){
      audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    }else{
      audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }
}