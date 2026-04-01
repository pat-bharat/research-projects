import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/lesson/page/lesson_item.dart';
import 'package:digiguru/app/lesson/service/lesson_service.dart';
import 'package:digiguru/app/user/model/trial_user_module_view_list_model..dart';
import 'package:digiguru/app/user/model/user_module.dart';
import 'package:digiguru/app/user/model/purchased_user_module_view_list_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TrialUserModuleListView extends StatefulWidget {
  //final List<Course> courses = new List();
  final bool isFree;
  TrialUserModuleListView({Key? key, this.isFree = true}) : super(key: key);

  @override
  _TrialUserModuleListViewState createState() =>
      _TrialUserModuleListViewState();
}

class _TrialUserModuleListViewState extends State<TrialUserModuleListView> {
  LessonService _lessonService = locator<LessonService>();
  late TrialUserModuleListModel model;
  List<UserModule> userModules = List.empty(growable: true);
  bool isFree = false;
  @override
  void initState() {
    model = TrialUserModuleListModel();
    isFree = true;
    // getUserModules(model);
    super.initState();
  }

  Future getUserModules(TrialUserModuleListModel model) async {
    List<UserModule> _um = List.empty(growable: true);

    if (isFree != null && isFree) {
      // await model.loadFreeModule().then((value) => _um.addAll(value));
    }
    setState(() {
      if (isFree) {
        //this.userModules = _um;
      }
      /*else {
        this.userModules = _umPurchased;
      }*/
    });
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return ViewModelBuilder<TrialUserModuleListModel>.reactive(
        viewModelBuilder: () => model,
        onModelReady: (model) => model.listenToFreeUserModule(),
        // widget.isFree ?  : ,
        builder: (context, model, child) => SafeArea(
                child: CommonScaffold(
              model: model,
              appTitle: (isFree ? Strings.trialLessons : Strings.myModules),
              bottomNavBarIndex: 3,
              bodyData: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (model.showMainBanner) buildRemoteConfigContainer(),
                  Expanded(
                    child: userModules != null
                        ? new ListView(
                            //padding: const EdgeInsets.all(5),
                            children: _buildUserModules(context, model),
                          )
                        : Center(
                            child: Text(
                              Strings.noFreeLessonsOffered,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                  ),
                  // buildBottomActionBar(model)
                ],
              ),
            body: Center(),)));
  }

  _buildUserModules(BuildContext context, TrialUserModuleListModel model) {
    List<Widget> widgets = List.empty(growable: true);

    for (final um in model.userModules) {
      List<Widget> lessons = List.empty(growable: true);
      // for (final ci in um.courseInfo) {
      // lessons.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: []));
      if (um.lessons != null) {
        for (final lesson in um.lessons!) {
          lessons.add(_buildLessonCard(lesson, model));
          lessons.add(verticalSpaceTiny);
        }
      }

      widgets.add(buildScorabbleAccordian(context,
          headChildren: [
            buildWrappedText(
              context,
              um.moduleTitle ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            buildWrappedText(
                context, um.courseName! + " By " + um.instructorName!,
                lines: 2, style: Theme.of(context).textTheme.bodySmall),
          ],
          bodyChildren: lessons));

      /* widgets.add(GFAccordion(
        showAccordion: true,
        title: um.moduleTitle,
        contentPadding: const EdgeInsets.all(5),
        textStyle: Theme.of(context).textTheme.headline3,
        collapsedTitleBackgroundColor: Theme.of(context).backgroundColor,
        contentBackgroundColor: Theme.of(context).backgroundColor,
        contentChild: Column(
            mainAxisAlignment: MainAxisAlignment.start, children: lessons),
      ));*/

      /* widgets.add(Container(
          color: Theme.of(context).canvasColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                um.moduleTitle,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                um.courseName + " By " + um.instructorName,
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          )

          //color: Colors.grey,
          ));
      for (final lesson in um.lessons) {
        widgets.add(_buildLessonCard(lesson, model));
        widgets.add(verticalSpaceTiny);
      }*/
    }

    return widgets;
  }

  Container _buildLessonCard(Lesson item, TrialUserModuleListModel model) {
    return Container(
      child: GestureDetector(
        // onTap: () => model.editCourse(index),
        child: LessonItem(
          isAdmin: model.isAdmin,
          lesson: item,
          onPlayVideo: () => model.viewVideo(item.videoInfo!),
          onViewDoc: () => model.viewPdf(item.instructionDoc!.docUrl!),
        ),
      ),
    );
  }
}
