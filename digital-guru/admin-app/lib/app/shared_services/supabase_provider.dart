//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:digiguru/app/common/service/base_service.dart';

class SupabaseProvider {
  /*
  static saveVideo(VideoInfo video) async {
    await FirebaseFirestore.instance
        .collection('videos')
        .doc(video.videoName)
        .set({
      'thumbUrl': video.thumbUrl,
      'coverUrl': video.coverUrl,
      'aspectRatio': video.aspectRatio,
      'uploadedAt': video.uploadedAt,
      'videoName': video.videoName,
    });
  }
*/
  static saveDownloadUrl(String videoName, String downloadUrl) async {
    await BaseService.supabaseDataService.fetchAllWithQuery('videos', where: {
      'video_name': videoName
    }).then((userData) => {
          if (userData.isNotEmpty)
            {
              BaseService.supabaseDataService.update(
                  'videos',
                  userData.first['id'],
                  {'video_url': downloadUrl, 'finished_processing': true})
            }
        });
  }

  static createNewVideo(String videoName, String rawVideoPath) async {
    await BaseService.supabaseDataService.insert('videos', {
      'finishedProcessing': false,
      'videoName': videoName,
      'rawVideoPath': rawVideoPath,
    });
  }

  static deleteVideo(String videoName) async {
    await BaseService.supabaseDataService.fetchAllWithQuery('videos', where: {
      'video_name': videoName
    }).then((userData) => {
          if (userData.isNotEmpty)
            {
              BaseService.supabaseDataService
                  .delete('videos', userData.first['id'])
            }
        });
  }
/*
  static listenToVideos(callback) async {
    FirebaseFirestore.instance.collection('videos').snapshots().listen((qs) {
      final videos = mapQueryToVideoInfo(qs);
      callback(videos);
    });
  }

  static mapQueryToVideoInfo(QuerySnapshot qs) {
    return qs.docs.map((DocumentSnapshot ds) {
      final data = ds.data();
      return VideoInfo(
        videoUrl: data['videoUrl'],
        thumbUrl: data['thumbUrl'],
        coverUrl: data['coverUrl'],
        aspectRatio: data['aspectRatio'],
        videoName: data['videoName'],
        uploadedAt: data['uploadedAt'],
        finishedProcessing: data['finishedProcessing'] == true,
        uploadComplete: data['uploadComplete'] == true,
        uploadUrl: data['uploadUrl'],
        rawVideoPath: data['rawVideoPath'],
      );
    }).toList();
  }*/
}
