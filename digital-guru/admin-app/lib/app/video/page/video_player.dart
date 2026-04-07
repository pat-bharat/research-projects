import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:better_native_video_player/better_native_video_player.dart';

class VideoPlayer extends StatefulWidget {
  final String? url;
  VideoPlayer({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  final NavigationService _navigationService = locator<NavigationService>();
  late NativeVideoPlayerController _nativeVideoPlayerController = NativeVideoPlayerController(
     id: 1,
     autoPlay: false,
     enableLooping: false,
     showNativeControls: true,         
  );
  @override
  void initState() {
    super.initState();
    _nativeVideoPlayerController.loadUrl(url:  widget.url!);
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
              child: NativeVideoPlayer (               
                controller: _nativeVideoPlayerController,
                
                // Add other configuration as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}