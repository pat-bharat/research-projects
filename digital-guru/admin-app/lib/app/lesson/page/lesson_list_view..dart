import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/top_navigation_bar.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/creation_aware_list_item.dart';
import 'package:digiguru/app/lesson/page/lesson_item.dart';
import 'package:digiguru/app/common/widget/my_reorderable_list.dart';
import 'package:digiguru/app/lesson/model/lesson_view_list_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LessonListView extends StatefulWidget {
  //final List<Course> courses = new List();
  final Module module;
  final Course course;
  LessonListView({Key? key, required this.course, required this.module}) : super(key: key);

  @override
  _LessonListViewState createState() => _LessonListViewState();
}

class _LessonListViewState extends State<LessonListView> {
  late Module module;
  late Course course;
  late LessonListModel model;

  @override
  void initState() {
    super.initState();
    module = widget.module;
    model = LessonListModel(course: widget.course, module: widget.module);
    model.listenToLessons();
  }

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return ViewModelBuilder<LessonListModel>.reactive(
        viewModelBuilder: () => model,
        //onModelReady: (model) => ,
        builder: (context, model, child) => SafeArea(
                child: CommonScaffold(
              appTitle: Strings.lessons,
              model: model,
              showDrawer: false,
              showBottomNav: model.isAdmin,
              bodyData: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  //mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (model.showMainBanner) buildRemoteConfigContainer(),
                    Expanded(
                        child: model.lessons != null
                            ? new ReorderableListView(
                                onReorder: (int oldIndex, int newIndex) {
                                  setState(() {
                                    if (newIndex > oldIndex) {
                                      newIndex -= 1;
                                    }
                                    model.lessons.insert(newIndex,
                                        model.lessons.removeAt(oldIndex));
                                  });
                                },
                                children: <Widget>[
                                  //List<Module> modules = model.modules;
                                  for (final item in model.lessons)
                                    _buildLessonCard(context, item, model),
                                ],
                              )
                            : Center(
                                child: Text(
                                  Strings.pleaseAddLessons,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              )),
                    _buildBottomActionBar(model)
                  ],
                ),
              ),
            body: Center(),)));
  }

  Row _buildBottomActionBar(LessonListModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BusyButton(
            title: Strings.btnAddLesson,
            onPressed: () => {model.navigateToAddLessonToModule()}),
        horizontalSpaceMedium,
        BusyButton(
            title: Strings.btnLessonLessonOrder,
            onPressed: () => {model.saveLessonDisplayOrder(model.lessons)}),
        verticalSpaceMedium
      ],
    );
  }

  Card _buildLessonCard(
      BuildContext context, Lesson item, LessonListModel model) {
    bool youtube = item.videoInfo!.youtube ?? false;
    if (!youtube) {
      return Card(
        //color: Colors.blueGrey,
        key: ValueKey(item.id),
        elevation: 2,
        child: CreationAwareListItem(
          itemCreated: () {
            if (model.lessons.indexOf(item) % 20 == 0) model.requestMoreData();
          },
          child: GestureDetector(
            // onTap: () => model.editCourse(index),
            child: LessonItem(
              key: ValueKey(item.id),
              isAdmin: model.isAdmin,
              lesson: item,
              onDeleteItem: () => model.deleteLesson(item),
              onEditItem: () => model.editLesson(item),
              onPlayVideo: () => model.viewVideo(item.videoInfo!),
              onViewDoc: () => model.viewPdf(item.instructionDoc!.docUrl!),
              onDownload: () {
                model.downloadVideo(item.videoInfo!);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(Strings.addedToQueue)));
              },
            ),
          ),
        ),
      );
    } else {
      return Card(
        //color: Colors.blueGrey,
        key: ValueKey(item.id),
        elevation: 2,
        child: CreationAwareListItem(
          itemCreated: () {
            if (model.lessons.indexOf(item) % 20 == 0) model.requestMoreData();
          },
          child: GestureDetector(
            // onTap: () => model.editCourse(index),
            child: LessonItem(
              key: ValueKey(item.id),
              isAdmin: model.isAdmin,
              lesson: item,
              onPlayVideo: () => model.viewVideo(item.videoInfo!),
            ),
          ),
        ),
      );
    }
  }
}
