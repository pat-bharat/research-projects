import 'package:image_picker/image_picker.dart';

import 'package:file_picker/file_picker.dart';

class MediaSelector {
  Future<XFile?> selectImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future<FilePickerResult?> selectVideo() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'avi', 'mpeg', 'mkv', 'wmv'],
    );
  }

  Future<FilePickerResult?> selectDocument() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'pdf', 'txt'],
    );
  }
}
