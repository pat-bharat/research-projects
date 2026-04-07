import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final String url;
  ImageViewer({
    Key? key,
    required this.url,
  }) : super(key: key);
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();
    //loadDocument();
  }

  @override
  Widget build(BuildContext context) {
    //portraitModeOnly();
    //double width = MediaQuery.of(context).size.width;
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
            Center(
              child: buildCachedNetworkCacheImage(context, widget.url),
            )
          ],
        ),
      ),
    );
  }
}
