// ignore_for_file: public_member_api_docs
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/shared_services/cloud_storage_service.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/video/model/firebase_upload_item.dart';
import 'package:digiguru/app/video/model/video_info.dart';
import 'package:digiguru/app/video/page/supabase_upload_item_view.dart';
import 'package:digiguru/app/video/service/media_upload_background_handler.dart';
import 'package:digiguru/app/video/service/media_upload_service.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:path/path.dart' as p;
//import 'package:light_compressor/light_compressor.dart' as lc;
//import 'package:timeago/timeago.dart' as timeago;
import 'package:video_compress/video_compress.dart';
/**
 * generate thumbnail
 * compress video
 * upload as background service
 */
class MediaUploadService extends BaseService {
  static String? videosDir;
  final CloudStorageService _cloudStorageService = locator<CloudStorageService>();
  static MediaUploadService? _instance;
  static List<SupabaseUploadItem> _tasks = [];
  static List<SupabaseUploadItem> get tasks => _tasks;

  final StreamController<List<SupabaseUploadItem>> _uploadItemController = StreamController<List<SupabaseUploadItem>>.broadcast();
  factory MediaUploadService() {
    return _instance ??= MediaUploadService.private();
  }
  @visibleForTesting
  MediaUploadService.private() {
    _initialize();
  }

  Future _initialize() async {
    final Directory extDir = await path.getApplicationDocumentsDirectory();
    final outDirPath = '${extDir.path}/Videos/';
    Directory vDir = Directory(outDirPath);
    vDir.createSync(recursive: true);
    videosDir = vDir.path;
  }

  Future<File> getVideoThumbnail(String videoPath, int quality) async {
    return await VideoCompress.getFileThumbnail(
      videoPath,
      quality: 30, // default(100)
      position: 0, // default(-1)
    );
  }

  Future<MediaInfo> getMediaInfo(String path) async {
    MediaInfo info = await VideoCompress.getMediaInfo(path);
    if (info.title == null || info.title!.isEmpty) {
      info.title = p.basename(path);
    }
    return info;
  }

  /*
Future<String> get _destinationFile(String fileName) async {
  String directory;
  final String videoName = '${fileName}.mp4';
  if (Platform.isAndroid) {
    // Handle this part the way you want to save it in any directory you wish.
    final List<Directory>? dir = await path.getExternalStorageDirectories(
        type: path.StorageDirectory.movies);
    directory = dir!.first.path;
    return File('$videosDir/$videoName').path;
  } else {
    final Directory dir = await path.getLibraryDirectory();
    directory = dir.path;
    return File('$directory/$videoName').path;
  }
}*/
/*
  Future<MediaInfo> compressVideo(
      {String path, VideoQuality outputQuality}) async {
    await VideoCompress.setLogLevel(0);
    final info = await VideoCompress.compressVideo(
      path,
      quality:
          outputQuality != null ? outputQuality : VideoQuality.DefaultQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    return info;
  }
*/
  Future<String> videoCompressLigh(
      {required VideoInfo videoInfo}) async {
    var fileName = videoInfo.title!.split('.').first;
    await VideoCompress.compressVideo(
      videoInfo.rawVideoPath!,
      quality: VideoQuality.HighestQuality,
      deleteOrigin: false,
      includeAudio: true,           
    );
   /* await lc.LightCompressor().compressVideo(
        path: videoInfo.rawVideoPath!,
        videoQuality: outputQuality ?? lc.VideoQuality.very_high,
        android:
            lc.AndroidConfig(saveAt: lc.SaveAt.Movies, isSharedStorage: false),
        ios: lc.IOSConfig(),
        video: lc.Video(
            videoName: videoInfo.title!,
            keepOriginalResolution: true,
            videoBitrateInMbps: 1000));
    */
    return '$videosDir/$fileName.mp4';
  }

  Future uploadVideoWithProgress({
    required VideoInfo videoInfo,
    required String uploadDir,
    Function(double)? onProgress,
    Function? onComplete,
    Function(String)? onError,
  }) async {
    var fn = videoInfo.title!.split('.').first;
    String outPath = '$videosDir/$fn.mp4';

    // Compress
    await videoCompressLigh(videoInfo: videoInfo);

    videoInfo.rawVideoPath = outPath;
    String fileName = p.basename(outPath);
    videoInfo.title = fileName;

    final file = File(videoInfo.rawVideoPath!);
    final total = await file.length();
    int sent = 0;
    final supabase = Supabase.instance.client;
    final stream = file.openRead().transform<List<int>>(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sent += data.length;
          if (onProgress != null) onProgress(sent / total);
          sink.add(data);
        },
      ),
    );
    try {
      await supabase.storage.from('your-bucket').uploadBinary(uploadDir + '/' + fileName, stream as Uint8List, 
          retryAttempts: 2,
          retryController: StorageRetryController(),
          fileOptions: FileOptions(contentType: 'application/octet-stream'));
      if (onProgress != null) onProgress(1.0);
      if (onComplete != null) onComplete();
    } catch (e) {
      if (onError != null) onError(e.toString());
    }

    SupabaseUploadItem uploadItem = SupabaseUploadItem(
      videoInfo.title,
      fileToUpload: videoInfo.rawVideoPath,
      destPath: uploadDir,
      uploadProgress: 100,
      onComplete: onComplete,
      errorMessage: null,
      status: 'success',
      supabaseUrl: null,
    );
    addUploadItem(uploadItem);
  }

  void addUploadItem(SupabaseUploadItem item) {
    _tasks.add(item);
    _uploadItemController.add(_tasks);
  }

  void removeUploadItem(SupabaseUploadItem item) {
    _tasks.remove(item);
    _uploadItemController.add(_tasks);
  }

  void clearCompletedTasks() {
    _tasks.clear();
    _uploadItemController.add(_tasks);
  }

  Stream<List<SupabaseUploadItem>> listenToUploadItems() {
    _uploadItemController.add(_tasks);
    return _uploadItemController.stream;
  }
}
