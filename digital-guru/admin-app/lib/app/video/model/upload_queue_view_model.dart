import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/video/model/firebase_upload_item.dart';
import 'package:digiguru/app/video/service/media_upload_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadQueueViewModel extends BaseModel {
  late List<SupabaseUploadItem> uploadItems;
  MediaUploadService uploadService = locator<MediaUploadService>();
  final Map<String, StreamController<double>> _progressControllers = {};
  final Map<String, bool> _cancelled = {};

  UploadQueueViewModel();

  void listendToUpload() {
    setBusy(true);
    uploadItems = MediaUploadService.tasks;
    notifyListeners();
    setBusy(false);
  }

  Stream<double>? getProgressStream(SupabaseUploadItem item) {
    if (_progressControllers.containsKey(item.fileToUpload)) {
      return _progressControllers[item.fileToUpload]!.stream;
    }
    return null;
  }

  void startUpload(SupabaseUploadItem item) async {
    final file = item.fileToUpload;
    if (file == null) return;
    final controller = StreamController<double>.broadcast();
    _progressControllers[file] = controller;
    _cancelled[file] = false;
    int sent = 0;
    final f = File(file);
    final total = await f.length();
    final supabase = Supabase.instance.client;
    final stream = f.openRead().transform<List<int>>(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          if (_cancelled[file] == true) return;
          sent += data.length;
          controller.add(sent / total);
          sink.add(data);
        },
      ),
    );
    try {
      await supabase.storage.from('your-bucket').uploadBinary(
        
          item.destPath!, 
          stream as Uint8List, 
          retryAttempts: 2,
          retryController: StorageRetryController(),
          fileOptions: FileOptions(contentType: 'application/octet-stream')
      );
      controller.add(1.0);
    } catch (e) {
      controller.addError(e);
    }
    await controller.close();
    notifyListeners();
  }

  void cancelUpload(SupabaseUploadItem item) {
    final file = item.fileToUpload;
    if (file == null) return;
    _cancelled[file] = true;
    _progressControllers[file]?.close();
    notifyListeners();
  }
}

