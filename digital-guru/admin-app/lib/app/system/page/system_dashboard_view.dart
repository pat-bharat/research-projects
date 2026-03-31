import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/business/model/business_legal.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/business/model/business_profille.dart';
import 'package:digiguru/app/system/model/business_setting.dart';
import 'package:digiguru/app/system/model/system_dashboard_view_model.dart';
import 'package:digiguru/app/system/model/system_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:stacked/stacked.dart';

class SystemDashBoardView extends StatefulWidget {
  SystemDashBoardView({Key key}) : super(key: key);

  @override
  _SystemDashBoardViewState createState() => _SystemDashBoardViewState();
}

class _SystemDashBoardViewState extends State<SystemDashBoardView> {
  SystemDashBoardViewModel model;
  Map<String, BusinessProfile> businessProfileMap = {};
  List<Business> businessList = List.empty(growable: true);
  BusinessProfile currentBusinessProfile = BusinessProfile();
  Business business = Business();
  @override
  void initState() {
    super.initState();
    model = SystemDashBoardViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SystemDashBoardViewModel>.reactive(
      viewModelBuilder: () => model,
      onModelReady: (model) {},
      builder: (context, model, child) => SafeArea(
        child: CommonScaffold(
          appTitle: Strings.system,
          model: model,
          bottomNavBarIndex: 0,
          bodyData: SingleChildScrollView(
            padding: viewPadding,
            child: Column(
              children: [
                // Overview
                //SystemProfile
                //manage business Settings
                //view business finanacial
                //manage system legals
                //
                //buildSystemsProfile(context, _systemProfile),
                //buildSystemFinanlcial(context, model),
                // buildSystemBranding(context, model),
                // buildSystemPublication(context, model),
                // buildSystemLegals(context, model),
                buildBusinessProfileView(context, model),
                buildSystemBusinessSettings(context, model),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildSystemBusinessSettings(
    BuildContext context,
    SystemDashBoardViewModel model,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Business Settings",
              style: Theme.of(context).textTheme.headline3,
            ),
            IconButton(
              icon: Icon(Icons.edit),
              iconSize: 25,
              onPressed: () {
                model.editBusiness();
              },
            ),
          ],
        ),
        Container(
          decoration: boxDecoration(context),
          padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text("Comming Soon!")],
          ),
        ),
      ],
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
            Text(Strings.selectInstructor),
            horizontalSpaceSmall,
            businessList.isNotEmpty
                ? DropdownButton<Business>(
                    items: businessList.map((e) {
                      return DropdownMenuItem(
                        child: Text(
                          '${e.name}',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        value: e,
                      );
                    }).toList(),
                    // hint: Text("Select Instructor"),
                    onChanged: (newBehavior) {
                      setState(() => business = newBehavior);
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
            Row(
              children: [
                Text(
                  "Business Profile",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
            Container(
              decoration: boxDecoration(context),
              padding: EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
              child: //businessSettings
              buildBusinessSettings(
                context,
                currentBusinessProfile.businessSetting,
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildBusinessSettings(BuildContext context, BusinessSetting businessSetting) {
    return Column(
      children: [
        Row(
          children: [
            Text("Maximum Courses"),
            SpinBox(
              min: 0,
              max: 10,
              value: businessSetting.maxCourses.toDouble(),
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
              value: businessSetting.maxModulePerCourse.toDouble(),
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
              value: businessSetting.lessonsPerModule.toDouble(),
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
              value: businessSetting.maxVideoDuration.toDouble(),
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
                model.updateSystemBusinessSetting(businessSetting);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Business Settings successfully Updated!"),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
