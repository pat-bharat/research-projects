import 'dart:io';

//import 'package:digiguru/app/firebase_services/service/supabase_file_storage.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:filesize/filesize.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CloudStorageService {
  /*Future<CloudStorageResult> uploadFile({
    required File fileToUpload,
    required String title,
  }) async {
    //var imageFileName =   title; // + DateTime.now().millisecondsSinceEpoch.toString();

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(title);

    UploadTask uploadTask = firebaseStorageRef.putFile(fileToUpload);
  
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

    var downloadUrl = await taskSnapshot.ref.getDownloadURL();
    var s = taskSnapshot.totalBytes;
    String size = s > 0 ? filesize(s) : "0Kb";

    // if (uploadTask.isComplete) {
    //var url = downloadUrl;
    return CloudStorageResult(
      mediaUrl: downloadUrl,
      name: title,
      size: size,
    );
  }

  Future deleteFile(String fileName) async {
    if (fileName != null) {
      final Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);

      try {
        await firebaseStorageRef.delete();
        return true;
      } catch (e) {
        return e.toString();
      }
    }
  }
}
*/


  final SupabaseClient _client = Supabase.instance.client;

  Future<CloudStorageResult> uploadFile({
    required File fileToUpload,
    required String title,
    String bucket = 'public', // Default bucket name, change as needed
  }) async {
    final storage = _client.storage;
    final fileBytes = await fileToUpload.readAsBytes();
    final filePath = title;

try{
  await storage.from(bucket).uploadBinary(
      filePath,
      fileBytes,
      fileOptions: const FileOptions(upsert: true),
    );
} catch (e) {
      throw Exception('Failed to upload file: ${e.toString()}');
}
    
    
    final publicUrl = storage.from(bucket).getPublicUrl(filePath);
    final size = fileBytes.length > 0 ? filesize(fileBytes.length) : "0Kb";

    return CloudStorageResult(
      mediaUrl: publicUrl,
      name: title,
      size: size,
    );
  }

  Future deleteFile(String fileName, {String bucket = 'public'}) async {
    final storage = _client.storage;
    try {
      await storage.from(bucket).remove([fileName]);
      
      return true;
    } catch (e) {
      throw Exception('Failed to delete file: ${e.toString()}');
    }
  }

}

class CloudStorageResult {
  final String mediaUrl;
  final String name;
  final String size;

  CloudStorageResult({required this.mediaUrl, required this.name, required this.size});
}

