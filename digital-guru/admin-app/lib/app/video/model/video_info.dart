class VideoInfo {
  String title;
  String videoUrl;
  String thumbUrl;
  String videoSize;
  bool finishedPrcessing;
  bool uploadUrl;
  String rawVideoPath;
  bool uploadComplete;
  String duration;
  bool youtube;

  VideoInfo(
      {this.title,
      this.videoUrl,
      this.thumbUrl,
      this.videoSize,
      this.finishedPrcessing,
      this.uploadUrl,
      this.rawVideoPath,
      this.uploadComplete,
      this.duration,
      this.youtube = false});

  VideoInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    videoUrl = json['video_url'];
    thumbUrl = json['thumb_url'];
    videoSize = json['video_size'];
    finishedPrcessing = json['finished_prcessing'];
    uploadUrl = json['upload_url'];
    rawVideoPath = json['raw_video_path'];
    uploadComplete = json['upload_complete'];
    duration = json['duration'].toString();
    youtube = json['youtube'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['video_url'] = this.videoUrl;
    data['thumb_url'] = this.thumbUrl;
    data['video_size'] = this.videoSize;
    data['finished_prcessing'] = this.finishedPrcessing;
    data['upload_url'] = this.uploadUrl;
    data['raw_video_path'] = this.rawVideoPath;
    data['upload_complete'] = this.uploadComplete;
    data['duration'] = this.duration;
    data['youtube'] = this.youtube;
    return data;
  }
}
