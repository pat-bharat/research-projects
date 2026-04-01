import 'dart:io';

import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/constants/tooltips.dart';
import 'package:digiguru/app/common/constants/validation_pattern.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/input_field.dart';
import 'package:digiguru/app/user/model/user.dart';
import 'package:digiguru/app/user/model/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/models/phone_number.dart';
import 'package:stacked/stacked.dart';

class UserProfileView extends StatefulWidget {
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  User? profile;
  UserProfileModel? model;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  var _country = "US";
  final _userViewKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  void loadUserProfile() {
    model = UserProfileModel();
    User? _profile = model?.loadCurrentUserProfile();
    setState(() {
      profile = _profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return ViewModelBuilder<UserProfileModel>.reactive(
        viewModelBuilder: () => model!,
        onViewModelReady: (model) {
          nameController.text = profile!.fullName ?? '';
          emailController.text = profile!.email ?? '';
          mobileController.text = profile!.mobileNo ?? '';
          _country = profile!.country ?? 'US';
        },
        builder: (context, model, child) => SafeArea(
              child: CommonScaffold(
                  appTitle: Strings.userProfileTitle,
                  showDrawer: false,
                  model: model,
                  showBottomNav: true,
                  bottomNavBarIndex: 0,
                  bodyData: SingleChildScrollView(
                      padding: viewPadding,
                      child: Form(
                        key: _userViewKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(children: [
                          verticalSpaceMedium,
                          _buildProfile(context, model),
                          verticalSpaceMedium,
                          model.isConsumerUser
                              ? _buildPreferances(context, model)
                              : _buildAdminPreferances(context, model),
                          verticalSpaceMedium,
                          _buildActionButtons(context, model),
                          verticalSpaceMedium,
                        ]),
                      )), body: Center(),),
            ));
  } //Column1

  Widget _buildProfile(BuildContext context, UserProfileModel model) {
    if (profile == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "Profile",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]),
        commonContainer(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  controller: nameController,
                  placeholder: "Full Name",
                  validator:
                      RequiredValidator(errorText: "This is rRequired Field"),
                ),
                InputField(
                  controller: emailController,
                  placeholder: "EmailAddress",
                  isReadOnly: true,
                ),
                IntlPhoneField(
                  initialValue: mobileController.text,
                  initialCountryCode: _country,
                  style: Theme.of(context).textTheme.bodyMedium,
                  validator: (PhoneNumber? phone) {
                    if (phone == null || phone.number.isEmpty) {
                      return Strings.invalidMobileNumber;
                    }
                    if (!RegExp(phonePattern.toString()).hasMatch(phone.number)) {
                      return Strings.invalidMobileNumber;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: Strings.mobileNumber,
                    border: OutlineInputBorder(),
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                  ),
                  onChanged: (phone) {
                    _country = phone.countryISOCode;
                    mobileController.text = phone.number;
                  },
                ),
              ],
            ))
      ],
    );
  }

  Widget _buildPreferances(BuildContext context, UserProfileModel model) {
    if (profile == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "Preferences",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]),
        commonContainer(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  GFToggle(
                    onChanged: (val) {
                      setState(() {
                        profile!.userPreferances?.downloadLessons = val;
                      });
                    },
                    value: profile!.userPreferances?.downloadLessons ?? false,
                    type: Platform.isIOS
                        ? GFToggleType.ios
                        : GFToggleType.android,
                  ),
                  new Text("Download Lessons?"),
                  horizontalSpaceMedium,
                  buildToolTip(
                      context, "for offline viewing you can down lessons"),
                ]),
                verticalSpaceSmall,
                Row(children: [
                  GFToggle(
                    onChanged: (val) {
                      setState(() {
                        profile!.userPreferances?.wifiDownloadOnly = val;
                      });
                    },
                    value: profile!.userPreferances?.wifiDownloadOnly ?? false,
                    type: Platform.isIOS
                        ? GFToggleType.ios
                        : GFToggleType.android,
                  ),
                  new Text("Download Lessons only on wifi?"),
                  horizontalSpaceMedium,
                  buildToolTip(
                      context, "Only use wifi connections for downloading"),
                ]),
                verticalSpaceSmall,
                Row(children: [
                  GFToggle(
                    onChanged: (val) {
                      setState(() {
                        profile!.userPreferances?.inAppNotifications = val;
                      });
                    },
                    value: profile!.userPreferances?.inAppNotifications ?? false,
                    type: Platform.isIOS
                        ? GFToggleType.ios
                        : GFToggleType.android,
                  ),
                  new Text("Allow In-App Notifications?"),
                  horizontalSpaceMedium,
                  buildToolTip(context, "Allow In appnotifications"),
                ]),
                verticalSpaceSmall,
              ],
            ))
      ],
    );
  }

  Widget _buildAdminPreferances(BuildContext context, UserProfileModel model) {
    if (profile == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            "Preferences",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ]),
        commonContainer(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpaceSmall,
                Row(children: [
                  GFToggle(
                    onChanged: (val) {
                      setState(() {
                        profile!.userPreferances?.wifiUploadOnly = val;
                      });
                    },
                    value: profile!.userPreferances?.wifiUploadOnly ?? false,
                    type: Platform.isIOS
                        ? GFToggleType.ios
                        : GFToggleType.android,
                  ),
                  new Text("Upload data only on wifi?"),
                  horizontalSpaceMedium,
                  buildToolTip(
                      context, "Only use wifi connections for uploading"),
                ]),
                verticalSpaceSmall,
                Row(children: [
                  GFToggle(
                    onChanged: (val) {
                      setState(() {
                        profile!.userPreferances?.inAppNotifications = val;
                      });
                    },
                    value: profile!.userPreferances?.inAppNotifications ?? false,
                    type: Platform.isIOS
                        ? GFToggleType.ios
                        : GFToggleType.android,
                  ),
                  new Text("Allow In-App Notifications?"),
                  horizontalSpaceMedium,
                  buildToolTip(context, "Allow In appnotifications"),
                ]),
                verticalSpaceSmall,
              ],
            ))
      ],
    );
  }

  _buildActionButtons(BuildContext context, UserProfileModel model) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BusyButton(
                title: Strings.save,
                busy: model.busy,
                onPressed: () {
                  if (_userViewKey.currentState!.validate()) {
                    profile!.fullName = nameController.text;
                    profile!.country = _country;
                    profile!.mobileNo = mobileController.text;
                    model.save(profile! );
                  }
                }),
            horizontalSpaceMedium,
            BusyButton(
              title: Strings.cancel,
              onPressed: () {
                model.cancel();
              },
            ),
          ],
        ),
      ],
    );
  }
}
