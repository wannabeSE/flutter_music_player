import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_music_player/getx_controllers/song_controller.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:get/get.dart';

class AudioPlayerService extends GetxService {
  late JustAudioPlayerHandler justAudioPlayerHandler;
  final songController = Get.put(SongController());

  Future<void> init() async {
    justAudioPlayerHandler = await AudioService.init(
        builder: () => JustAudioPlayerHandler(),
        config: const AudioServiceConfig(
            androidNotificationChannelId: 'com.boom.app',
            androidNotificationChannelName: 'Boom',
            androidShowNotificationBadge: true,
            androidNotificationOngoing: true));
  }

  Future<void> loadSongs() async {
    try {
      final loadedSongs = await songController.getDeviceSongs();
      await justAudioPlayerHandler.initSongs(loadedSongs);
    } catch (e) {
      debugPrint('Error loading songs $e');
    }
  }
}
