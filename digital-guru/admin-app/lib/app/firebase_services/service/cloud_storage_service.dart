import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:filesize/filesize.dart';

class CloudStorageService {
  Future<CloudStorageResult> uploadFile({
    @required File fileToUpload,
    @required String title,
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

class CloudStorageResult {
  final String mediaUrl;
  final String name;
  final String size;

  CloudStorageResult({this.mediaUrl, this.name, this.size});
}
