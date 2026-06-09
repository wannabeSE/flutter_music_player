import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_music_player/getx_controllers/playlist_controller.dart';
import 'package:flutter_music_player/getx_controllers/song_controller.dart';
import 'package:flutter_music_player/services/audio_player_handler.dart';
import 'package:get/get.dart';

/// App-facing coordinator between the UI and the [JustAudioPlayerHandler].
///
/// The UI never talks to the audio handler directly for queue changes; it goes
/// through this service so that the "which list is loaded into the player"
/// bookkeeping ([_activeQueueKey]) lives in exactly one place.
class AudioPlayerService extends GetxService {
  late JustAudioPlayerHandler justAudioPlayerHandler;
  final songController = Get.put(SongController());
  final playlistController = Get.put(PlaylistController());

  /// Identifies the queue currently loaded into the player: `'device_songs'`
  /// for the Music tab, or a playlist key. Lets us detect when a tap is in the
  /// same context (no rebuild) versus a different one (rebuild required).
  String? _activeQueueKey;

  /// Boots the background audio service and creates the singleton handler.
  Future<void> init() async {
    justAudioPlayerHandler = await AudioService.init(
      builder: () => JustAudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.boom.app',
        androidNotificationChannelName: 'Boom',
        androidShowNotificationBadge: true,
        androidNotificationOngoing: true,
      ),
    );
  }

  /// Mirrors the player's current index and playing flag into [SongController]
  /// so the song list's reactive highlight/play-pause icons stay accurate.
  void _syncPlaybackState() {
    final index = justAudioPlayerHandler.audioPlayer.currentIndex ?? 0;
    songController.currentPlayingSongIndex(index);
    songController.isPlaying(justAudioPlayerHandler.audioPlayer.playing);
  }

  /// Loads all device songs into the player queue (used at startup).
  /// Reuses the cached list unless [forceRefresh] is set, avoiding a slow
  /// re-scan of the device's media library on every call.
  Future<void> loadSongs({bool forceRefresh = false}) async {
    try {
      final List<MediaItem> loadedSongs;
      if (!forceRefresh && songController.deviceSongs.isNotEmpty) {
        loadedSongs = songController.deviceSongs;
      } else {
        loadedSongs = await songController.getDeviceSongs();
      }
      await justAudioPlayerHandler.switchPlaylist(loadedSongs);
      _activeQueueKey = 'device_songs';
      _syncPlaybackState();
    } catch (e) {
      debugPrint('Error loading songs $e');
    }
  }

  /// Loads a saved playlist (by [plKey]) into the player queue.
  Future<void> loadNewPlaylistSongs(String plKey) async {
    try {
      final loadedAudios = await playlistController.getPlaylistAudios(plKey);
      await justAudioPlayerHandler.switchPlaylist(loadedAudios);
      _activeQueueKey = plKey;
      _syncPlaybackState();
    } catch (e) {
      debugPrint('Error loading new playlist $e');
    }
  }

  /// Handles an explicit song tap. The player queue is only rebuilt when the
  /// tapped context differs from the currently loaded queue; otherwise playback
  /// is toggled/seeked in place so navigation never disturbs playback.
  Future<void> onSongTapped({
    required bool fromPlaylist,
    required int index,
    required MediaItem item,
  }) async {
    try {
      // The queue this tap belongs to: the open playlist, or the Music tab.
      final desiredKey =
          fromPlaylist ? playlistController.currentPlaylistKey : 'device_songs';
      final sameQueue = _activeQueueKey == desiredKey;
      // True only when re-tapping the exact track already loaded and playing.
      final isCurrent =
          sameQueue && justAudioPlayerHandler.mediaItem.value?.id == item.id;

      // Case 1: same song in the same queue -> just toggle play/pause. This
      // preserves the playback position (no rebuild, no restart).
      if (isCurrent) {
        if (justAudioPlayerHandler.audioPlayer.playing) {
          await justAudioPlayerHandler.pause();
          songController.isPlaying(false);
        } else {
          await justAudioPlayerHandler.play();
          songController.isPlaying(true);
        }
        return;
      }

      // Case 2: the tap is for a different context than what's loaded, so swap
      // the queue to the displayed list. setQueue does not auto-play; the
      // skipToQueueItem below starts the exact track the user tapped.
      if (!sameQueue) {
        final songs = fromPlaylist
            ? playlistController.currentLoadedPlaylist.toList()
            : songController.deviceSongs.toList();
        await justAudioPlayerHandler.setQueue(songs);
        _activeQueueKey = desiredKey;
      }

      // Case 3 (and tail of case 2): play the tapped index in the active queue.
      await justAudioPlayerHandler.skipToQueueItem(index);
      songController.currentPlayingSongIndex(index);
      songController.isPlaying(true);
    } catch (e) {
      debugPrint('Error handling song tap $e');
    }
  }
}
