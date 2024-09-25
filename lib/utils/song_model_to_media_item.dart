import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/utils/formatter_utility.dart';
import 'package:on_audio_query/on_audio_query.dart';

final OnAudioQuery onAudioQuery = OnAudioQuery();

Future<MediaItem> songModelToMediaItem(SongModel song)async{
  try{
    return MediaItem(
      id: song.uri.toString(),
      title: FormatterUtility.formattedTitle(song.title).trim(),
      artist: FormatterUtility.formattedArtist(song.artist).trim(),
      extras: {'song_id': song.id, 'isFav': false},
      duration: Duration(milliseconds: song.duration!)
    );
  }catch(e){
    debugPrint('Error converting SongModel to MediaItem');
    return const MediaItem(id: '', title: 'Error', artist: 'Unknown');
  }
}
