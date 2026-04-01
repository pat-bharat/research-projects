import 'package:better_player/better_player.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class VideoPlayer extends StatefulWidget {
  final String? url;
  VideoPlayer({
    Key? key,
    required this.url,
  }) : super(key: key);
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  final NavigationService _navigationService = locator<NavigationService>();
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    //var headers =['appToken',]
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
            fit: BoxFit.contain,
            autoPlay: true,
            autoDispose: true,
            fullScreenByDefault: true,
            startAt: Duration(seconds: 0),
            //subtitlesConfiguration: ,
            autoDetectFullscreenDeviceOrientation: true);
    BetterPlayerCacheConfiguration cacheConfiguration =
        BetterPlayerCacheConfiguration(
            useCache: true, maxCacheSize: 2 * 134217728);
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, widget.url!,
        cacheConfiguration: cacheConfiguration);
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  color: Colors.black87,
                  iconSize: 30,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    _navigationService.pop();
                  },
                ),
                horizontalSpaceMedium,
                SizedBox(
                  height: 35,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ],
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _betterPlayerController),
            ),
          ],
        ),
      ),
    );
  }
}
