import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/util/general.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/video/model/video_info.dart';
import 'package:digiguru/app/video/page/download_queue_view.dart';
import 'package:flutter/material.dart';

class LessonItem extends StatelessWidget {
  final Lesson lesson;
  final Function? onDeleteItem;
  final Function? onEditItem;
  final Function? onDownload;
  final Function? onViewDoc;
  final Function? onPlayVideo;
  final bool isAdmin;
  const LessonItem(
      { Key? key,
      required this.lesson,
      this.onDeleteItem,
      this.onEditItem,
      this.onDownload,
      required this.isAdmin,
      this.onViewDoc,
      this.onPlayVideo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: lesson.videoInfo != null ? null : 75,
      // margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: _buildLessonPanel(context, lesson),
    );
  }

  _buildLessonPanel(BuildContext context, Lesson lesson) {
    return GestureDetector(
      onTap: () {
        if (onPlayVideo != null) {
          onPlayVideo!();
        }
      },
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        padding: EdgeInsets.all(5.0),
        height: 85, //screenHeight(context) / 8,
        decoration: boxDecoration(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            lesson.videoInfo != null && lesson.videoInfo!.thumbUrl != null
                ? Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: buildCachedNetworkCacheImage(
                            context, lesson.videoInfo!.thumbUrl!),
                      ),
                      Container(
                          color: Colors.grey[800],
                          child: Text(
                            computeDuration(lesson.videoInfo!.duration!),
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.fontSize,
                                color: Colors.white),
                          ))
                    ],
                  )
                : SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.asset(
                      'assets/images/background.png',
                      fit: BoxFit.fill,
                    )),
            SizedBox(width: 10.0),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  buildWrappedText(context, lesson.title ?? '', lines: 2),
                  buildWrappedText(context, lesson.instructorNotes ?? '',
                      lines: 2, style: Theme.of(context).textTheme.headlineSmall),
                ])),
            isAdmin
                ? _builldAdminActionButtons(context, lesson)
                : _builldUserActionButtons(context, lesson),
          ],
        ),
      ),
    );
  }

  _builldAdminActionButtons(BuildContext context, Lesson lesson) {
    if (lesson.videoInfo != null && lesson.videoInfo!.youtube != null && lesson.videoInfo!.youtube!) {
      return Container();
    }
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.delete),
              iconSize: Theme.of(context).iconTheme.size,
              onPressed: () {
                if (onDeleteItem != null) {
                  onDeleteItem!();
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              iconSize: Theme.of(context).iconTheme.size,
              onPressed: () {
                if (onEditItem != null) {
                  onEditItem!();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  _builldUserActionButtons(BuildContext context, Lesson lesson) {
    if (lesson.videoInfo != null && lesson.videoInfo!.youtube != null && lesson.videoInfo!.youtube!) {
      return Container();
    }
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            lesson.freeTrial != null && !lesson.freeTrial!
                ? IconButton(
                    icon: Icon(Icons.lock_sharp),
                    iconSize: Theme.of(context).iconTheme.size,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Please purchase Module to view this lesson"),
                      ));
                    },
                  )
                : Container(),
            lesson.instructionDoc != null &&
                    lesson.instructionDoc!.docUrl != null
                ? IconButton(
                    icon: Icon(Icons.picture_as_pdf_sharp),
                    iconSize: Theme.of(context).iconTheme.size,
                    onPressed: () {
                      if (onViewDoc != null) {
                        onViewDoc!();
                      }
                    },
                  )
                : Container(),
            lesson.videoInfo != null && lesson.videoInfo!.videoUrl != null
                ? IconButton(
                    icon: Icon(Icons.play_arrow_sharp),
                    iconSize: Theme.of(context).iconTheme.size,
                    onPressed: () {
                      if (onPlayVideo != null) {
                        onPlayVideo!();
                      }
                    },
                  )
                : Container(),
            lesson.videoInfo != null && lesson.videoInfo!.videoUrl != null
                ? IconButton(
                    icon: Icon(Icons.download_rounded),
                    iconSize: Theme.of(context).iconTheme.size,
                    onPressed: () {
                      if (onDownload != null) {
                        onDownload!();
                      }
                    },
                  )
                : Container()
          ],
        ),
      ],
    );
  }
}
