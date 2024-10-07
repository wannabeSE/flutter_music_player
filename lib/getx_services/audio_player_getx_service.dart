import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_music_player/getx_controllers/playlist_controller.dart';
import 'package:flutter_music_player/getx_controllers/song_controller.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:get/get.dart';

class AudioPlayerService extends GetxService {
  late JustAudioPlayerHandler justAudioPlayerHandler;
  final songController = Get.put(SongController());
  final playlistController = Get.put(PlaylistController());
  Future<void> init() async {
    justAudioPlayerHandler = await AudioService.init(
      builder: () => JustAudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.boom.app',
        androidNotificationChannelName: 'Boom',
        androidShowNotificationBadge: true,
        androidNotificationOngoing: true)
    );
  }
  Future<void> loadSongs() async{
    try {
      final loadedSongs = await songController.getDeviceSongs();
        await justAudioPlayerHandler.switchPlaylist(loadedSongs);

    } catch (e) {
      debugPrint('Error loading songs $e');
    }
  }
  Future<void> loadNewPlaylistSongs(String plKey)async{
    try{
      final loadedAudios = await playlistController.getPlaylistAudios(plKey);
      await justAudioPlayerHandler.switchPlaylist(loadedAudios);
    }catch(e){
      debugPrint('Error loading new playlist $e');
    }
  }
  Future<void> playlistSwitcher({String playlistName = 'device_songs'})async{
    try{
      if(playlistName == 'device_songs'){
        await loadSongs();
      }else{
        await loadNewPlaylistSongs(playlistName);
      }
    }catch(e){
      debugPrint('Error switching playlist $e');
    }
  }
}
