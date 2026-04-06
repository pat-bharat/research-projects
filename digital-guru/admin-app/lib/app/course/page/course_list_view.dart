import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/widget/bottom_nav_bar.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/my_reorderable_list.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/course/page/course_item.dart';
import 'package:digiguru/app/common/widget/creation_aware_list_item.dart';
import 'package:digiguru/app/course/model/course_list_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CourseListView extends StatefulWidget {
  //final List<Course> courses = new List();
  CourseListView({Key? key}) : super(key: key);

  @override
  _CourseListViewState createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return ViewModelBuilder<CourseListModel>.reactive(
      viewModelBuilder: () => CourseListModel(),
      onViewModelReady: (model) => model.listenToCourses(),
      builder: (context, model, child) => SafeArea(
          child: CommonScaffold(
        model: model,
        appTitle: Strings.courseTitle,
        showBottomNav: model.isAdmin,
        bottomNavBarIndex: 1,
        body: Center(),
        bodyData: Padding(
          padding: listPadding,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //_buildTitleRow(model),
              //verticalSpace(5),
              if (model.showMainBanner) _buildRemoteConfigBanner(context),
              Expanded(
                  child: model.courses != null
                      ? ReorderableListView(
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              model.courses.insert(
                                  newIndex, model.courses.removeAt(oldIndex));
                            });
                          },
                          children: <Widget>[
                            for (final item in model.courses)
                              _buildCourseItemCard(model, item),
                          ],
                        )
                      : Center(
                          child: !model.busy
                              ? Text(
                                  Strings.addCourse,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                )
                              : Container(),
                        )),
              _buildBottomButtonRaw(model),
            ],
          ),
        ),
      )),
    );
  }

  _buildTitleRow(CourseListModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          height: 30,
          child: Image.asset('assets/images/title.png'),
        ),
        horizontalSpaceMedium
      ],
    );
  }

  _buildRemoteConfigBanner(BuildContext coontext) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: boxDecoration(context),
        alignment: Alignment.center,
        child: Text(
          'Banner from remote Config',
          textAlign: TextAlign.center,
        ));
  }

  _buildBottomButtonRaw(CourseListModel model) {
    if (model.isAdmin && !model.busy)
      return Column(children: [
        verticalSpaceTiny,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BusyButton(
                title: Strings.btnAddCourse,
                onPressed: () => {model.navigateToAddCourse()}),
            horizontalSpaceSmall,
            BusyButton(
                title: Strings.saveCourseOrder,
                onPressed: () => {model.saveCoursesDisplayOrder(model.courses)})
          ],
        ),
        verticalSpaceTiny,
      ]);
    return Container();
  }

  _buildCourseItemCard(CourseListModel model, Course item) {
    return Card(
      //color: Colors.blueGrey,
      key: ValueKey(item.id),
      elevation: 2,
      child: CreationAwareListItem(
        itemCreated: () {
          if (model.courses.indexOf(item) % 20 == 0) model.requestMoreData();
        },
        child: GestureDetector(
          // onTap: () => model.editCourse(index),
          child: CourseItem(
            isAdmin: model.isAdmin,
            course: model.courses[model.courses.indexOf(item)],
            onDeleteItem: () => model.deleteCourse(course: item),
            onEditItem: () => model.editCourse(item),
            onEditModules: () => model.editModules(item),
            onViewDoc: item.courseDetailDoc?.docUrl != null ? () => model.viewPdf(item.courseDetailDoc!.docUrl!) : null,
            onPlayVideo: item.courseVideo != null ? () => model.viewVideo(item.courseVideo!) : null,
          ),
        ),
      ),
    );
  }
}
