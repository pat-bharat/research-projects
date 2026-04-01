import 'dart:io';

import 'package:digiguru/app/common/constants/media_types.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/constants/validation_pattern.dart';
import 'package:digiguru/app/common/widget/bottom_nav_bar.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/media_tile.dart';
import 'package:digiguru/app/common/widget/top_navigation_bar.dart';
import 'package:digiguru/app/instructor/model/instructor.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/input_field.dart';
import 'package:digiguru/app/instructor/model/instructor_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
//import 'package:form_field_validator/form_field_validator.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class InstructorView extends StatefulWidget {
  final Instructor? editingInstructor;

  InstructorView({Key? key, this.editingInstructor}) : super(key: key);

  @override
  _InstructorViewState createState() => _InstructorViewState();
}

class _InstructorViewState extends State<InstructorView> {
  final instructorDetilController = TextEditingController();
  final instructorNameController = TextEditingController();
  final introductionController = TextEditingController();
  final phoneController = TextEditingController();
  String _country = "US";
  final emailController = TextEditingController();
  final urlController = TextEditingController();

  File? backgroundImageFile;
  // List<InstructorMedia> medias = List.empty(growable: true);

  String? _profilePic;
  Instructor? editingInstructor;
  final _instructorFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    editingInstructor = widget.editingInstructor;
    //getInstructors();
  }

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return ViewModelBuilder<InstructorViewModel>.reactive(
        viewModelBuilder: () => InstructorViewModel(),
        onModelReady: (model) {
          if (editingInstructor != null) {
            // update the text in the controller
            instructorDetilController.text =
                editingInstructor?.introduction ?? '';
            introductionController.text = editingInstructor?.introduction ?? '';
            instructorNameController.text = editingInstructor?.fullName ?? '';
            phoneController.text = editingInstructor?.mobileNumber ?? '';
            _country = editingInstructor?.country ?? 'US';
            emailController.text = editingInstructor?.email ?? '';
            urlController.text = editingInstructor?.url ?? '';
            _profilePic = editingInstructor?.profilePic ?? null;
            //medias = editingInstructor?.InstructorMedia ?? model.defaultMedias();
            // InstructorMedia = editingInstructor?.InstructorMedia ?? null;
            model.setEditingInstructor(editingInstructor!);
          }
        },
        builder: (context, model, child) => SafeArea(
              child: CommonScaffold(
                  appTitle: Strings.instructorViewTitle,
                  showAppbar: true,
                  showDrawer: false,
                  model: model,
                  showBottomNav: true,
                  bottomNavBarIndex: 0,
                  bodyData: SingleChildScrollView(
                    padding: viewPadding,
                    child: Form(
                        key: _instructorFormKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: _buildFields(context, model)),
                  )
                  ,body: Center(),
                  ),
            ));
  }

  Column _buildFields(BuildContext context, InstructorViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        verticalSpaceSmall,
        InputField(
          label: Strings.instructorName,
          placeholder: Strings.instructorName,
          controller: instructorNameController,
          validator:
              RequiredValidator(errorText: Strings.required),
        ),
        InputField(
          label: Strings.websiteUrl,
          placeholder: Strings.websiteUrl,
          controller: urlController,
          validator: PatternValidator(urlPattern, errorText: Strings.invalidUrl),
        ),
        InputField(
          label: Strings.introduction,
          placeholder: Strings.introduction,
          maxLines: 2,
          maxLength: 200,
          textInputType: TextInputType.multiline,
          smallVersion: false,
          controller: introductionController,
        ),
        InputField(
          label: Strings.email,
          placeholder: Strings.enterEmail,
          controller: emailController,
          validator: EmailValidator(errorText: Strings.invalidUrl,),
        ),
        IntlPhoneField(
          initialValue: phoneController.text,
          initialCountryCode: _country,
          style: Theme.of(context).textTheme.bodyMedium,
          validator: (phone) {
            if (phone == null || phone.number.isEmpty) {
              return Strings.required;
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: Strings.mobileNumber,
            border: OutlineInputBorder(),
            contentPadding:
                new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          ),
          onChanged: (phone) {
            _country = phone.countryISOCode;
            phoneController.text = phone.number;
          },
        ),
        verticalSpaceTiny,
        _mediaUploadPanel(context, model),
        verticalSpaceTiny,
        _buildActionBar(context, model),
      ],
    );
  }

  Row _buildActionBar(BuildContext context, InstructorViewModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BusyButton(
          title: 'Save',
          busy: model.busy,
          onPressed: () {
            if (_instructorFormKey.currentState?.validate() ?? false) {
              model.save(
                fullName: instructorNameController.text,
                introduction: introductionController.text,
                profilePicture: _profilePic,
                url: urlController.text,
                mobileNumber: phoneController.text,
                country: _country,
                email: emailController.text,
              );
            } else {}
          },
        ),
        horizontalSpaceMedium,
        BusyButton(
          title: Strings.cancel,
          onPressed: () {
            model.goBack();
          },
        ),
      ],
    );
  }

  Container _mediaUploadPanel(BuildContext context, InstructorViewModel model) {
    return Container(
        decoration: boxDecoration(context),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.max,
            children: [
              MediaTile(
                label: Strings.profileImage,
                mediaType: MediaTypes.IMAGE,
                isEditing: model.isEditting,
                height: 70,
                width: 70,
                localFile: model.profilePicFile,
                mediaLink: editingInstructor != null
                    ? editingInstructor!.profilePic
                    : null,
                onTap: () => {
                  model
                      .selectProfilePicture()
                      .then((value) => {model.setProfilePicture(value)})
                },
                onDelete: () => {
                  setState(() {
                    if (editingInstructor != null)
                      editingInstructor!.profilePic = null;
                  })
                },
              ),
              horizontalSpaceSmall,
            ]));
  }
}
