import 'dart:io';
import 'package:digiguru/app/common/constants/media_types.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:flutter/material.dart';

class MediaTile extends StatelessWidget {
  //final bool isReadOnly;
  final String? label;
  final File? localFile;
  final String? mediaLink;
  final bool? isEditing;
  final double? height;
  final double? width;
  final Function? onTap;
  final Function? onDelete;
  final Function? onView;
  final String? mediaType;

  MediaTile(
      {this.label,
      this.localFile,
      this.mediaLink,
      required this.mediaType,
      required this.isEditing,
      this.height = 100,
      this.width = 100,
      required this.onTap,
      this.onDelete,
      this.onView});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (label != null && label!.length > 0) Text(label!),
        GestureDetector(
          // When we tap we call selectImage
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              // If the selected image is null we show "Tap to add post image"
              child: computeWidget(context)),
        ),
        Row(
          children: [
            if (onDelete != null && (mediaLink?.length ?? 0) > 0)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  if ((mediaLink?.length ?? 0) > 0 &&
                      onDelete != null) {
                    onDelete!();
                  }
                },
              ),
            if ((mediaLink?.length ?? 0) > 0)
              IconButton(
                icon: Icon(Icons.visibility),
                onPressed: () {
                  if (mediaLink != null &&
                      mediaLink!.length > 0 &&
                      onView != null) {
                    onView!();
                  }
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget computeWidget(BuildContext context) {
    if (isEditing ?? false) {
      // editing but not changedimage
      if (localFile != null) {
        // picked new file
        if (mediaType == MediaTypes.IMAGE) {
          return Container(child: Image.file(localFile!));
        } else if (mediaType == MediaTypes.VIDEO) {
          // if ((mediaLink != null && mediaLink.length > 0)) {
          return Container(
              child: Image.asset(
            'assets/images/video_icon.png',
            fit: BoxFit.fill,
          ));
          // } else {
          //  return Container(
          //    child: Text(localFile.toString()),
          // );
          // }
        } else {
          return Container(
              child: Image.asset(
            'assets/images/pdf_icon.png',
            fit: BoxFit.fill,
          ));
        }
      } else if ((mediaLink != null && mediaLink!.length > 0)) {
        if (mediaType == MediaTypes.IMAGE || mediaType == MediaTypes.VIDEO) {
          return SizedBox(
              //height: 80,
              child: buildCachedNetworkCacheImage(context, mediaLink!)
              /*  CachedNetworkImage(
            imageUrl: mediaLink,
            fit: BoxFit.fill,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )*/
              );
        } else {
          return Container(
              child: Image.asset(
            'assets/images/pdf_icon.png',
            fit: BoxFit.fill,
          ));
        }
      } else {
        return Text(
          'Tap to Add ' + (label ?? ""),
          style: TextStyle(color: Colors.black87, fontSize: 12),
        );
      }
    } else {
      if (localFile != null) {
        // picked new file
        if (mediaType == MediaTypes.IMAGE) {
          return Container(child: Image.file(localFile!));
        } else {
          return Container(child: Text(localFile.toString()));
        }
      } else {
        return Text(
          'Tap to Add ' + (label ?? ""),
          style: TextStyle(color: Colors.grey[400], fontSize: 15),
        );
      }
    }
  }
}
