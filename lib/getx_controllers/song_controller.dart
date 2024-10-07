import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_music_player/utils/song_model_to_media_item.dart';
import 'package:flutter_music_player/services/permission_handler.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongController extends GetxController {
  RxList<MediaItem> deviceSongs = <MediaItem>[].obs;
  final OnAudioQuery audioQuery = OnAudioQuery();
  RxInt currentPlayingSongIndex = 0.obs;
  RxBool isPlaying = false.obs;

  Future getDeviceSongs() async {
    final List<MediaItem> songs = [];
    try {
      await requestPermission();
      final List songModels = await audioQuery.querySongs();
      for (final SongModel songModel in songModels) {
        if(songModel.isMusic!){
          final MediaItem song = await songModelToMediaItem(songModel);
          songs.add(song);
        }
      }
      deviceSongs.value = songs;
      return songs;
    } catch (e) {
      debugPrint('Error fetching device songs $e');
      deviceSongs([]);
    }
  }
}
