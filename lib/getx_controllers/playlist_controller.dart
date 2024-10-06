import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_music_player/utils/media_item_helper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistController extends GetxController{
  RxList<String> allPlaylistsName = ['Liked songs'].obs;
  RxList<MediaItem> currentLoadedPlaylist = <MediaItem>[].obs;
  static const String playlistPrefKey = 'playlists';
  static const String playlistKeys = 'pKey';
  List<String> allPlaylistKeys = [];

  @override
  void onInit()async{
    super.onInit();
    await getAllPlaylists();
    await getAllPlaylistKeys();
  }

  Future saveChanges()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final SharedPreferences prefKeys = await SharedPreferences.getInstance();
    await prefs.setStringList(playlistPrefKey, allPlaylistsName);
    await prefKeys.setStringList(playlistKeys, allPlaylistKeys);
    allPlaylistsName.refresh();
  }

  Future createNewPlaylist(String playlistName)async{
    String createdPlaylistKey = playlistName.replaceAll(' ', '_');
    allPlaylistKeys.add(createdPlaylistKey);
    allPlaylistsName.add(playlistName);
    await saveChanges();
  }
  //? might require tweaking
  Future addAudioToPlaylist(String plName, MediaItem item)async{
    String createdKey = plName.replaceAll(' ', '_');
    final SharedPreferences pref = await SharedPreferences.getInstance();
    //String key = allPlaylistKeys.where((k) => plKey == k) as String;
    List<String>? loadedPlaylistAudios = pref.getStringList(createdKey) ?? [];
    final convertedMediaItem = jsonEncode(MediaItemHelper.mediaItemToMap(item));
    loadedPlaylistAudios.add(convertedMediaItem);
    await pref.setStringList(createdKey, loadedPlaylistAudios);
  }

  Future deletePlaylist(int index)async{
    allPlaylistsName.removeAt(index);
    allPlaylistKeys.removeAt(index);
    await saveChanges();
  }

  Future getAllPlaylists()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? loadedPlaylists = prefs.getStringList(playlistPrefKey) ?? [];
    allPlaylistsName(loadedPlaylists);
  }

  Future getAllPlaylistKeys()async{
    final SharedPreferences prefKeys = await SharedPreferences.getInstance();
    List<String>? loadedKeys = prefKeys.getStringList(playlistKeys) ?? ['Liked_songs'];
    allPlaylistKeys = loadedKeys;
  }

  Future getPlaylistAudios(String plKey)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? loadedAudios = prefs.getStringList(plKey) ?? [];
    List<MediaItem> convertedPlaylistAudiosList = loadedAudios
        .map((audio) =>
        MediaItemHelper.mapToMediaItem(jsonDecode(audio))).toList();
    currentLoadedPlaylist(convertedPlaylistAudiosList);
    return currentLoadedPlaylist;
  }
}