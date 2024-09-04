import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_music_player/services/song_model_to_media_item.dart';
import 'package:flutter_music_player/services/test_permission_handler.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongController extends GetxController {
  RxList<MediaItem> deviceSongs = <MediaItem>[].obs;
  final List<MediaItem> _songs = [];
  final OnAudioQuery audioQuery = OnAudioQuery();

  Future getDeviceSongs() async {
    try {
      await requestPermission();
      final List songModels = await audioQuery.querySongs();
      for (final SongModel songModel in songModels) {
        final MediaItem song = await songModelToMediaItem(songModel);
        _songs.add(song);
      }
      deviceSongs.value = _songs;
      return _songs;
    } catch (e) {
      debugPrint('Error fetching device songs $e');
      deviceSongs([]);
    }
  }
}
