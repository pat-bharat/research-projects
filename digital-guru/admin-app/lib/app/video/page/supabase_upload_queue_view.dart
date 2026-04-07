// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/video/model/firebase_upload_item.dart';
import 'package:digiguru/app/video/model/upload_queue_view_model.dart';
import 'package:digiguru/app/video/page/supabase_upload_item_view.dart';
import 'package:digiguru/app/video/page/supabase_upload_item_view.dart';
import 'package:digiguru/app/video/service/media_upload_service.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_uploader/flutter_uploader.dart';
//import 'package:light_compressor/light_compressor.dart';
import 'package:stacked/stacked.dart';

/// Shows the statusresponses for previous uploads.
class SupabaseUploadQueueView extends StatefulWidget {
  SupabaseUploadQueueView({Key? key}) : super(key: key);

  @override
  _SupabaseUploadQueueViewState createState() => _SupabaseUploadQueueViewState();
}

class _SupabaseUploadQueueViewState extends State<SupabaseUploadQueueView> {
  late List<SupabaseUploadItem> _tasks;
  late UploadQueueViewModel model;
  @override
  void initState() {
    super.initState();
    model = UploadQueueViewModel();
    _tasks = model.uploadItems;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UploadQueueViewModel>.reactive(
      viewModelBuilder: () => model,
      onViewModelReady: (model) => model.listendToUpload(),
      builder: (context, model, child) => SafeArea(
          child: CommonScaffold(
        model: model,
        showDrawer: model.isAdmin,
        appTitle: Strings.uploadQueue,
        showBottomNav: true,
        bodyData: Padding(
          padding: listPadding,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //_buildTitleRow(model),
              //verticalSpace(5),
              Expanded(
                  child:
                      model.uploadItems.length > 0
                          ? ListView(
                              children: <Widget>[
                                for (final item in model.uploadItems)
                                  buildUploadItem(model, item),
                              ],
                            )
                          : Center(
                              child: Text(
                                "No upload Item Found..",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            )),
            ],
          ),
        ),
        body: Center(),
      )),
    );
  }

  SupabaseUploadItemView buildUploadItem(
      UploadQueueViewModel model, SupabaseUploadItem item) {
    return SupabaseUploadItemView(
      title: item.title,
      fileToUpload: item.fileToUpload,
      destPath: item.destPath,
      progress: item.uploadProgress ?? 0,
      status: item.status,
      onCancel: () => _cancelUpload(item),
    );
  }

  Future _cancelUpload(SupabaseUploadItem item) async {
    // Mark the upload as cancelled in your model/service
    model.cancelUpload(item);
    setState(() {});
  }
}
