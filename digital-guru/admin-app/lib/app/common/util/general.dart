import 'dart:math';

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) {
    return '0 B';
  }
  const List<String> suffixes = <String>[
    'B',
    'KB',
    'MB',
    'GB',
    'TB',
    'PB',
    'EB',
    'ZB',
    'YB',
  ];
  final int i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

String computeDuration(String duration) {
  double? micro = (double.tryParse(duration));
  if (micro != null) {
    double sec = micro / 100;
    if (sec > 60) {
      return (sec / 60).toStringAsFixed(2);
    } else {
      return "00:" + sec.round().toString();
    }
  }
  return duration;
}

String toDuration(String isoString) {
  if (!RegExp(
          r"^(-|\+)?P(?:([-+]?[0-9,.]*)Y)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)W)?(?:([-+]?[0-9,.]*)D)?(?:T(?:([-+]?[0-9,.]*)H)?(?:([-+]?[0-9,.]*)M)?(?:([-+]?[0-9,.]*)S)?)?$")
      .hasMatch(isoString)) {
    throw ArgumentError("String does not follow correct format");
  }

  //final weeks = _parseTime(isoString, "W");
  //final days = _parseTime(isoString, "D");
  final hours = _parseTime(isoString, "H");
  final minutes = _parseTime(isoString, "M");
  final seconds = _parseTime(isoString, "S");
  return (hours > 0 ? hours.toString() + ':' : "") +
      (minutes > 0 ? minutes.toString() + ':' : "") +
      seconds.toString();
}

/// Private helper method for extracting a time value from the ISO8601 string.
int _parseTime(String duration, String timeUnit) {
  final timeMatch = RegExp(r"\d+" + timeUnit).firstMatch(duration);

  if (timeMatch == null) {
    return 0;
  }
  final timeString = timeMatch.group(0)!;
  return int.parse(timeString.substring(0, timeString.length - 1));
}

String getFileName(String path) {
  return path.split('/').last;
}
