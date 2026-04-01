// ignore_for_file: public_member_api_docs

import 'package:digiguru/app/video/model/upload_item.dart';
import 'package:flutter/material.dart';

import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:light_compressor/light_compressor.dart';

typedef CancelUploadCallback = Future<void> Function(String id);

class UploadItemView extends StatelessWidget {
  final UploadItem? item;
  final CancelUploadCallback? onCancel;

  UploadItemView({
    Key? key,
    required this.item,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Visibility(
                visible: true, //!_isVideoCompressed,
                child: StreamBuilder<dynamic>(
                  stream:
                      LightCompressor().onProgressUpdated,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.data != null && snapshot.data > 0) {
                      return Column(
                        children: <Widget>[
                          Text(
                            'Compressing...',
                            style: const TextStyle(fontSize: 20),
                          ),
                          LinearProgressIndicator(
                            minHeight: 8,
                            value: snapshot.data / 100,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.data.toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              Text(
                item?.id ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontFamily: 'monospace'),
              ),
              Container(
                height: 5.0,
              ),
              Text(item?.status?.description ?? ''),
              // if (item.status == UploadTaskStatus.complete &&
              //     item.remoteHash != null)
              //   Builder(builder: (context) {
              //     return Column(
              //       mainAxisSize: MainAxisSize.min,
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         _compareMd5(item.path, item.remoteHash),
              //         _compareSize(item.path, item.remoteSize),
              //       ],
              //     );
              //   }),
              Container(height: 5.0),
              if (item?.status == UploadTaskStatus.running)
                LinearProgressIndicator(
                    value: (item!.uploadProgress?.toDouble() ?? 0) / 100),
              if (item?.status == UploadTaskStatus.complete ||
                  item?.status == UploadTaskStatus.failed) ...[
                Text('HTTP status code: ${item?.response?.statusCode}'),
                if (item?.response?.response != null)
                  Text(
                    item?.response?.response ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontFamily: 'monospace'),
                  ),
              ]
            ],
          ),
        ),
        if (item?.status == UploadTaskStatus.running)
          Container(
            height: 50,
            width: 50,
            child: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                if (item?.id != null) {
                  onCancel?.call(item!.id!);
                }
              },
            ),
          )
      ],
    );
  }

  // Text _compareMd5(String localPath, String remoteHash) {
  //   final File file = File(localPath);
  //   if (!file.existsSync()) {
  //     return Text(
  //       'File ƒ',
  //       style: TextStyle(color: Colors.grey),
  //     );
  //   }

  //   var digest = md5.convert(file.readAsBytesSync());
  //   if (digest.toString().toLowerCase() == remoteHash) {
  //     return Text(
  //       'Hash $digest √',
  //       style: TextStyle(color: Colors.green),
  //     );
  //   } else {
  //     return Text(
  //       'Hash $digest vs $remoteHash ƒ',
  //       style: TextStyle(color: Colors.red),
  //     );
  //   }
  // }

  // Text _compareSize(String localPath, int remoteSize) {
  //   final File file = File(localPath);
  //   if (!file.existsSync()) {
  //     return Text(
  //       'File ƒ',
  //       style: TextStyle(color: Colors.grey),
  //     );
  //   }

  //   final length = file.lengthSync();
  //   if (length == remoteSize) {
  //     return Text(
  //       'Length $length √',
  //       style: TextStyle(color: Colors.green),
  //     );
  //   } else {
  //     return Text(
  //       'Length $length vs $remoteSize ƒ',
  //       style: TextStyle(color: Colors.red),
  //     );
  //   }
  // }
}
