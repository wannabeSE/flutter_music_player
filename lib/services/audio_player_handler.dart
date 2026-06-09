import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// Bridges `just_audio` (actual playback) and `audio_service` (system media
/// session, notification, lock-screen controls).
///
/// `BaseAudioHandler` is what the OS talks to; this class translates those
/// requests into `AudioPlayer` calls and pushes the player's state back out so
/// the notification and the in-app UI stay in sync.
class JustAudioPlayerHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  /// Listeners are wired up once at construction so that player events are
  /// broadcast for the entire lifetime of the handler (the handler is a
  /// long-lived singleton created via `AudioService.init`).
  JustAudioPlayerHandler() {
    _setupListeners();
  }

  final AudioPlayer audioPlayer = AudioPlayer();
  // Guards against re-subscribing to the player streams more than once, which
  // would otherwise duplicate state broadcasts and "completed -> skipToNext".
  bool _listenersInitialized = false;

  /// Wraps a [MediaItem] into an audio source `just_audio` can play. The song's
  /// `id` holds the file URI, so it is parsed directly into the source.
  UriAudioSource _createAudioSource(MediaItem song) {
    return ProgressiveAudioSource(Uri.parse(song.id));
  }

  /// Subscribes (exactly once) to the three player streams that keep external
  /// state in sync:
  /// - playback events -> rebroadcast as an `audio_service` PlaybackState.
  /// - current index -> publish the matching [MediaItem] as the "now playing".
  /// - processing state -> auto-advance to the next track when one completes.
  void _setupListeners() {
    if (_listenersInitialized) return;
    _listenersInitialized = true;

    audioPlayer.playbackEventStream.listen(_broadcastState);
    audioPlayer.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      mediaItem.add(playlist[index]);
    });
    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) skipToNext();
    });
  }

  /// Returns the `id` of the track currently playing, or null if the index is
  /// out of range. Used to decide whether a track can survive a queue rebuild.
  String? _currentMediaId() {
    final index = audioPlayer.currentIndex;
    final playlist = queue.value;
    if (index == null || index < 0 || index >= playlist.length) return null;
    return playlist[index].id;
  }

  /// Picks where playback should start after a queue rebuild, in priority order:
  /// 1) the position of [mediaId] (keep playing the same track across queues),
  /// 2) an explicit [index] (e.g. after removing a track), then
  /// 3) the start of the list.
  int _resolveStartIndex(List<MediaItem> songs, {String? mediaId, int? index}) {
    if (songs.isEmpty) return 0;
    if (mediaId != null) {
      final match = songs.indexWhere((song) => song.id == mediaId);
      if (match >= 0) return match;
    }
    if (index != null && index >= 0 && index < songs.length) return index;
    return 0;
  }

  /// Core queue builder. Replaces the audio source with [songs] and publishes
  /// the new queue + now-playing item. Optionally resumes playback at a chosen
  /// track. NOTE: `setAudioSource` resets position to zero, so this method is
  /// intentionally NOT used on plain navigation (that would restart playback).
  Future<void> _loadQueue(
    List<MediaItem> songs, {
    bool resumePlayback = false,
    String? resumeMediaId,
    int? resumeIndex,
  }) async {
    if (songs.isEmpty) {
      await audioPlayer.stop();
      queue.value.clear();
      queue.add(queue.value);
      return;
    }

    final startIndex = _resolveStartIndex(
      songs,
      mediaId: resumeMediaId,
      index: resumeIndex,
    );
    final audioSources = songs.map(_createAudioSource).toList();

    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(children: audioSources),
      initialIndex: startIndex,
      initialPosition: Duration.zero,
    );

    queue.value.clear();
    queue.value.addAll(songs);
    queue.add(queue.value);
    mediaItem.add(songs[startIndex]);

    if (resumePlayback) {
      await audioPlayer.play();
    }
  }

  /// Initial load of a queue (e.g. at app startup) without resuming playback.
  Future initSongs(List<MediaItem> songs) async {
    await _loadQueue(songs);
  }

  /// Rebuilds the playback queue without auto-playing.
  ///
  /// Used right before an explicit song tap so the caller can then
  /// `skipToQueueItem` the tapped index. Because nothing is auto-played here,
  /// switching the queue while browsing never starts audio on its own.
  Future<void> setQueue(List<MediaItem> songs) async {
    if (songs.isEmpty) {
      await audioPlayer.stop();
      queue.value.clear();
      queue.add(queue.value);
      return;
    }
    final sources = songs.map(_createAudioSource).toList();
    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(children: sources),
      initialIndex: 0,
      initialPosition: Duration.zero,
    );
    queue.value
      ..clear()
      ..addAll(songs);
    queue.add(queue.value);
  }

  /// Replaces the whole queue with [songs], keeping the current track playing
  /// if it also exists in the new list (`canResume`). If it does not exist, the
  /// new queue is loaded and left paused rather than abruptly cutting audio.
  ///
  /// Still used by `loadSongs`/`modQueue`; the tap flow uses [setQueue] instead.
  Future<void> switchPlaylist(List<MediaItem> songs) async {
    final wasPlaying = audioPlayer.playing;
    final currentMediaId = _currentMediaId();
    final canResume = wasPlaying &&
        currentMediaId != null &&
        songs.any((song) => song.id == currentMediaId);

    await _loadQueue(
      songs,
      resumePlayback: canResume,
      resumeMediaId: currentMediaId,
    );

    if (wasPlaying && !canResume) {
      await audioPlayer.pause();
    }
  }

  /// Syncs the playback queue after a track was removed from the loaded playlist.
  Future<void> modQueue(int removedIndex, List<MediaItem> updatedPlaylist) async {
    final wasPlaying = audioPlayer.playing;
    final currentMediaId = _currentMediaId();
    final currentIndex = audioPlayer.currentIndex ?? 0;
    final resumeIndex =
        currentIndex > removedIndex ? currentIndex - 1 : currentIndex;

    await _loadQueue(
      updatedPlaylist,
      resumePlayback: wasPlaying,
      resumeMediaId: currentMediaId,
      resumeIndex: resumeIndex,
    );
  }

  // The transport controls below are overrides from `BaseAudioHandler`. They
  // are invoked both from the in-app UI and from the OS media notification /
  // lock screen, so all playback must route through these methods.

  @override
  Future<void> play() => audioPlayer.play();

  @override
  Future<void> pause() => audioPlayer.pause();
  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);
  @override
  Future<void> skipToNext() => audioPlayer.seekToNext();

  @override
  Future<void> skipToPrevious() => audioPlayer.seekToPrevious();

  /// Jumps to [index] in the current queue, restarts that track from the
  /// beginning, and plays it. This is the explicit "play this song" entry point.
  @override
  Future<void> skipToQueueItem(int index) async {
    await audioPlayer.seek(Duration.zero, index: index);
    play();
  }

  /// `audio_service` hook for replacing the queue; delegates to [switchPlaylist]
  /// so external callers get the same resume-if-possible behavior.
  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    await switchPlaylist(queue);
  }

  /// Translates the latest `just_audio` [event] into an `audio_service`
  /// PlaybackState (controls, processing state, position, speed, queue index).
  /// This is what drives the system notification and the app's stream-based UI.
  void _broadcastState(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        const MediaControl(
            androidIcon: "drawable/ic_shuffle",
            label: "shuffle",
            action: MediaAction.setShuffleMode,
            customAction: CustomMediaAction(name: 'setShuffle')),
        MediaControl.skipToPrevious,
        if (audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        const MediaControl(
            androidIcon: "drawable/ic_repeat",
            label: "repeat",
            action: MediaAction.custom,
            customAction: CustomMediaAction(name: 'setRepeat'))
      ],
      systemActions: {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[audioPlayer.processingState]!,
      playing: audioPlayer.playing,
      updatePosition: audioPlayer.position,
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed,
      queueIndex: event.currentIndex,
    ));
  }

  /// Maps the `audio_service` shuffle mode onto `just_audio`'s boolean toggle.
  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.all) {
      audioPlayer.setShuffleModeEnabled(true);
    } else {
      audioPlayer.setShuffleModeEnabled(false);
    }
  }

  /// Maps the `audio_service` repeat mode onto `just_audio`'s [LoopMode].
  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    if (repeatMode == AudioServiceRepeatMode.one) {
      await audioPlayer.setLoopMode(LoopMode.one);
    } else if (repeatMode == AudioServiceRepeatMode.all) {
      await audioPlayer.setLoopMode(LoopMode.all);
    } else {
      await audioPlayer.setLoopMode(LoopMode.off);
    }
  }

  /// Called when the user swipes the app away from recents; releases the player
  /// so no orphaned audio/notification lingers after the task is removed.
  @override
  Future<void> onTaskRemoved() async {
    await audioPlayer.dispose();
    await audioPlayer.stop();
  }
}
