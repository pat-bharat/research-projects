import 'dart:io';

import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/shared_services/cloud_storage_service.dart';
import 'package:flutter/material.dart';

class SupabaseUploadItemView extends StatefulWidget {
  final String? title;
  final String? fileToUpload;
  final String? destPath;
  final Function? onComplete;

  const SupabaseUploadItemView({
    Key? key,
    this.title,
    required this.fileToUpload,
    required this.destPath,
    this.onComplete, required int progress, String? status, required Future<dynamic> Function() onCancel,
  }) : super(key: key);

  @override
  _SupabaseUploadItemViewState createState() => _SupabaseUploadItemViewState();
}

class _SupabaseUploadItemViewState extends State<SupabaseUploadItemView> {
  double? _progressPercent;
  bool _isUploading = false;
  bool _isSuccess = false;
  String? _error;

  Future<void> startUpload() async {
    if (widget.fileToUpload == null) return;
    setState(() {
      _isUploading = true;
      _progressPercent = null;
      _isSuccess = false;
      _error = null;
    });
    try {
      final file = File(widget.fileToUpload!);
      final service = CloudStorageService();
      // Supabase does not provide progress, so show indeterminate progress
      await service.uploadFile(
        fileToUpload: file,
        title: widget.destPath ?? file.path.split('/').last,
      );
      setState(() {
        _isUploading = false;
        _isSuccess = true;
        _progressPercent = 1.0;
      });
      if (widget.onComplete != null) widget.onComplete!();
    } catch (e) {
      setState(() {
        _isUploading = false;
        _isSuccess = false;
        _error = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startUpload();
  }

  @override
  Widget build(BuildContext context) {
    return commonContainer(
      context,
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(widget.title ?? ''),
              if (_isSuccess)
                IconButton(
                  icon: Icon(Icons.check),
                  iconSize: Theme.of(context).iconTheme.size,
                  onPressed: () {},
                ),
              if (_isUploading && !_isSuccess)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
          if (_isUploading && !_isSuccess)
            LinearProgressIndicator(value: _progressPercent),
          if (_isUploading && !_isSuccess)
            Text(_progressPercent == null
                ? 'Uploading...'
                : '${(_progressPercent! * 100).toStringAsFixed(2)} % '),
          if (_error != null)
            Text('Error: $_error', style: TextStyle(color: Colors.red)),
        ],
      ),
      drawBorder: false,
    );
  }
}
