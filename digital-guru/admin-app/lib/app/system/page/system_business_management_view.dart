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
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:stacked/stacked.dart';

class SystemBusinessManagementView extends StatefulWidget {
  SystemBusinessManagementView({Key? key}) : super(key: key);

  @override
  _SystemBusinessManagementViewState createState() =>
      _SystemBusinessManagementViewState();
}

class _SystemBusinessManagementViewState
    extends State<SystemBusinessManagementView> {
  late SystemDashBoardViewModel model;
  Map<String, BusinessProfile> businessProfileMap = {};
  List<Business> businessList = List.empty(growable: true);
  late BusinessProfile currentBusinessProfile;
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
      if (business.documentId != null) {
        getBusinessProfile(business.documentId!);
      }
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
            child: Column(children: [buildBusinessProfileView(context, model)]),
          ),
        body: Center()
        ),
      ),
    );
  }

  buildBusinessProfileView(
    BuildContext context,
    SystemDashBoardViewModel model,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            horizontalSpaceSmall,
            Text(Strings.selectBusiness),
            horizontalSpaceSmall,
            businessList.isNotEmpty
                ? DropdownButton<Business>(
                    items: businessList.map((e) {
                      return DropdownMenuItem(
                        child: Text(
                          '${e.name}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        value: e,
                      );
                    }).toList(),
                    onChanged: (newBehavior) {
                      setState(
                        () {
                          business = newBehavior!;
                          if (business.documentId != null) {
                            getBusinessProfile(business.documentId!);
                          }
                        },
                      );
                    },
                    value: business,
                    //dropdownColor: Colors.grey,
                  )
                : Text("Nobusiness Found"),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //businessSettings
            _buildUserCounts(context, currentBusinessProfile),
            _buildPublication(context, currentBusinessProfile),
            buildBusinessSettings(context, currentBusinessProfile),
          ],
        ),
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
        Row(
          children: [
            Text("General Stats", style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
        Container(
          decoration: boxDecoration(context),
          width: screenWidth(context),
          padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Admin Users:" + profile.userCounts!.adminUsers.toString()),
              Text(
                "ConsumerUsers:" + profile.userCounts!.consumerUsers.toString(),
              ),
              Text("Trial Users:" + profile.userCounts!.trialUsers.toString()),
              Text(
                "Purchased Users:" +
                    profile.userCounts!.purchasedUsers.toString(),
              ),
            ],
          ),
        ),
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
        Row(
          children: [
            Text("Publications", style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
        Container(
          decoration: boxDecoration(context),
          width: screenWidth(context),
          padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Courses:" + profile.publication!.courseCounts.toString()),
              Text(
                "Modules (trial):" +
                    (profile.publication!.totalModuleCounts -
                            profile.publication!.purchasedModuleCounts)
                        .toString(),
              ),
              Text(
                "Modules (purchased):" +
                    profile.publication!.purchasedModuleCounts.toString(),
              ),
              Text("Lessons:" + profile.publication!.lessonCounts.toString()),
            ],
          ),
        ),
      ],
    );
  }

  buildBusinessSettings(BuildContext context, BusinessProfile profile) {
    if (profile == null) {
      return Container();
    }
    BusinessSetting businessSetting = profile.businessSetting!;
    if (businessSetting == null) {
      return Container();
    }

    return Column(
      children: [
        Row(
          children: [
            Text(
              "Business Settings",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        Container(
          decoration: boxDecoration(context),
          width: screenWidth(context),
          padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Maximum Courses"),
                  SpinBox(
                    min: 0,
                    max: 10,
                    value: businessSetting.maxCourses!.toDouble(),
                    decimals: 0,
                    step: 1,
                    onChanged: (value) {
                      setState(() {
                        businessSetting.maxCourses = value.toInt();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Maximum Courses",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                children: [
                  Text("Maximum modules"),
                  SpinBox(
                    min: 0,
                    max: 10,
                    value: businessSetting.maxModulePerCourse!.toDouble(),
                    decimals: 0,
                    step: 1,
                    onChanged: (value) {
                      setState(() {
                        businessSetting.maxModulePerCourse = value.toInt();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Maximum modules",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                children: [
                  Text("Max Lessons "),
                  SpinBox(
                    min: 0,
                    max: 10,
                    value: businessSetting.lessonsPerModule!.toDouble(),
                    decimals: 0,
                    step: 1,
                    onChanged: (value) {
                      setState(() {
                        businessSetting.lessonsPerModule = value.toInt();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Max Lessons",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              verticalSpaceSmall,
              Row(
                children: [
                  Text("Maximum Video Duration"),
                  SpinBox(
                    min: 0,
                    max: 60,
                    value: businessSetting.maxVideoDuration!.toDouble(),
                    decimals: 0,
                    step: 1,
                    onChanged: (value) {
                      setState(() {
                        businessSetting.maxVideoDuration = value.toInt();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Maximum Video Duration",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  BusyButton(
                    title: "update",
                    onPressed: () {
                      setState(() {
                        model.updateSystemBusinessSetting(businessSetting);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Business Settings successfully Updated!",
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
