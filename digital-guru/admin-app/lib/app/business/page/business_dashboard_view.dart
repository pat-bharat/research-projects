import 'package:digiguru/app/business/model/bisuness_dashboard_view_model.dart';
import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/business/model/business_legal.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/business/model/business_profille.dart';
import 'package:digiguru/app/system/model/business_setting.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BusinessDashBoardView extends StatefulWidget {
  final Business business;

  BusinessDashBoardView({Key? key, required this.business}) : super(key: key);

  @override
  _BusinessDashBoardViewState createState() => _BusinessDashBoardViewState();
}

class _BusinessDashBoardViewState extends State<BusinessDashBoardView> {
  List<BusinessLegal> _legals = List.empty(growable: true);
  late BusinessProfile profile;
  late BusinessDashBoardViewModel model;
  @override
  void initState() {
    super.initState();
    model = BusinessDashBoardViewModel();
    getBusinessProfile();
  }

  Future getBusinessProfile() async {
    BusinessProfile _profile = BusinessProfile();
    // List<BusinessLegal> lgls = List.empty(growable: true);
    await model.getBusinessProfile().then((value) => {_profile = value});
    // await model.getConsumerLegals().then((value) => {lgls.addAll(value)});
    setState(() {
      profile = _profile;
      // _legals = lgls;
    });
    return "Success";
  }

  Future getConsumerLegals() async {
    _legals = [];
    List<BusinessLegal> lgls = List.empty(growable: true);
    await model.getConsumerLegals().then((value) => {lgls.addAll(value)});

    setState(() {
      _legals = lgls;
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessDashBoardViewModel>.reactive(
        viewModelBuilder: () => model,
        onModelReady: (model) {},
        builder: (context, model, child) => SafeArea(
              child: CommonScaffold(
                appTitle: Strings.businessViewTtile,
                model: model,
                bottomNavBarIndex: 0,
                bodyData: SingleChildScrollView(
                    padding: viewPadding,
                    child: Column(
                      children: [
                        _buildBusinessProfile(context, profile),
                        verticalSpaceSmall,
                        _buildBusinessPublication(context, profile),
                        verticalSpaceSmall,
                        _buildFinanlcial(context, profile),
                        _buildBusinessBranding(context, model),
                        verticalSpaceSmall,
                        _buildBusinessSettings(context, profile),
                        _buildBusinessLegals(context, profile),
                        verticalSpaceSmall,
                      ],
                    )),
                body: Center(),
              ),
            ));
  }

  _buildBusinessProfile(BuildContext context, BusinessProfile profile) {
    var status =
        (model.currentBusiness.locked != null && model.currentBusiness.locked!)
            ? Text("Locked", style: TextStyle(color: Colors.red))
            : (model.currentBusiness.locked != null)
                ? Text("Active", style: TextStyle(color: Colors.green))
                : Text("Unavailable", style: TextStyle(color: Colors.red));
    var nonPurchassedUsers = profile.userCounts?.trialUsers;
    var purchasedUsers = profile.userCounts?.purchasedUsers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            model.currentBusiness.name ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
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
              children: [
                buildWrappedText(context,
                    'Mobile # ' + (model.currentBusiness.mobilePhone ?? ''),
                    style: Theme.of(context).textTheme.bodyMedium),
                buildWrappedText(context,
                    'Email: ' + (model.currentBusiness.contactEmail ?? ''),
                    style: Theme.of(context).textTheme.bodyMedium),
                Row(
                  children: [Text("Status:"), status],
                ),
                Text("Users:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Users who still evaluating:" +
                    nonPurchassedUsers.toString()),
                Text("Users who purchased:" + purchasedUsers.toString()),
              ],
            ))
      ],
    );
  }

  _buildBusinessLegals(BuildContext context, BusinessProfile profile) {
    List<Widget> legals = List.empty(growable: true);
    profile.businessLegal!.forEach((legal) {
      legals.add(Row(
        children: [
          buildWrappedText(context, legal.title),
        ],
      ));
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "Published Legals",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            iconSize: 25,
            onPressed: () {
              model.editBusinessLegals();
            },
          )
        ]),
        commonContainer(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: legals,
            ))
      ],
    );
  }

  _buildBusinessSettings(BuildContext context, BusinessProfile profile) {
    BusinessSetting? businessSetting = profile.businessSetting;
    if (businessSetting == null) {
      return Container();
    }

    return Column(
      children: [
        Row(children: [
          Text(
            "Business Settings",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]),
        commonContainer(
          context,
          Column(children: [
            Row(
              children: [
                Text("Maximum Courses :" +
                    businessSetting.maxCourses.toString()),
              ],
            ),
            verticalSpaceSmall,
            Row(
              children: [
                Text("Maximum modules:" +
                    businessSetting.maxModulePerCourse.toString()),
              ],
            ),
            verticalSpaceSmall,
            Row(
              children: [
                Text("Max Lessons :" +
                    businessSetting.lessonsPerModule.toString()),
              ],
            ),
            verticalSpaceSmall,
            Row(
              children: [
                Text("Maximum Video Duration :" +
                    businessSetting.maxVideoDuration.toString()),
              ],
            ),
          ]),
        )
      ],
    );
  }

  _buildBusinessPublication(BuildContext context, BusinessProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "Publications",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]),
        commonContainer(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Courses:" + profile.publication!.courseCounts.toString(),
                ),
                Text(
                  "Modules (trial):" +
                      ((profile.publication?.totalModuleCounts ?? 0) -
                              (profile.publication?.purchasedModuleCounts ?? 0))
                          .toString(),
                ),
                Text(
                  "Modules (purchased):" +
                      (profile.publication?.purchasedModuleCounts ?? 0)
                          .toString(),
                ),
                Text(
                  "Lessons:" +
                      (profile.publication?.lessonCounts ?? 0).toString(),
                ),
              ],
            ))
      ],
    );
  }

  _buildFinanlcial(BuildContext context, BusinessProfile model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "Financial",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]),
        commonContainer(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Collected Revenue :" + profile.collectedRevenue.toString())
              ],
            ))
      ],
    );
  }

  _buildBusinessBranding(
      BuildContext context, BusinessDashBoardViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "Branding & Theming",
            style: Theme.of(context).textTheme.bodyMedium,
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
