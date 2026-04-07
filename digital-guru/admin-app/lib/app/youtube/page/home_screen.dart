import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/youtube/model/channel_model.dart';
import 'package:digiguru/app/youtube/model/video_model.dart';
import 'package:digiguru/app/youtube/page/playlist_screen.dart';
import 'package:digiguru/app/youtube/page/video_screen.dart';
import 'package:digiguru/app/youtube/service/api_service.dart';
import 'package:digiguru/app/youtube/service/youtube_course_builder_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Channel _channel;
  YoutubeCourseBuilderService _utubeService =
      locator<YoutubeCourseBuilderService>();
  APIService _apiService = locator<APIService>();
  @override
  void initState() {
    super.initState();
    _initChannel();
  }

//Flute GURU --> UC6T85gyXT_WqvsEYNUWTSJA // UC6Dy0rQ6zDnQuHQ1EeErGUA
  _initChannel() async {
    Channel channel = await _apiService.fetchChannel(
        channelId: 'UC6T85gyXT_WqvsEYNUWTSJA', playlist: 'true');
    setState(() {
      _channel = channel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _channel != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(),
                Expanded(
                    child: ListView(
                  children: _buildChannelPlayList(context),
                  shrinkWrap: true,
                )),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).scaffoldBackgroundColor, // Red
                ),
              ),
            ),
    ));
  }

  _buildChannelPlayList(BuildContext context) {
    List<Widget> widgets = List.empty(growable: true);
    _channel.playLists?.forEach((element) {
      widgets.add(PlaylistScreen(playList: element));
    });
    return widgets;
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
            backgroundImage: _channel.profilePictureUrl != null
                ? NetworkImage(_channel.profilePictureUrl!)
                : null,
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _channel.title ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${_channel.subscriberCount} subscribers',
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
}
