import 'dart:convert';
import 'dart:io';

import 'package:digiguru/app/youtube/model/channel_model.dart';
import 'package:digiguru/app/youtube/model/playlist_model.dart';
import 'package:digiguru/app/youtube/model/video_model.dart';
import 'package:digiguru/app/youtube/service/key.dart';
import 'package:http/http.dart' as http;

class APIService {
  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel(
      {required String channelId, required String? playlist}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics, contentOwnerDetails',
      'id': channelId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      //print(response.body);
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      // Fetch first batch of videos from uploads playlist
      channel.playLists = await fetchChannelPlaylist(
          channelId: channel.id!, playlist: playlist as String);
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<PlayList>> fetchChannelPlaylist(
      {required String channelId, required String playlist}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'id': playlist,
      'maxResults': '50',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlists',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> plList = data['items'];
      List<PlayList> playLists = List.empty(growable: true);
      plList.forEach((item) {
        playLists.add(PlayList.fromMap(item));
      }); // Fetch first batch of videos from uploads playlist

      return playLists;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist(
      {required int nameIndex, required String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '50',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from uploads playlist
      List<String> ids = [];
      videosJson.forEach(
        (json) => ids.add(json['snippet']['resourceId']['videoId']),
      );
      //cities = ['NY', 'LA', 'Tokyo']; String s = cities.join(', '); print(s); }.
      String videoIds = ids.join(',');

      return await getVideos(videoIds, nameIndex);
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> getVideos(String ids, int nameIndex) async {
    Map<String, String> parameters = {
      'part': 'snippet,contentDetails',
      'id': ids,
      'maxResults': '50',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/videos',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      List<Video> videos = [];
      videosJson.forEach((item) => videos.add(Video.fromMap(item, nameIndex)));
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}

void main() async {
  var service = APIService();
  Channel c = await service.fetchChannel(
      channelId: 'UC6T85gyXT_WqvsEYNUWTSJA', playlist: '');
  print(c);
}
