import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/image/gf_image_overlay.dart';

buildBusinessAppBar(BuildContext context, dynamic model, String title,
    {height = 45}) {
  return AppBar(
    // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    // actionsIconTheme: Theme.of(context).iconTheme,
    primary: true,
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
          color: Theme.of(context).appBarTheme.foregroundColor),
    ),
    elevation: 10,
    actions: [
      /* horizontalSpaceTiny,
      IconButton(
        color: Theme.of(context).appBarTheme.foregroundColor,
        //iconSize: 20,
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          model.goBack();
        },
      ),*/
      horizontalSpaceTiny,
      IconButton(
        color: Theme.of(context).appBarTheme.foregroundColor,
        icon: Icon(Icons.upload_rounded),
        onPressed: () {
          model.showUploadQueueView();
        },
      ),
      horizontalSpaceTiny,
      IconButton(
        color: Theme.of(context).appBarTheme.foregroundColor,
        icon: Icon(Icons.download_rounded),
        onPressed: () {
          model.showDownloadQueueView(Theme.of(context).platform);
        },
      ),
      GFImageOverlay(
        height: height * .75,
        width: height * .75,
        shape: BoxShape.circle,
        image: AssetImage('assets/images/logo.png'),
        boxFit: BoxFit.cover,
      ),
      horizontalSpaceSmall
      /*IconButton(
              color: Theme.of(context).appBarTheme.foregroundColor,
              iconSize: Theme.of(context).iconTheme.size,
              icon: Icon(Icons.logout),
              onPressed: () {
                _authService.signOff();
              },
            ),*/
    ],
  );
}

buildSystemAppBar(BuildContext context, dynamic model, String title,
    {height = 45}) {
  return AppBar(
    // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    // actionsIconTheme: Theme.of(context).iconTheme,
    primary: true,
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
          color: Theme.of(context).appBarTheme.foregroundColor),
    ),
    elevation: 10,
    actions: [
      /* horizontalSpaceTiny,
      IconButton(
        color: Theme.of(context).appBarTheme.foregroundColor,
        //iconSize: 20,
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          model.goBack();
        },
      ),*/

      IconButton(
        color: Theme.of(context).appBarTheme.foregroundColor,
        iconSize: Theme.of(context).iconTheme.size,
        icon: Icon(Icons.logout),
        onPressed: () {
          model.signOut();
        },
      ),
    ],
  );
}

buildUserAppBar(BuildContext context, dynamic model, String title,
    {height = 45}) {
  return AppBar(
    // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    // actionsIconTheme: Theme.of(context).iconTheme,
    primary: true,
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
          color: Theme.of(context).appBarTheme.foregroundColor),
    ),
    elevation: 10,
    actions: [
      /* horizontalSpaceTiny,
      IconButton(
        color: Theme.of(context).appBarTheme.foregroundColor,
        //iconSize: 20,
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          model.goBack();
        },
      ),*/
      horizontalSpaceTiny,
      IconButton(
        color: Theme.of(context).appBarTheme.foregroundColor,
        icon: Icon(Icons.refresh_rounded),
        onPressed: () {
          model.refresh();
        },
      ),
      IconButton(
        color: Theme.of(context).appBarTheme.foregroundColor,
        icon: Icon(Icons.download_rounded),
        onPressed: () {
          model.showDownloadQueueView(Theme.of(context).platform);
        },
      ),
      GFImageOverlay(
        height: height * .75,
        width: height * .75,
        shape: BoxShape.circle,
        image: AssetImage('assets/images/logo.png'),
        boxFit: BoxFit.cover,
      ),
      horizontalSpaceSmall
      /*IconButton(
              color: Theme.of(context).appBarTheme.foregroundColor,
              iconSize: Theme.of(context).iconTheme.size,
              icon: Icon(Icons.logout),
              onPressed: () {
                _authService.signOff();
              },
            ),*/
    ],
  );
}
