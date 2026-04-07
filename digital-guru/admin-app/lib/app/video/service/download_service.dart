import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'dart:async';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  bool debug = true;

//final TargetPlatform platform;

  late String _localPath;
  String get localDir => _localPath;
  ReceivePort _port = ReceivePort();
  // final platform;
  late List<DownloadTask> tasks;

  static bool setupListener = false;

  DownloadService._privateConstructor() {
    _bindBackgroundIsolate();
  }

  static final DownloadService instance = DownloadService._privateConstructor();

  void registerCallBack(DownloadCallback callback) {
    FlutterDownloader.registerCallback(callback);
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'digiguru_download_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
  }

  void listenToBackgroundIsolate(Function(dynamic) listen) {
    if (!setupListener) {
      _port.listen(listen);
      setupListener = true;
    }
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('digiguru_download_port');
  }

  Future<String> initDownloadDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    /* platform ==
       TargetPlatform.android
        ? await getExternalStorageDirectory()
        : */

    _localPath =
        (directory.path + Platform.pathSeparator + 'digiguru_downloads');

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    return directory.path;
  }

  Future requestDownload(String url, String fileName) async {
    if (_localPath == null) {
      await initDownloadDirectory();
    }
    return await FlutterDownloader.enqueue(
        url: url,
        fileName: fileName,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }
}
