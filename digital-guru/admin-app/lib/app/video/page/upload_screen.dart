// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:digiguru/app/common/util/media_selector.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_uploader_example/server_behavior.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}


class _UploadTask {
  final String name;
  final StreamController<double> progressController;
  final File file;
  bool isCancelled = false;
  _UploadTask(this.name, this.file) : progressController = StreamController.broadcast();
  void cancel() {
    isCancelled = true;
    progressController.close();
  }
}

class _UploadScreenState extends State<UploadScreen> {
  final MediaSelector mediaSelector = MediaSelector();
  final List<_UploadTask> _uploads = [];
  final String bucket = 'your-bucket'; // TODO: set your bucket name

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      mediaSelector.retrieveLostData().then((lostData) {
          _handleFileUpload([File(lostData.file!.path)]);
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Uploader'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Supabase Storage Uploads', style: Theme.of(context).textTheme.bodyMedium),
                Divider(),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => getImage(),
                      child: Text('upload image'),
                    ),
                    TextButton(
                      onPressed: () => getVideo(),
                      child: Text('upload video'),
                    ),
                    TextButton(
                      onPressed: () => getMultiple(),
                      child: Text('upload multi'),
                    ),
                  ],
                ),
                Divider(height: 40),
                Text('Uploads Progress'),
                ..._uploads.map((task) => _buildProgressTile(task)).toList(),
                Divider(height: 40),
                Text('Cancellation'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: _cancelAllUploads,
                      child: Text('Cancel All'),
                    ),
                    Container(width: 20.0),
                    TextButton(
                      onPressed: _clearUploads,
                      child: Text('Clear Uploads'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future getImage() async {
    var image = await mediaSelector.selectImage();
    if (image != null) {
      _handleFileUpload([File(image.path)]);
    }
  }


  Future getVideo() async {
    var video = await mediaSelector.selectVideo();
    if (video != null) {
      _handleFileUpload([File(video.path)]);
    }
  }


  Future getMultiple() async {
    mediaSelector.selectMultipleFiles().then((files) {
      if (files != null && files.isNotEmpty) {
        _handleFileUpload(files.map((f) => File(f.path)).toList());
      }
    });
  }


  void _handleFileUpload(List<File> files) async {
    for (final file in files) {
      final name = file.path.split(Platform.pathSeparator).last;
      final task = _UploadTask(name, file);
      setState(() => _uploads.add(task));
      _uploadWithProgress(task);
    }
  }


  Future<void> _uploadWithProgress(_UploadTask task) async {
    final supabase = Supabase.instance.client;
    final total = await task.file.length();
    int sent = 0;
    final stream = task.file.openRead().transform<List<int>>(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          if (task.isCancelled) return;
          sent += data.length;
          task.progressController.add(sent / total);
          sink.add(data);
        },
      ),
    );
    await supabase.storage
        .from(bucket)
        .uploadBinary(
          task.name, 
          stream as Uint8List, 
          retryAttempts: 2,
          retryController: StorageRetryController(),
          fileOptions: FileOptions(contentType: 'application/octet-stream'));
    if (!task.isCancelled) {
      task.progressController.add(1.0);
    }
    await task.progressController.close();
    setState(() {});
  }

  Widget _buildProgressTile(_UploadTask task) {
    return StreamBuilder<double>(
      stream: task.progressController.stream,
      initialData: 0.0,
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0.0;
        return ListTile(
          title: Text(task.name),
          subtitle: LinearProgressIndicator(value: progress),
          trailing: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              setState(() {
                task.cancel();
                _uploads.remove(task);
              });
            },
          ),
        );
      },
    );
  }

  void _cancelAllUploads() {
    for (final task in _uploads) {
      task.cancel();
    }
    setState(() => _uploads.clear());
  }

  void _clearUploads() {
    setState(() => _uploads.clear());
  }
}
