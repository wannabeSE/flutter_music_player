import 'package:audio_service/audio_service.dart';

class MediaItemHelper{
  static Map<String, dynamic> mediaItemToMap(MediaItem item){
    return {
      'id': item.id,
      'title': item.title,
      'artist': item.artist,
      'extras': item.extras,
      'duration': item.duration?.inMilliseconds,
    };
  }
  static MediaItem mapToMediaItem(Map mp){
    return MediaItem(
      id: mp['id'],
      title: mp['title'],
      artist: mp['artist'],
      duration: mp['duration'] != null ? Duration(milliseconds: mp['duration']) : null,
      extras: mp['extras'],
    );
  }
}