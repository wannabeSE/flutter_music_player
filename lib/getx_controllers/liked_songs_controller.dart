import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/media_item_helper.dart';

class LikedSongsController extends GetxController{
  RxList<MediaItem> likedSongs = <MediaItem>[].obs;
  static const String likedSongKey = 'liked_songs';

  @override
  void onInit()async{
    super.onInit();
    await getLikedSongs();
  }
  Future<void> toggleLike(MediaItem item)async{
    if(await isLiked(item)){
      await unlikeSong(item);
    }else{
      await addLikedSong(item);
    }
    likedSongs.refresh();
  }

  Future saveLikedSongs()async{
    final prefs = await SharedPreferences.getInstance();
    final likedAudios = likedSongs
        .map((audio) => jsonEncode(
        MediaItemHelper.mediaItemToMap(audio)))
        .toList();
    await prefs.setStringList(likedSongKey, likedAudios);
  }

  Future<bool> isLiked(MediaItem item)async{

    if(likedSongs.any((i) => i.id == item.id)) return true;
    return false;
  }

  Future addLikedSong(MediaItem item)async{
    if(!likedSongs.any((i) => i.id == item.id)){
      likedSongs.add(item);
      saveLikedSongs();
    }
  }

  Future<void> unlikeSong(MediaItem item) async {
    likedSongs.removeWhere((i) => i.id == item.id);
    saveLikedSongs();
  }

  Future<List<MediaItem>> getLikedSongs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? loadedLikedSongs = prefs.getStringList(likedSongKey) ?? [];

    List<MediaItem> convertedLikedSongs = loadedLikedSongs
        .map((mediaItemJson) =>
        MediaItemHelper.mapToMediaItem(jsonDecode(mediaItemJson)))
        .toList();
    likedSongs(convertedLikedSongs);
    return likedSongs;
  }
}