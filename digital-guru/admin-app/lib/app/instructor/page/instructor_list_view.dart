import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/creation_aware_list_item.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/instructor/model/instructor.dart';
import 'package:digiguru/app/instructor/model/instructor_list_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'instructor_item.dart';

class InstructorListView extends StatefulWidget {
  //final List<Course> courses = new List();
  InstructorListView({Key? key}) : super(key: key);

  @override
  _InstructorListViewState createState() => _InstructorListViewState();
}

class _InstructorListViewState extends State<InstructorListView> {
  void reorderData(List<Course> list, int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = list.removeAt(oldindex);
      list.insert(newindex, items);
    });
  }

  void sorting(List<Course> list) {
    setState(() {
      list.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return ViewModelBuilder<InstructorListModel>.reactive(
      viewModelBuilder: () => InstructorListModel(),
      onModelReady: (model) => model.listenToInstructors(),
      builder: (context, model, child) => SafeArea(
          child: CommonScaffold(
        appTitle: Strings.instructors,
        model: model,
        bodyData: Padding(
          padding: listPadding,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              verticalSpace(5),
              if (model.showMainBanner) _buildRemoteConfigBanner(context),
              Expanded(
                  child: InstructorListModel.instructors.isNotEmpty
                      ? ListView(
                          children: <Widget>[
                            for (final item in InstructorListModel.instructors)
                              _buildInstructorCard(model, item),
                          ],
                        )
                      : Center(
                          child: !model.busy
                              ? Text(Strings.addInstructor,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium)
                              : Container(),
                        )),
              model.isAdmin ? _buildBottomButtonRaw(model) : Container(),
              verticalSpaceSmall,
            ],
          ),
        ),
        body: Center(),
      )),
    );
  }

  _buildRemoteConfigBanner(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: boxDecoration(context),
        alignment: Alignment.center,
        child: Text(
          'Banner from emote Config',
          textAlign: TextAlign.center,
        ));
  }

  _buildBottomButtonRaw(InstructorListModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BusyButton(
            title: Strings.btnAddInstructor,
            onPressed: () => {model.navigateToAddInstructorToBusiness()}),
        horizontalSpaceSmall,
      ],
    );
  }

  _buildInstructorCard(InstructorListModel model, Instructor item) {
    return Card(
      //color: Colors.blueGrey,
      key: ValueKey(item.documentId),
      elevation: 2,
      child: CreationAwareListItem(
        itemCreated: () {
          if (InstructorListModel.instructors.indexOf(item) % 20 == 0)
            model.requestMoreData();
        },
        child: GestureDetector(
          // onTap: () => model.editCourse(index),
          child: InstructorItem(
            isAdmin: model.isAdmin,
            instructor: InstructorListModel
                .instructors[InstructorListModel.instructors.indexOf(item)],
            onDeleteItem: () => model.deleteInstructor(item),
            onEditItem: () => model.editInstructor(item),
          ),
        ),
      ),
    );
  }
}
