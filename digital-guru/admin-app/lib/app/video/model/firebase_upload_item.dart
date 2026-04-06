import 'package:equatable/equatable.dart';

class SupabaseUploadItem extends Equatable {
  final String? title;
  final int? uploadProgress; // 0-100
  final String? status; // e.g., 'pending', 'uploading', 'success', 'error'
  final String? fileToUpload;
  final String? destPath;
  final String? supabaseUrl;
  final String? errorMessage;
  final Function? onComplete;

  const SupabaseUploadItem(
    this.title, {
    required this.fileToUpload,
    required this.destPath,
    this.uploadProgress,
    this.status,
    this.supabaseUrl,
    this.errorMessage,
    this.onComplete,
  });

  SupabaseUploadItem copyWith({
    String? title,
    int? uploadProgress,
    String? status,
    String? fileToUpload,
    String? destPath,
    String? supabaseUrl,
    String? errorMessage,
    Function? onComplete,
  }) {
    return SupabaseUploadItem(
      title ?? this.title,
      fileToUpload: fileToUpload ?? this.fileToUpload,
      destPath: destPath ?? this.destPath,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      status: status ?? this.status,
      supabaseUrl: supabaseUrl ?? this.supabaseUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      onComplete: onComplete ?? this.onComplete,
    );
  }

  @override
  List<Object?> get props => [
        title,
        uploadProgress,
        status,
        fileToUpload,
        destPath,
        supabaseUrl,
        errorMessage,
      ];
}
