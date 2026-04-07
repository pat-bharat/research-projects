import 'package:digiguru/app/common/util/general.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:flutter/material.dart';

class LessonItem extends StatelessWidget {
  final Lesson? lesson;
  final Function? onDeleteItem;
  final Function? onEditItem;
  final Function? onView;
  final bool? isAdmin;
  const LessonItem(
      {Key? key,
      this.lesson,
      this.onDeleteItem,
      this.onEditItem,
      this.isAdmin,
      this.onView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: lesson?.videoInfo != null ? null : 60,
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: _buildLessonPanel(context, lesson),
    );
  }

  _buildLessonPanel(BuildContext context, Lesson? lesson) {
    return GestureDetector(
      onTap: () {
        if (onView != null) {
          onView!();
        }
      },
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        // padding: EdgeInsets.all(5.0),
        height: screenHeight(context) / 8,
        decoration: boxDecoration(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            lesson?.videoInfo?.thumbUrl != null
                ? Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: buildCachedNetworkCacheImage(
                            context, lesson!.videoInfo!.thumbUrl!),
                        /*CachedNetworkImage(
                      imageUrl: lesson.videoInfo.thumbUrl,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),*/
                      ),
                      Text(
                        computeDuration(lesson.videoInfo!.duration!),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  )
                : SizedBox(
                    height: 70,
                    width: 70,
                    child: Image.asset(
                      'assets/images/background.png',
                      fit: BoxFit.fill,
                    )),
            SizedBox(width: 10.0),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Text(
                  lesson?.title ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: Text(
                  lesson?.instructorNotes ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            ]),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      iconSize: 15,
                      onPressed: () {
                        if (onDeleteItem != null) {
                          onDeleteItem!();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      iconSize: 15,
                      onPressed: () {
                        if (onEditItem != null) {
                          onEditItem!();
                        }
                      },
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
