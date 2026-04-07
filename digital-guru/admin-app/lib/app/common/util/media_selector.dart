  import 'package:file_selector/file_selector.dart';

class MediaSelector {
  Future<XFile?> selectImage() async {
    return await openFile(
      acceptedTypeGroups: [
        XTypeGroup(
          label: 'images',
          extensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
        ),
      ],
    );
  }

  Future<XFile?> selectVideo() async {
    return await openFile(
      acceptedTypeGroups: [
        XTypeGroup(
          label: 'videos',
          extensions: ['mp4', 'avi', 'mpeg', 'mkv', 'wmv'],
        ),
      ],
    );
  }

  Future<XFile?> selectDocument() async {
    return await openFile(
      acceptedTypeGroups: [
        XTypeGroup(
          label: 'documents',
          extensions: ['mp3', 'pdf', 'txt'],
        ),
      ],
    );
  }

  Future<List<XFile>?> selectMultipleFiles() async {
    return await openFiles(      
      acceptedTypeGroups: [
        XTypeGroup(
          label: 'documents',
          extensions: ['mp3', 'pdf', 'txt'],
        ),
      ],
    );
  }

  retrieveLostData() {
    // This is a workaround for Android's file picker losing data when the app is killed in the background.
    // The file_selector package does not have a built-in method for this, so you would need to implement platform-specific code to handle it.
    // For simplicity, this method is left as a placeholder. You would need to implement the actual logic to retrieve lost data on Android.
  }
}
