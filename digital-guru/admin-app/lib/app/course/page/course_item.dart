import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/constants/tooltips.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/background_image_page.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:flutter/material.dart';

class CourseItem extends StatelessWidget {
  final Course course;
  final Function? onDeleteItem;
  final Function? onEditItem;
  final Function? onEditModules;
  final Function? onViewDoc;
  final Function? onPlayVideo;
  final bool isAdmin;

  const CourseItem(
      {Key? key,
      required this.course,
      this.onDeleteItem,
      this.onEditItem,
      this.onEditModules,
      this.onViewDoc,
      this.onPlayVideo,
      this.isAdmin = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, //screenHeight(context) / 5,
      //margin: const EdgeInsets.only(top: 20),
      decoration: boxDecoration(context),
      //alignment: Alignment.center,
      child: BackgroundImageBox(
        url: course.background?.imageUrl ?? '',
        alignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(right: 10.0),
                //decoration: decorationUnderline(),
                child: buildWrappedText(
                  context,
                  course.title!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      buildWrappedText(
                        context,
                        course.instructorName!,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      buildWrappedText(
                          context,
                          Strings.total +
                              ' ' +
                              course.lessonCount.toString() +
                              ' ' +
                              Strings.lessons,
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text(course.language!,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  )),
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionIconsRow(context),
                    verticalSpaceTiny,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildActionIconsRow(BuildContext context) {
    if (!isAdmin) {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        course.courseVideo?.videoUrl != null
            ? IconButton(
                color: Theme.of(context).iconTheme.color,
                icon: Icon(Icons.play_arrow_sharp),
                tooltip: Tooltips.playVideo,
                onPressed: () {
                  if (onPlayVideo != null) {
                    onPlayVideo!();
                  }
                },
              )
            : Container(),
        course.courseDetailDoc?.docUrl != null
            ? IconButton(
                color: Theme.of(context).iconTheme.color,
                icon: Icon(
                  Icons.picture_as_pdf_sharp,
                ),
                tooltip: Tooltips.viewPdf,
                onPressed: () {
                  if (onViewDoc != null) {
                    onViewDoc!();
                  }
                },
              )
            : Container(),
        BusyButton(
          title: Strings.details,
          onPressed: () {
            if (onEditModules != null) {
              onEditModules!();
            }
          },
        ),
      ]);
    } else {
      return Row(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            /// color: Theme.of(context).iconTheme.color,
            icon: Icon(Icons.delete),
            tooltip: Tooltips.deleteCourse,
            onPressed: () {
              if (onDeleteItem != null) {
                onDeleteItem!();
              }
            },
          ),
          IconButton(
            // color: Theme.of(context).iconTheme.color,
            icon: Icon(Icons.edit),
            // tooltip: Tooltips.editCourse,
            onPressed: () {
              if (onEditItem != null) {
                onEditItem!();
              }
            },
          ),
          BusyButton(
            title: Strings.details,
            onPressed: () {
              if (onEditModules != null) {
                onEditModules!();
              }
            },
          ),
        ],
      );
    }
  }
}
