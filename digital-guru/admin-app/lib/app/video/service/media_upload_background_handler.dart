import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:shared_preferences/shared_preferences.dart';

void backgroundHandler() {
  WidgetsFlutterBinding.ensureInitialized();

  // Notice these instances belong to a forked isolate.
  var uploader = FlutterUploader();

  var notifications = FlutterLocalNotificationsPlugin();

  // Only show notifications for unprocessed uploads.
  SharedPreferences.getInstance().then((preferences) {
    var processed = preferences.getStringList('processed') ?? <String>[];

    if (Platform.isAndroid) {
      uploader.progress.listen((uploadTaskProgress) async {
        if (processed.contains(uploadTaskProgress.taskId)) {
          return;
        }

        AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'FlutterUploader.Example',
          'FlutterUploader',
          importance: Importance.min,
          progress: uploadTaskProgress.progress ?? 0,
          enableVibration: false,
          showProgress: true,
          onlyAlertOnce: true,
          maxProgress: 100,
          channelShowBadge: false,
        );
        /* NotificationDetails platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics,
            IOSNotificationDetails(
              presentAlert: true,
            ));
        await notifications.show(
            0, 'plain title', 'plain body', platformChannelSpecifics,
            payload: 'item x');*/
      });
    }

    uploader.result.listen((result) async {
      if (processed.contains(result.taskId)) {
        return;
      }

      processed.add(result.taskId);
      preferences.setStringList('processed', processed);

      await notifications.cancel(id: int.parse(result.taskId));

      final successful = result.status == UploadTaskStatus.complete;

      var title = 'Upload Complete';
      if (result.status == UploadTaskStatus.failed) {
        title = 'Upload Failed';
      } else if (result.status == UploadTaskStatus.canceled) {
        title = 'Upload Canceled';
      }

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'FlutterUploader.Example',
        'FlutterUploader',
        channelDescription: 'Installed when you activate the Flutter Uploader Example',
        progress: 100,
        icon: 'ic_upload',
        enableVibration: !successful,
        importance: result.status == UploadTaskStatus.failed
            ? Importance.max
            : Importance.min,
      );
      /*NotificationDetails platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics,
          IOSNotificationDetails(
            presentAlert: true,
          ));
      await notifications
          .show(0, title, 'plain body', platformChannelSpecifics,
              payload: 'item x')
          .catchError((e, stack) {
        print('error while showing notification: $e, $stack');
      });*/
    });
  });
}
