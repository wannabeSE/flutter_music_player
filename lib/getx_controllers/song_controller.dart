import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_music_player/getx_controllers/liked_songs_controller.dart';
import 'package:flutter_music_player/utils/song_model_to_media_item.dart';
import 'package:flutter_music_player/services/permission_handler.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongController extends GetxController {
  RxList<MediaItem> deviceSongs = <MediaItem>[].obs;
  final List<MediaItem> _songs = [];
  late List<MediaItem> _playlistSongs;
  final OnAudioQuery audioQuery = OnAudioQuery();
  final LikedSongsController likedSongsController = Get.put(LikedSongsController());

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

  Future getLikedPlaylistSongs()async{
    try{
      _playlistSongs = await likedSongsController.getLikedSongs();
      return _playlistSongs;
    }catch(e){
      debugPrint('error loading playlist $e');
    }

  }
}
