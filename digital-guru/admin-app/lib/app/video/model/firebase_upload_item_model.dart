import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/video/model/firebase_upload_item.dart';
import 'package:digiguru/app/video/service/media_upload_service.dart';

class FirebaseUploadItemModel extends BaseModel {
  MediaUploadService uploadService = MediaUploadService();

  void addUploadItem(SupabaseUploadItem item) {
    uploadService.addUploadItem(item);
    notifyListeners();
  }

  void removeUploadItem(SupabaseUploadItem title) {
    uploadService.removeUploadItem(title);
    notifyListeners();
  }

  void clearCompletedTasks() {
    uploadService.clearCompletedTasks();
    notifyListeners();
  }
}
