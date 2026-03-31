import 'package:digiguru/app/youtube/model/video_model.dart';

class PlayList {
  final String id;
  final String channelId;
  final String title;
  final String description;
  final String profilePictureUrl;
  final String subscriberCount;
  final int videoCount;
  List<Video> videos;

  PlayList({
    this.id,
    this.channelId,
    this.title,
    this.description,
    this.profilePictureUrl,
    this.subscriberCount,
    this.videoCount,
    this.videos,
  });

  factory PlayList.fromMap(Map<String, dynamic> map) {
    return PlayList(
      id: map['id'],
      channelId: map['snippet']['channelId'],
      title: map['snippet']['title'],
      description: map['snippet']['description'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      videoCount: map['contentDetails']['itemCount'],
    );
  }
}
