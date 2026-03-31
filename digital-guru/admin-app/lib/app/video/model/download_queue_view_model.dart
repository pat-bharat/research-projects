import 'package:digiguru/app/common/model/base_model.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadQueueViewModel extends BaseModel {
  DownloadQueueViewModel();
}

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String name;
  final _TaskInfo task;

  _ItemHolder({this.name, this.task});
}
