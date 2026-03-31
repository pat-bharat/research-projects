import 'dart:io';

import 'package:video_compress/video_compress.dart';

class VideoCompressionService {
  static Future<MediaInfo> compressVideo(
      String path, VideoQuality outputQuality) async {
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

  static Future<File> getVideoThumbnail(String videoPath, int quality) async {
    return await VideoCompress.getFileThumbnail(videoPath,
        quality: 50, // default(100)
        position: -1 // default(-1)
        );
  }
}
