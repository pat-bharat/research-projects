import 'package:digiguru/app/youtube/model/playlist_model.dart';
import 'package:digiguru/app/youtube/model/video_model.dart';

class Channel {
  final String? id;
  final String? title;
  final String? profilePictureUrl;
  final String? subscriberCount;
  final String? playListCount;
  final String? uploadPlaylistId;
  List<PlayList>? playLists;

  Channel({
    this.id,
    this.title,
    this.profilePictureUrl,
    this.subscriberCount,
    this.playListCount,
    this.uploadPlaylistId,
    this.playLists,
  });

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      subscriberCount: map['statistics']['subscriberCount'],
      //videoCount: map['statistics']['videoCount'],
      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
    );
  }
}
