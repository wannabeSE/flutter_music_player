import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistController extends GetxController{
  RxList<String> allPlaylists = ['Liked songs'].obs;
  static const String playlistKey = 'playlists';

  @override
  void onInit()async{
    super.onInit();
    await getAllPlaylists();
  }

  Future saveChanges()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(playlistKey, allPlaylists);
    allPlaylists.refresh();
  }
  Future createNewPlaylist(String playlistName)async{
    allPlaylists.add(playlistName);
    saveChanges();
  }

  Future getAllPlaylists()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? loadedPlaylists = prefs.getStringList(playlistKey) ?? [];
    allPlaylists(loadedPlaylists);
  }
}