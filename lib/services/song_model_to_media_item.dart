import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<MediaItem> songModelToMediaItem(SongModel song)async{

  try{
    return MediaItem(
        id: song.uri.toString(),
        title: song.displayNameWOExt,
        artist: song.artist,
        duration: Duration(milliseconds: song.duration!)
    );
  }catch(e){
    debugPrint('Error converting SongModel to MediaItem');
    return const MediaItem(id: '', title: 'Error', artist: 'Unknown');
  }
}
