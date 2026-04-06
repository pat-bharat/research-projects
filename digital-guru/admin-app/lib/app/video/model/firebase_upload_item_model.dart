import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/video/model/firebase_upload_item.dart';
import 'package:digiguru/app/video/page/supabase_upload_item_view.dart';
import 'package:digiguru/app/video/service/media_upload_service.dart';

class FirebaseUploadItemModel extends BaseModel {
  MediaUploadService uplaodService = MediaUploadService();

  void addUploadItem(SupabaseUploadItem item) {
    assert(item != null);
    uplaodService.addUploadItem(item);
    notifyListeners();
  }

  void removeUploadItem(SupabaseUploadItem title) {
    assert(title != null);
    uplaodService.removeUploadItem(title);
    notifyListeners();
  }

  void clearCompletedTasks() {
    uplaodService.clearCompletedTasks();
    notifyListeners();
  }
}
