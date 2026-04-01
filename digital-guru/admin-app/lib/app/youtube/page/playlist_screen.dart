import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/youtube/model/channel_model.dart';
import 'package:digiguru/app/youtube/model/playlist_model.dart';
import 'package:digiguru/app/youtube/model/video_model.dart';
import 'package:digiguru/app/youtube/page/video_screen.dart';
import 'package:digiguru/app/youtube/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';

class PlaylistScreen extends StatefulWidget {
  final PlayList playList;
  PlaylistScreen({Key? key, required this.playList}) : super(key: key);
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late PlayList _playList;
  bool _isLoading = false;
  APIService _apiService = locator<APIService>();
  @override
  void initState() {
    super.initState();
    _playList = widget.playList;
    _playList.videos = List.empty(growable: true);
    //_loadMoreVideos();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _playList != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    (_playList.videos?.length ?? 0) != _playList.videoCount &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreVideos();
                }
                return false;
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(),
                  Expanded(child: _buildPlayList()),
                ],
              ))
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).scaffoldBackgroundColor, // Red
                ),
              ),
            ),
    ));
  }

//Flute GURU --> UC6T85gyXT_WqvsEYNUWTSJA // UC6Dy0rQ6zDnQuHQ1EeErGUA
  _buildPlayList() {
    Widget videos = ListView.builder(
      itemCount: _playList.videos?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        Video video = _playList.videos![index];
        return _buildVideo(video);
      },
      shrinkWrap: true,
    );
    return GFAccordion(
      showAccordion: true,
      title:
          (_playList.title ?? '') + '(' + _playList.videoCount.toString() + ') videos',
      contentPadding: const EdgeInsets.all(5),
      textStyle: Theme.of(context).textTheme.headlineMedium ?? const TextStyle(),
      collapsedTitleBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      contentBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      contentChild: videos,
    );
  }

  _buildProfileInfo() {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(20.0),
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            backgroundImage: NetworkImage(_playList.profilePictureUrl ?? ''),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _playList.title ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_playList.subscriberCount} subscribers',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 140.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos =
        await _apiService.fetchVideosFromPlaylist(playlistId: _playList.id ?? '', nameIndex: _playList.videos?.length ?? 0);
    List<Video> allVideos = (_playList.videos ?? [])..addAll(moreVideos);
    setState(() {
      _playList.videos = allVideos;
    });
    _isLoading = false;
  }
}
