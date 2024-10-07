import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_music_player/utils/media_item_helper.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistController extends GetxController{
  RxList<String> allPlaylistsName = <String>['Liked songs'].obs;
  RxList<MediaItem> currentLoadedPlaylist = <MediaItem>[].obs;
  static const String playlistPrefKey = 'playlists';
  static const String playlistKeys = 'pKey';
  List<String> allPlaylistKeys = [];
  String currentPlaylistKey = '';

  @override
  void onInit()async{
    super.onInit();
    await createLikedPlaylist();
    await getAllPlaylists();
    await getAllPlaylistKeys();
  }
  Future createLikedPlaylist()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? allCreatedPlaylist = prefs.getStringList(playlistPrefKey) ?? [];
    if(allCreatedPlaylist.isEmpty){
      await prefs.setStringList(playlistPrefKey, ['Liked songs']);
      await prefs.setStringList(playlistKeys, ['Liked_songs']);
    }else{
      return;
    }
  }
  Future savePlaylistChanges()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(playlistPrefKey, allPlaylistsName);
    await prefs.setStringList(playlistKeys, allPlaylistKeys);
    allPlaylistsName.refresh();
  }
  Future<void> updatePlaylist(String playlistKey, List<MediaItem> updatedAudioList)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> convertedAudios = updatedAudioList.map((audio) => jsonEncode(
        MediaItemHelper.mediaItemToMap(audio)))
        .toList();
    await prefs.setStringList(playlistKey, convertedAudios);
  }
  Future<bool> alreadyAdded(String playlistKey,MediaItem item)async{
    playlistKey = playlistKey.replaceAll(' ', '_');
    bool isPresent = false;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final loadedPlaylist = pref.getStringList(playlistKey) ?? [];
    final convertedMediaItemList = loadedPlaylist.map((media) =>
        MediaItemHelper.mapToMediaItem(jsonDecode(media)))
        .toList();
    isPresent = convertedMediaItemList.any((m) => m.id == item.id);
    return isPresent;
  }
  Future createNewPlaylist(String playlistName)async{
    String createdPlaylistKey = playlistName.replaceAll(' ', '_');
    allPlaylistKeys.add(createdPlaylistKey);
    allPlaylistsName.add(playlistName);
    await savePlaylistChanges();
  }
  Future addAudioToPlaylist(String playlistKey, MediaItem item)async{
    playlistKey = playlistKey.replaceAll(' ', '_');
    final SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? loadedPlaylistAudios = pref.getStringList(playlistKey) ?? [];
    final convertedMediaItem = jsonEncode(MediaItemHelper.mediaItemToMap(item));
    loadedPlaylistAudios.add(convertedMediaItem);
    await pref.setStringList(playlistKey, loadedPlaylistAudios);
  }
  Future<void> removeAudioFromPlaylist(int index)async{
    currentLoadedPlaylist.removeAt(index);
    updatePlaylist(currentPlaylistKey, currentLoadedPlaylist);
  }

  Future deletePlaylist(int index)async{
    allPlaylistsName.removeAt(index);
    allPlaylistKeys.removeAt(index);
    await savePlaylistChanges();
  }

  Future getAllPlaylists()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? loadedPlaylists = prefs.getStringList(playlistPrefKey) ?? [];
    allPlaylistsName(loadedPlaylists);
  }

  Future getAllPlaylistKeys()async{
    final SharedPreferences prefKeys = await SharedPreferences.getInstance();
    List<String>? loadedKeys = prefKeys.getStringList(playlistKeys) ?? [];
    allPlaylistKeys = loadedKeys;
  }

  Future getPlaylistAudios(String plKey)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? loadedAudios = prefs.getStringList(plKey) ?? [];
    List<MediaItem> convertedPlaylistAudiosList = loadedAudios
        .map((audio) =>
        MediaItemHelper.mapToMediaItem(jsonDecode(audio))).toList();
    currentLoadedPlaylist(convertedPlaylistAudiosList);
    currentPlaylistKey = plKey;
    return currentLoadedPlaylist;
  }
}