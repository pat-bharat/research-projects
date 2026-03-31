import 'dart:io';

import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/video/model/firebase_upload_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseUploadItemView extends StatefulWidget {
  final FirebaseUploadItem item;

  FirebaseUploadItemView({
    Key key,
    this.item,
  }) : super(key: key);
  @override
  _FirebaseUploadItemViewState createState() => _FirebaseUploadItemViewState();
}

class _FirebaseUploadItemViewState extends State<FirebaseUploadItemView> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask _uploadTask;
  @override
  void initState() {
    super.initState();
    _uploadTask = widget.item.uploadTask;
  }

  /// Starts an upload task
  void startUpload() {
    /// Unique file name for the file
    setState(() {
      _uploadTask = _storage
          .ref()
          .child(widget.item.destPath)
          .putFile(File(widget.item.fileToUpload));
    });

    _uploadTask.whenComplete(widget.item.onComplete);
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      TaskSnapshot snapshot;

      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<TaskSnapshot>(
          stream: _uploadTask.snapshotEvents,
          builder: (context, AsyncSnapshot<TaskSnapshot> asyncSnapshot) {
            double progressPercent = 0;
            if (asyncSnapshot != null && asyncSnapshot.hasData) {
              snapshot = asyncSnapshot.data;
              progressPercent = snapshot != null
                  ? snapshot.bytesTransferred / snapshot.totalBytes
                  : 0;
              print('Uplaod Task >> ' + snapshot.toString());
              return commonContainer(
                  context,
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(widget.item.title),
                          if (snapshot.state == TaskState.success)
                            IconButton(
                                icon: Icon(Icons.check),
                                iconSize: Theme.of(context).iconTheme.size,
                                onPressed: () {}),
                          if (TaskState.paused == snapshot.state)
                            IconButton(
                                icon: Icon(Icons.play_arrow_rounded),
                                iconSize: Theme.of(context).iconTheme.size,
                                onPressed: _uploadTask.resume),
                          if (TaskState.running == snapshot.state)
                            IconButton(
                                icon: Icon(Icons.pause),
                                iconSize: Theme.of(context).iconTheme.size,
                                onPressed: _uploadTask.resume),
                          if (TaskState.success != snapshot.state)
                            IconButton(
                                icon: Icon(Icons.cancel),
                                iconSize: Theme.of(context).iconTheme.size,
                                onPressed: _uploadTask.cancel),
                        ],
                      ),
                      if (progressPercent < 1)
                        LinearProgressIndicator(
                          value: progressPercent,
                        ),
                      if (progressPercent < 1)
                        Text(
                            '${(progressPercent * 100).toStringAsFixed(2)} % '),
                    ],
                  ),
                  drawBorder: false);
            } else {
              return commonContainer(
                  context,
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(widget.item.title),
                        IconButton(
                            icon: Icon(Icons.check),
                            iconSize: Theme.of(context).iconTheme.size,
                            onPressed: () {}),
                      ],
                    )
                  ]),
                  drawBorder: false);
            }
          });
    } else {
      return Container(
        child: Text("No Upload task found..."),
      );
    }
  }
}
