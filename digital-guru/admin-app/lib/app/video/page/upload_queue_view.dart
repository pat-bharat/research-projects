// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:digiguru/app/video/model/upload_item.dart';
import 'package:digiguru/app/video/page/upload_item_view.dart';
import 'package:digiguru/app/video/service/media_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:light_compressor/light_compressor.dart';
import 'package:video_compress/video_compress.dart';

/// Shows the statusresponses for previous uploads.
class UploadQueueView extends StatefulWidget {
  UploadQueueView({
    Key? key,
  }) : super(key: key);

  final FlutterUploader uploader = MediaUploadService.uploader;

  @override
  _UploadQueueViewState createState() => _UploadQueueViewState();
}

class _UploadQueueViewState extends State<UploadQueueView> {
  StreamSubscription<UploadTaskProgress>? _progressSubscription;
  StreamSubscription<UploadTaskResponse>? _resultSubscription;
  StreamSubscription<dynamic>? _compressionSubscription;

  Map<String, UploadItem> _tasks = {};

  @override
  void initState() {
    super.initState();
    //widget.uploader.setBackgroundHandler(backgroundHandler);
    _progressSubscription = widget.uploader.progress.listen((progress) {
      final task = _tasks[progress.taskId];
      print(
          'In MAIN APP: ID: ${progress.taskId}, progress: ${progress.progress}');
      if (task == null) return;
      if (task.isCompleted()) return;

      var tmp = <String, UploadItem>{}..addAll(_tasks);
      tmp.putIfAbsent(progress.taskId, () => UploadItem(progress.taskId));
      tmp[progress.taskId] =
          task.copyWith(progress: progress.progress, status: progress.status);
      setState(() => _tasks = tmp);
    }, onError: (ex, stacktrace) {
      print('exception: $ex');
      print('stacktrace: $stacktrace' ?? 'no stacktrace');
    });

    _resultSubscription = widget.uploader.result.listen((result) {
      print(
          'IN MAIN APP: ${result.taskId}, status: ${result.status}, statusCode: ${result.statusCode}, headers: ${result.headers}');

      var tmp = <String, UploadItem>{}..addAll(_tasks);
      tmp.putIfAbsent(result.taskId, () => UploadItem(result.taskId));
      tmp[result.taskId] =
          tmp[result.taskId]!.copyWith(status: result.status, response: result);

      setState(() => _tasks = tmp);
    }, onError: (ex, stacktrace) {
      print('exception: $ex');
      print('stacktrace: $stacktrace' ?? 'no stacktrace');
    });

    _compressionSubscription =
        LightCompressor().onProgressUpdated.listen((event) {
      // Handle compression progress
    });
  }

  @override
  void dispose() {
    super.dispose();
    try {
      if (_progressSubscription != null) _progressSubscription?.cancel();
    } catch (e) {
      print(e);
    }
    try {
      if (_resultSubscription != null) _resultSubscription?.cancel();
    } catch (e) {
      print(e);
    }
    try {
      if (_compressionSubscription != null) _compressionSubscription?.cancel();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Upload Queue'),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20.0),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final item = _tasks.values.elementAt(index);
          return UploadItemView(
            item: item,
            onCancel: _cancelUpload,
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.black,
          );
        },
      ),
    );
  }

  Future _cancelUpload(String id) async {
    await widget.uploader.cancel(taskId: id);
  }
}
