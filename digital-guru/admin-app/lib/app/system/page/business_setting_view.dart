import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/system/model/business_setting.dart';
import 'package:digiguru/app/system/model/business_settinig_view_model.dart';
import 'package:flutter/material.dart';
import 'package:spinner_input/spinner_input.dart';
import 'package:stacked/stacked.dart';

class BusinessSettingView extends StatefulWidget {
  final BusinessSetting businessSetting;
  const BusinessSettingView({Key key, this.businessSetting}) : super(key: key);
  @override
  _BusinessSettingViewState createState() => _BusinessSettingViewState();
}

class _BusinessSettingViewState extends State<BusinessSettingView> {
  BusinessSetting _businessSetting;
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
                                SpinnerInput(
                                    spinnerValue:
                                        _businessSetting.maxCourses.toDouble(),
                                    minValue: 0,
                                    maxValue: 10,
                                    fractionDigits: 0,
                                    plusButton: SpinnerButtonStyle(
                                        color: Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    minusButton: SpinnerButtonStyle(
                                        color: Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    middleNumberWidth: 60,
                                    middleNumberStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    middleNumberBackground:
                                        Colors.grey[200].withOpacity(0.7),
                                    onChange: (newValue) {
                                      setState(() {
                                        _businessSetting.maxCourses =
                                            newValue.toInt();
                                      });
                                    }),
                              ],
                            ),
                            verticalSpaceSmall,
                            Row(
                              children: [
                                Text("Maximum modules per Course"),
                                SpinnerInput(
                                    spinnerValue: _businessSetting
                                        .maxModulePerCourse
                                        .toDouble(),
                                    minValue: 0,
                                    maxValue: 10,
                                    fractionDigits: 0,
                                    plusButton: SpinnerButtonStyle(
                                        color: Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    minusButton: SpinnerButtonStyle(
                                        color: Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    middleNumberWidth: 60,
                                    middleNumberStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    middleNumberBackground:
                                        Colors.grey[200].withOpacity(0.7),
                                    onChange: (newValue) {
                                      setState(() {
                                        _businessSetting.maxModulePerCourse =
                                            newValue.toInt();
                                      });
                                    }),
                              ],
                            ),
                            verticalSpaceSmall,
                            Row(
                              children: [
                                Text("Maximum Lessons Per module"),
                                SpinnerInput(
                                    spinnerValue: _businessSetting
                                        .lessonsPerModule
                                        .toDouble(),
                                    minValue: 0,
                                    maxValue: 10,
                                    fractionDigits: 0,
                                    plusButton: SpinnerButtonStyle(
                                        color: Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    minusButton: SpinnerButtonStyle(
                                        color: Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    middleNumberWidth: 60,
                                    middleNumberStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    middleNumberBackground:
                                        Colors.grey[200].withOpacity(0.7),
                                    onChange: (newValue) {
                                      setState(() {
                                        _businessSetting.lessonsPerModule =
                                            newValue.toInt();
                                      });
                                    }),
                              ],
                            ),
                            verticalSpaceSmall,
                            Row(
                              children: [
                                Text("Maximum video Duration"),
                                SpinnerInput(
                                    spinnerValue: _businessSetting
                                        .maxVideoDuration
                                        .toDouble(),
                                    minValue: 0,
                                    maxValue: 60,
                                    fractionDigits: 0,
                                    plusButton: SpinnerButtonStyle(
                                        color: Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    minusButton: SpinnerButtonStyle(
                                        color: Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    middleNumberWidth: 60,
                                    middleNumberStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    middleNumberBackground:
                                        Colors.grey[200].withOpacity(0.7),
                                    onChange: (newValue) {
                                      setState(() {
                                        _businessSetting.maxVideoDuration =
                                            newValue.toInt();
                                      });
                                    }),
                              ],
                            ),
                            Row(children: [
                              BusyButton(
                                  title: "update",
                                  onPressed: () {
                                    model.update(_businessSetting);
                                  })
                            ])
                          ],
                        ),
                      )
                    : Container())));
  }
}
