import 'package:digiguru/app/common/util/general.dart';

class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String duration;

  Video(
      {this.id,
      this.title,
      this.thumbnailUrl,
      this.channelTitle,
      this.duration});

  factory Video.fromMap(Map<String, dynamic> item, int index) {
    return Video(
        id: item['id'],
        title: computeName(index, item['snippet']['title']),
        thumbnailUrl: item['snippet']['thumbnails']['default']['url'],
        channelTitle: item['snippet']['channelTitle'],
        duration: toDuration(item['contentDetails']['duration']));
  }

  static String computeName(int index, String name) {
    List tmp = name.split('|');
    return tmp[index];
  }
}
