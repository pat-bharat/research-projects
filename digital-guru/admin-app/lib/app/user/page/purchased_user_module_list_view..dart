import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/lesson/page/lesson_item.dart';
import 'package:digiguru/app/lesson/service/lesson_service.dart';
import 'package:digiguru/app/user/model/user_module.dart';
import 'package:digiguru/app/user/model/purchased_user_module_view_list_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PurchasedUserModuleListView extends StatefulWidget {
  //final List<Course> courses = new List();

  PurchasedUserModuleListView({Key key}) : super(key: key);

  @override
  _PurchasedUserModuleListViewState createState() =>
      _PurchasedUserModuleListViewState();
}

class _PurchasedUserModuleListViewState
    extends State<PurchasedUserModuleListView> {
  LessonService _lessonService = locator<LessonService>();
  PurchasedUserModuleListModel model;
  List<UserModule> userModules = List.empty(growable: true);
  bool isFree = false;
  @override
  void initState() {
    model = PurchasedUserModuleListModel();
    getUserModules(model);
    super.initState();
  }

  Future getUserModules(PurchasedUserModuleListModel model) async {
    // List<UserModule> _um = List.empty(growable: true);
    // List<UserModule> _umPurchased = List.empty(growable: true);

    if (isFree != null && isFree) {
      //await model.listenToFreeUserModule().then((value) => _um.addAll(value));
    }
    /*else {
      await model.listenToUserModule().then((modules) => {
            if (modules != null) {_umPurchased.addAll(modules)}
          });
    }*/
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
    return ViewModelBuilder<PurchasedUserModuleListModel>.reactive(
        viewModelBuilder: () => model,
        onModelReady: (model) => model.listenToPurchasedUserModule(),
        // widget.isFree ?  : ,
        builder: (context, model, child) => SafeArea(
                child: CommonScaffold(
              model: model,
              appTitle: (isFree ? Strings.trialLessons : Strings.myModules),
              bottomNavBarIndex: 3,
              bodyData: !model.busy
                  ? Column(
                      // mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (model.showMainBanner) buildRemoteConfigContainer(),
                        Expanded(
                          child: userModules != null
                              ? new ListView(
                                  //padding: const EdgeInsets.all(5),
                                  children: _buildUserModules(
                                      context, model, () => {refresh()}),
                                )
                              : Center(
                                  child: Text(
                                    Strings.noFreeLessonsOffered,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                        ),
                        // buildBottomActionBar(model)
                      ],
                    )
                  : buildCircularLoader(context),
            )));
  }

  _buildUserModules(BuildContext context, PurchasedUserModuleListModel model,
      Function onTap) {
    List<Widget> widgets = List.empty(growable: true);

    for (final um in model.userModules) {
      List<Widget> lessons = List.empty(growable: true);
      // for (final ci in um.courseInfo) {
      // lessons.add(Row(mainAxisAlignment: MainAxisAlignment.start, children: []));
      if (um.lessons != null) {
        for (final lesson in um.lessons) {
          lessons.add(_buildLessonCard(lesson, model));
          lessons.add(verticalSpaceTiny);
        }
      }

      widgets.add(Container(
          child: GestureDetector(
        onTap: onTap,
        child: buildScorabbleAccordian(context,
            headChildren: [
              buildWrappedText(
                context,
                um.moduleTitle,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              buildWrappedText(
                  context, um.courseName + " By " + um.instructorName,
                  lines: 2, style: Theme.of(context).textTheme.headline4),
            ],
            bodyChildren: lessons),
      )));
    }

    return widgets;
  }

  Container _buildLessonCard(Lesson item, PurchasedUserModuleListModel model) {
    return Container(
      child: GestureDetector(
        // onTap: () => model.editCourse(index),
        child: LessonItem(
          isAdmin: model.isAdmin,
          lesson: item,
          onPlayVideo: () => model.viewVideo(item.videoInfo),
          onViewDoc: () => model.viewPdf(item.instructionDoc.docUrl),
        ),
      ),
    );
  }
}
