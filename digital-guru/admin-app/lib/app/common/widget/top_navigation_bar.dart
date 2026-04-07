import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  //final AuthenticationService _authService = locator<AuthenticationService>();
  final dynamic model;
  final String text;
  final double height;
  final bool showDrawer;
  TopNavigationBar({
    Key? key,
    required this.model,
    required this.text,
    this.showDrawer = false,
    this.height = 45,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            horizontalSpaceTiny,
            GFImageOverlay(
              height: this.height * .75,
              width: this.height * .75,
              shape: BoxShape.circle,
              image: AssetImage('assets/images/logo.png'),
              boxFit: BoxFit.cover,
            ),
            horizontalSpaceTiny,
            IconButton(
              color: Theme.of(context).appBarTheme.foregroundColor,
              //iconSize: 20,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                model.goBack();
              },
            ),
            horizontalSpaceTiny,
            Expanded(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                text,
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headlineMedium?.fontSize,
                    color: Theme.of(context).appBarTheme.foregroundColor),
              )
            ])),
            horizontalSpaceTiny,
            IconButton(
              color: Theme.of(context).appBarTheme.foregroundColor,
              icon: Icon(Icons.download_done_sharp),
              onPressed: () {
                model.showDownloadQueueView(Theme.of(context).platform);
              },
            ),

            /*IconButton(
              color: Theme.of(context).appBarTheme.foregroundColor,
              iconSize: Theme.of(context).iconTheme.size,
              icon: Icon(Icons.logout),
              onPressed: () {
                _authService.signOff();
              },
            ),*/
          ],
        ));
  }

  @override
  Size get preferredSize => Size(0, height);
}
