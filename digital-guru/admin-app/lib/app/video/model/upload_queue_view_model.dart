import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/video/model/firebase_upload_item.dart';
import 'package:digiguru/app/video/service/media_upload_service.dart';

class UploadQueueViewModel extends BaseModel {
  List<FirebaseUploadItem> uploadItems;

  MediaUploadService uploadService = locator<MediaUploadService>();
  UploadQueueViewModel();
  void listendToUpload() {
    setBusy(true);
    uploadItems = MediaUploadService.tasks;
    notifyListeners();
    setBusy(false);
    /*uploadService.listenToUploadItems().listen((items) {
      List<FirebaseUploadItem> _uploads = items;
      if (_uploads != null && _uploads.length > 0) {
        uploadItems = _uploads;
       
      }
      
    });*/
  }
}
