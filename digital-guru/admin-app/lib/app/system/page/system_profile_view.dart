import 'package:digiguru/app/common/constants/media_types.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/media_tile.dart';
import 'package:digiguru/app/system/model/system_dashboard_view_model.dart';
import 'package:digiguru/app/system/model/system_legal.dart';
import 'package:digiguru/app/system/model/system_profile.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SystemProfileView extends StatefulWidget {
  SystemProfileView({Key key}) : super(key: key);
  @override
  _SystemProfileViewState createState() => _SystemProfileViewState();
}

class _SystemProfileViewState extends State<SystemProfileView> {
  SystemDashBoardViewModel model;
  SystemProfile _systemProfile;
  List<SystemLegal> businessLegalList = List.empty(growable: true);
  List<SystemLegal> cosumerLegalList = List.empty(growable: true);
  @override
  initState() {
    super.initState();
    model = SystemDashBoardViewModel();
    getSystemProfile();
    getSystemLegals();
    // maxModulePerCourse = _businessSetting.maxModulePerCourse;
  }

  Future getSystemProfile() async {
    SystemProfile prof;
    await model.getSystemProfile().then((value) => {prof = value});
    setState(() {
      _systemProfile = prof;
    });

    return "Success";
  }

  Future getSystemLegals() async {
    List<SystemLegal> bLigelas = await model.getAllSystemLegals(true);
    List<SystemLegal> cLigelas = await model.getAllSystemLegals(false);
    setState(() {
      businessLegalList = bLigelas;
      cosumerLegalList = cLigelas;
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SystemDashBoardViewModel>.reactive(
        viewModelBuilder: () => model,
        //fireOnModelReadyOnce: true,
        builder: (context, model, child) => SafeArea(
            child: CommonScaffold(
                appTitle: Strings.systemProfileTitle,
                model: model,
                showDrawer: false,
                bottomNavBarIndex: 0,
                bodyData: _systemProfile != null
                    ? SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: screenWidth(context),
                                decoration: boxDecoration(context),
                                child: Column(children: [
                                  Text(
                                    _systemProfile.name,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  Text(
                                    _systemProfile.csPhone.toString() +
                                        '  ' +
                                        _systemProfile.csEmail,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ]),
                              ),
                              buildUserCounts(context, _systemProfile),
                              buildSystemPublication(context, _systemProfile),
                              buildSystemFinanlcial(context, _systemProfile),
                              buildSystemBranding(context, model),
                              buildSystemLegals(context, model),
                            ],
                          ),
                        ),
                      )
                    : Container())));
  }

  buildSystemLegals(BuildContext context, SystemDashBoardViewModel model) {
    List<Widget> bLegals = List.empty(growable: true);
    List<Widget> cLegals = List.empty(growable: true);
    businessLegalList.forEach((legal) {
      bLegals.add(Row(
        children: [
          buildWrappedText(context, legal.title),
          MediaTile(
              height: 50,
              width: 50,
              mediaLink: legal.pdfDoc,
              onView: () => {model.viewPdf(legal.pdfDoc)},
              mediaType: MediaTypes.DOCUMENT,
              isEditing: true,
              onTap: () {
                model.updateSystemLegal(legal);
              }),
        ],
      ));
    });
    cosumerLegalList.forEach((legal) {
      cLegals.add(Row(
        children: [
          buildWrappedText(context, legal.title),
          MediaTile(
              height: 50,
              width: 50,
              mediaLink: legal.pdfDoc,
              onView: () => {model.viewPdf(legal.pdfDoc)},
              mediaType: MediaTypes.DOCUMENT,
              isEditing: true,
              onTap: () {
                model.updateSystemLegal(legal);
              }),
        ],
      ));
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "System Legals",
            style: Theme.of(context).textTheme.headline2,
          )
        ]),
        Row(children: [
          horizontalSpaceMedium,
          Text(
            "Business Legals",
            style: Theme.of(context).textTheme.headline3,
          )
        ]),
        commonContainer(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bLegals,
            )),
        Row(children: [
          horizontalSpaceMedium,
          Text(
            "Consumer Legals",
            style: Theme.of(context).textTheme.headline3,
          )
        ]),
        commonContainer(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bLegals,
            )),
      ],
    );
  }

  buildUserCounts(BuildContext context, SystemProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "General Stats",
            style: Theme.of(context).textTheme.headline3,
          ),
        ]),
        commonContainer(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Businesses:" +
                      _systemProfile.userCounts.adminUsers.toString(),
                ),
                Text(
                  "Admin Users:" +
                      _systemProfile.userCounts.adminUsers.toString(),
                ),
                Text("ConsumerUsers:" +
                    _systemProfile.userCounts.consumerUsers.toString()),
                Text("Trial Users:" +
                    _systemProfile.userCounts.trialUsers.toString()),
                Text("Purchased Users:" +
                    _systemProfile.userCounts.purchasedUsers.toString()),
              ],
            ))
      ],
    );
  }

  buildSystemPublication(BuildContext context, SystemProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "Publications",
            style: Theme.of(context).textTheme.headline3,
          ),
        ]),
        commonContainer(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Courses:" +
                      _systemProfile.publication.courseCounts.toString(),
                ),
                Text(
                  "Modules (trial):" +
                      (_systemProfile.publication.totalModuleCounts -
                              _systemProfile.publication.purchasedModuleCounts)
                          .toString(),
                ),
                Text(
                  "Modules (purchased):" +
                      _systemProfile.publication.purchasedModuleCounts
                          .toString(),
                ),
                Text(
                  "Lessons:" +
                      _systemProfile.publication.lessonCounts.toString(),
                ),
              ],
            ))
      ],
    );
  }

  buildSystemFinanlcial(BuildContext context, SystemProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "Financial",
            style: Theme.of(context).textTheme.headline3,
          ),
        ]),
        commonContainer(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Revenue:  " + profile.totalRevenue.toString())
              ],
            ))
      ],
    );
  }

  buildSystemBranding(BuildContext context, SystemDashBoardViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "Branding & Theming",
            style: Theme.of(context).textTheme.headline3,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            iconSize: 25,
            onPressed: () {
              model.editBusiness();
            },
          )
        ]),
        commonContainer(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Comming Soon!")],
            ))
      ],
    );
  }
}
