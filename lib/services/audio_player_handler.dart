import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';


class JustAudioPlayerHandler extends BaseAudioHandler with QueueHandler, SeekHandler{
  final AudioPlayer audioPlayer = AudioPlayer();
  List<AudioSource> audioSources = [];

  UriAudioSource _createAudioSource(MediaItem song){
    return ProgressiveAudioSource(Uri.parse(song.id));
  }

  void _listenForCurrentSongIndexChanges(){
    audioPlayer.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      mediaItem.add(playlist[index]);
    });
  }

  void _broadcastState(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        const MediaControl(
          androidIcon: "drawable/ic_shuffle",
          label: "shuffle",
          action: MediaAction.setShuffleMode,
          customAction: CustomMediaAction(name: 'setShuffle')
        ),
        MediaControl.skipToPrevious,
        if (audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        const MediaControl(
          androidIcon: "drawable/ic_repeat",
          label: "repeat",
          action: MediaAction.custom,
            customAction: CustomMediaAction(name: 'setRepeat')
        )
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
  // creating playlist with provided list of audios
  Future initSongs(List<MediaItem> songs)async{
    audioPlayer.playbackEventStream.listen(_broadcastState);
    // creating list of audio sources from the provided audios
    audioSources = songs.map((song) => _createAudioSource(song)).toList();

    await audioPlayer
        .setAudioSource(
        ConcatenatingAudioSource(children: audioSources)
    );
    queue.value.clear();
    queue.value.addAll(songs);
    queue.add(queue.value);
    _listenForCurrentSongIndexChanges();

    audioPlayer.processingStateStream.listen((state){
      if(state == ProcessingState.completed) skipToNext();
    });
  }

  Future<void> switchPlaylist(List<MediaItem> songs)async{
    await audioPlayer.stop();
    await initSongs(songs);
  }
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

  @override
  Future<void> skipToQueueItem(int index)async{
    await audioPlayer.seek(Duration.zero, index: index);
    play();
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue)async{
    audioSources.clear();
    await initSongs(newQueue);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode)async{
    if(shuffleMode == AudioServiceShuffleMode.all){
      audioPlayer.setShuffleModeEnabled(true);
    }else{
      audioPlayer.setShuffleModeEnabled(false);
    }

  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async{

    if(repeatMode == AudioServiceRepeatMode.one){
      await audioPlayer.setLoopMode(LoopMode.one);
    }else if(repeatMode == AudioServiceRepeatMode.all){
      await audioPlayer.setLoopMode(LoopMode.all);
    }else{
      await audioPlayer.setLoopMode(LoopMode.off);
    }

  }
  @override
  Future<void> onTaskRemoved() async{
    await audioPlayer.dispose();
    await audioPlayer.stop();
  }

}