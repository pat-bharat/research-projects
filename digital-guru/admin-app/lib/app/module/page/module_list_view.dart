import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/top_navigation_bar.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/creation_aware_list_item.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/module/page/module_item.dart';
import 'package:digiguru/app/module/model/module_list_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ModuleListView extends StatefulWidget {
  //final List<Course> courses = new List();
  final Course course;
  // ModuleListModel model;

  ModuleListView({Key? key, required this.course}) : super(key: key);

  @override
  _ModuleListViewState createState() => _ModuleListViewState();
}

class _ModuleListViewState extends State<ModuleListView> {
  late Course course;
  late ModuleListModel model;
  List<String> _userModules = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    course = widget.course;
    model = ModuleListModel(course: course);
    if (!model.isAdmin) {
      populateUserModules();
    }
  }

  Future populateUserModules() async {
    List userModules = await model
        .getAllUserPurchasedModules(BaseService.currentUser!.documentId!);

    setState(() {
      _userModules = userModules.cast<String>();
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return ViewModelBuilder<ModuleListModel>.reactive(
      viewModelBuilder: () => new ModuleListModel(course: widget.course),
      onViewModelReady: (model) => model.listenToModules(),
      builder: (context, model, child) => SafeArea(
          child: CommonScaffold(
        appTitle: Strings.moduleListViewTitle,
        showDrawer: false,
        model: model,
        showBottomNav: model.isAdmin,
        //appBar: TopNavigationBar(model: model, text: "Course Modules"),
        // backgroundColor: Theme.of(context).backgroundColor,
        bodyData: Padding(
          padding: listPadding,
          child: !model.busy
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // _buildTitleRow(),
                    verticalSpace(5),
                    if (model.showMainBanner) buildRemoteConfigContainer(),
                    Expanded(
                        child: model.modules != null
                            ? ReorderableListView(
                                onReorder: (int oldIndex, int newIndex) {
                                  setState(() {
                                    if (newIndex > oldIndex) {
                                      newIndex -= 1;
                                    }
                                    model.modules.insert(newIndex,
                                        model.modules.removeAt(oldIndex));
                                  });
                                },
                                children: <Widget>[
                                  for (final item in model.modules)
                                    _buildModuleItemCard(item, model),
                                ],
                              )
                            : Center(
                                child: Text(
                                  Strings.pleaseAddModules,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              )),
                    model.isAdmin ? _buildBottomButtonsBar(model) : Container(),
                    verticalSpaceSmall,
                  ],
                )
              : buildCircularLoader(context),
        ),
      body: Center(),)),
    );
  }

  Row _buildBottomButtonsBar(ModuleListModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BusyButton(
            title: Strings.btnAddModule,
            onPressed: () => {model.navigateToAddModuleView()}),
        horizontalSpaceSmall,
        BusyButton(
            title: Strings.btnSaveModuleOrder,
            onPressed: () => {model.saveModuleDisplayOrder(model.modules)})
      ],
    );
  }

  Card _buildModuleItemCard(Module? item, ModuleListModel model) {
    /* bool purchased = true;
    var result = model.isModuleAlreadyPurchased(item.documentId);
    if (result != null && result is bool) {
      purchased = result;
    } else {
      purchased = false;
    }
    if (result) {
      _userModules.add(item.documentId);
    }
*/
    return Card(
      //color: Colors.blueGrey,
      key: ValueKey(item!.id),
      elevation: 2,
      child: CreationAwareListItem(
        itemCreated: () {
          if (model.modules.indexOf(item) % 20 == 0) model.requestMoreData();
        },
        child: GestureDetector(
          child: ModuleItem(
            isAdmin: model.isAdmin,
            canPurchase: !_userModules.contains(item.id),
            module: item,
            onDeleteItem: () => model.deleteModule(module: item),
            onEditItem: () => model.editModule(item),
            onEditLessons: () => model.editLesons(item),
            onViewDoc: () => item.moduleDetailDoc?.docUrl != null ? model.viewPdf(item.moduleDetailDoc!.docUrl!) : null,
            onPlayVideo: () => item.moduleVideo != null ? model.viewVideo(item.moduleVideo!) : null,
            onPurchase: () => purchaseModule(item),
          ),
        ),
      ),
    );
  }

  purchaseModule(Module item) async {
    await model.purchaseModule(item);
    setState(() {});
  }
}
