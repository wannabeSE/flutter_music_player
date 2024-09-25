class FormatterUtility{
  static String durationFormatter(Duration total){
    int min = total.inMinutes;
    int sec = total.inSeconds - (min * 60);
    if(sec < 10 && sec >= 0){
      return '$min:0$sec';
    }
    return '$min:$sec';
  }

  static String formattedArtist(String? artist){
    if(artist == '<unknown artist>' || artist == '<unknown>') return 'Unknown artist';
    return artist ?? 'Unknown artist';
  }

  static String formattedTitle(String title) {
    // Make a copy of the original title
    String cleanedTitle = title;

    // Remove content within parentheses
    cleanedTitle = cleanedTitle.replaceAll(RegExp(r'\([^)]*\)'), '');

    // Remove content within brackets
    cleanedTitle = cleanedTitle.replaceAll(RegExp(r'\[[^\]]*\]'), '');

    // Remove file extension (if present)
    if (cleanedTitle.contains('.')) {
      // Remove everything after the first '.'
      cleanedTitle = cleanedTitle.split('.').first;
    }

    // Return the cleaned-up title
    return cleanedTitle;
  }
}