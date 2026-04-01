import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/system/model/business_setting.dart';
import 'package:digiguru/app/system/model/business_settinig_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:stacked/stacked.dart';

class BusinessSettingView extends StatefulWidget {
  final BusinessSetting businessSetting;
  const BusinessSettingView({Key? key, required this.businessSetting}) : super(key: key);
  @override
  _BusinessSettingViewState createState() => _BusinessSettingViewState();
}

class _BusinessSettingViewState extends State<BusinessSettingView> {
  late BusinessSetting _businessSetting;
  @override
  initState() {
    super.initState();
    _businessSetting = widget.businessSetting;
    // maxModulePerCourse = _businessSetting.maxModulePerCourse;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessSettingViewModel>.reactive(
      viewModelBuilder: () => BusinessSettingViewModel(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: widget.businessSetting != null
              ? Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Maximum Courses"),
                          SpinBox(
                            min: 0,
                            max: 10,
                            value: _businessSetting.maxCourses?.toDouble() ?? 0,
                            decimals: 0,
                            step: 1,
                            onChanged: (value) {
                              setState(() {
                                _businessSetting.maxCourses = value.toInt();
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
                          Text("Maximum modules per Course"),
                          SpinBox(
                            min: 0,
                            max: 10,
                            value: _businessSetting.maxModulePerCourse?.toDouble() ?? 0,
                            decimals: 0,
                            step: 1,
                            onChanged: (value) {
                              setState(() {
                                _businessSetting.maxModulePerCourse = value.toInt();
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Maximum modules per Course",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      Row(
                        children: [
                          Text("Maximum Lessons Per module"),
                          SpinBox(
                            min: 0,
                            max: 10,
                            value: _businessSetting.lessonsPerModule!.toDouble(),
                            decimals: 0,
                            step: 1,
                            onChanged: (value) {
                              setState(() {
                                _businessSetting.lessonsPerModule = value.toInt();
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Maximum Lessons Per module",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceSmall,
                      Row(
                        children: [
                          Text("Maximum video Duration"),
                          SpinBox(
                            min: 0,
                            max: 60,
                            value: _businessSetting.maxVideoDuration?.toDouble() ?? 0,
                            decimals: 0,
                            step: 1,
                            onChanged: (value) {
                              setState(() {
                                _businessSetting.maxVideoDuration = value.toInt();
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Maximum video Duration",
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
                              model.update(_businessSetting);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
      ),
    );
  }
}
