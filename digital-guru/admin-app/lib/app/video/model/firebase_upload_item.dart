// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUploadItem extends Equatable {
  final String? title;
  final int? uploadProgress;
  final TaskState? status;
  final String? fileToUpload;
  final String? destPath;
  final Function? onComplete;

  /// Store the entire response object.
  final UploadTask? uploadTask;

  const FirebaseUploadItem(this.title,
      {required this.fileToUpload,
      required this.destPath,
      this.uploadProgress,
      this.status,
      this.uploadTask,
      this.onComplete});

  FirebaseUploadItem copyWith(
      {String? title,
      int? progress,
      TaskState? status,
      UploadTask? uploadTask,
      String? fileToUpload,
      String? destPath}) {
    return FirebaseUploadItem(
      title ?? this.title,
      uploadProgress: progress ?? this.uploadProgress,
      status: status ?? this.status,
      uploadTask: uploadTask ?? this.uploadTask,
      fileToUpload: fileToUpload ?? this.fileToUpload,
      destPath: destPath ?? this.destPath,
    );
  }

  bool isCompleted() =>
      status == TaskState.canceled ||
      status == TaskState.success ||
      status == TaskState.error;

  @override
  List<Object?> get props {
    return [title, uploadProgress, status, uploadTask, fileToUpload, destPath];
  }
}
