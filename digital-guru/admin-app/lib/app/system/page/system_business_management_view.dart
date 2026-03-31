import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/business/model/business_profille.dart';
import 'package:digiguru/app/system/model/business_setting.dart';
import 'package:digiguru/app/system/model/system_dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:spinner_input/spinner_input.dart';
import 'package:stacked/stacked.dart';

class SystemBusinessManagementView extends StatefulWidget {
  SystemBusinessManagementView({Key key}) : super(key: key);

  @override
  _SystemBusinessManagementViewState createState() =>
      _SystemBusinessManagementViewState();
}

class _SystemBusinessManagementViewState
    extends State<SystemBusinessManagementView> {
  SystemDashBoardViewModel model;
  Map<String, BusinessProfile> businessProfileMap = {};
  List<Business> businessList = List.empty(growable: true);
  BusinessProfile currentBusinessProfile;
  Business business = Business();
  @override
  void initState() {
    super.initState();
    model = SystemDashBoardViewModel();
    //currentBusinessProfile.businessSetting = BusinessSetting();
    getBusinessList();

    //getSystemLegals();
  }

  Future getBusinessList() async {
    List<Business> _businessList = await model.getAllBusinesses();
    setState(() {
      businessList = _businessList;
      business = businessList.first;
      getBusinessProfile(business.documentId);
    });
    return "Success";
  }

  Future getBusinessProfile(String bid) async {
    BusinessProfile profile = await model.getBusinessProfile(bid);
    setState(() {
      currentBusinessProfile = profile;
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SystemDashBoardViewModel>.reactive(
        viewModelBuilder: () => model,
        onModelReady: (model) {},
        builder: (context, model, child) => SafeArea(
              child: CommonScaffold(
                  appTitle: Strings.systemBusinessManagement,
                  model: model,
                  bottomNavBarIndex: 1,
                  bodyData: SingleChildScrollView(
                      padding: viewPadding,
                      child: Column(
                        children: [
                          buildBusinessProfileView(context, model),
                        ],
                      ))),
            ));
  }

  buildBusinessProfileView(
      BuildContext context, SystemDashBoardViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          horizontalSpaceSmall,
          Text(Strings.selectBusiness),
          horizontalSpaceSmall,
          businessList.isNotEmpty
              ? DropdownButton<Business>(
                  items: businessList.map((e) {
                    return DropdownMenuItem(
                        child: Text('${e.name}',
                            style: Theme.of(context).textTheme.headline4),
                        value: e);
                  }).toList(),
                  onChanged: (newBehavior) {
                    setState(() => {
                          business = newBehavior,
                          getBusinessProfile(business.documentId)
                        });
                  },
                  value: business,
                  //dropdownColor: Colors.grey,
                )
              : Text("Nobusiness Found"),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //businessSettings
          _buildUserCounts(context, currentBusinessProfile),
          _buildPublication(context, currentBusinessProfile),
          buildBusinessSettings(context, currentBusinessProfile),
        ]),
      ],
    );
  }

  _buildUserCounts(BuildContext context, BusinessProfile profile) {
    if (profile == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "General Stats",
            style: Theme.of(context).textTheme.headline3,
          ),
        ]),
        Container(
            decoration: boxDecoration(context),
            width: screenWidth(context),
            padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Admin Users:" + profile.userCounts.adminUsers.toString(),
                ),
                Text("ConsumerUsers:" +
                    profile.userCounts.consumerUsers.toString()),
                Text("Trial Users:" + profile.userCounts.trialUsers.toString()),
                Text("Purchased Users:" +
                    profile.userCounts.purchasedUsers.toString()),
              ],
            ))
      ],
    );
  }

  _buildPublication(BuildContext context, BusinessProfile profile) {
    if (profile == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "Publications",
            style: Theme.of(context).textTheme.headline3,
          ),
        ]),
        Container(
            decoration: boxDecoration(context),
            width: screenWidth(context),
            padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Courses:" + profile.publication.courseCounts.toString(),
                ),
                Text(
                  "Modules (trial):" +
                      (profile.publication.totalModuleCounts -
                              profile.publication.purchasedModuleCounts)
                          .toString(),
                ),
                Text(
                  "Modules (purchased):" +
                      profile.publication.purchasedModuleCounts.toString(),
                ),
                Text(
                  "Lessons:" + profile.publication.lessonCounts.toString(),
                ),
              ],
            ))
      ],
    );
  }

  buildBusinessSettings(BuildContext context, BusinessProfile profile) {
    if (profile == null) {
      return Container();
    }
    BusinessSetting businessSetting = profile.businessSetting;
    if (businessSetting == null) {
      return Container();
    }

    return Column(
      children: [
        Row(children: [
          Text(
            "Business Settings",
            style: Theme.of(context).textTheme.headline3,
          ),
        ]),
        Container(
          decoration: boxDecoration(context),
          width: screenWidth(context),
          padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
          child: Column(children: [
            Row(
              children: [
                Text("Maximum Courses"),
                SpinnerInput(
                    spinnerValue: businessSetting.maxCourses.toDouble(),
                    minValue: 0,
                    maxValue: 10,
                    fractionDigits: 0,
                    plusButton: SpinnerButtonStyle(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(15)),
                    minusButton: SpinnerButtonStyle(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(15)),
                    middleNumberWidth: 60,
                    middleNumberStyle: Theme.of(context).textTheme.bodyText1,
                    middleNumberBackground: Colors.grey[200].withOpacity(0.7),
                    onChange: (newValue) {
                      setState(() {
                        businessSetting.maxCourses = newValue.toInt();
                      });
                    }),
              ],
            ),
            verticalSpaceSmall,
            Row(
              children: [
                Text("Maximum modules"),
                SpinnerInput(
                    spinnerValue: businessSetting.maxModulePerCourse.toDouble(),
                    minValue: 0,
                    maxValue: 10,
                    fractionDigits: 0,
                    plusButton: SpinnerButtonStyle(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(15)),
                    minusButton: SpinnerButtonStyle(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(15)),
                    middleNumberWidth: 60,
                    middleNumberStyle: Theme.of(context).textTheme.bodyText1,
                    middleNumberBackground: Colors.grey[200].withOpacity(0.7),
                    onChange: (newValue) {
                      setState(() {
                        businessSetting.maxModulePerCourse = newValue.toInt();
                      });
                    }),
              ],
            ),
            verticalSpaceSmall,
            Row(
              children: [
                Text("Max Lessons "),
                SpinnerInput(
                    spinnerValue: businessSetting.lessonsPerModule.toDouble(),
                    minValue: 0,
                    maxValue: 10,
                    fractionDigits: 0,
                    plusButton: SpinnerButtonStyle(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(15)),
                    minusButton: SpinnerButtonStyle(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(15)),
                    middleNumberWidth: 60,
                    middleNumberStyle: Theme.of(context).textTheme.bodyText1,
                    middleNumberBackground: Colors.grey[200].withOpacity(0.7),
                    onChange: (newValue) {
                      setState(() {
                        businessSetting.lessonsPerModule = newValue.toInt();
                      });
                    }),
              ],
            ),
            verticalSpaceSmall,
            Row(
              children: [
                Text("Maximum Video Duration"),
                SpinnerInput(
                    spinnerValue: businessSetting.maxVideoDuration.toDouble(),
                    minValue: 0,
                    maxValue: 60,
                    fractionDigits: 0,
                    plusButton: SpinnerButtonStyle(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(15)),
                    minusButton: SpinnerButtonStyle(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(15)),
                    middleNumberWidth: 60,
                    middleNumberStyle: Theme.of(context).textTheme.bodyText1,
                    middleNumberBackground: Colors.grey[200].withOpacity(0.7),
                    onChange: (newValue) {
                      setState(() {
                        businessSetting.maxVideoDuration = newValue.toInt();
                      });
                    }),
              ],
            ),
            Row(children: [
              BusyButton(
                  title: "update",
                  onPressed: () {
                    setState(() {
                      model.updateSystemBusinessSetting(businessSetting);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Business Settings successfully Updated!")));
                  })
            ]),
          ]),
        )
      ],
    );
  }
}
