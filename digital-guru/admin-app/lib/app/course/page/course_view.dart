import 'dart:io';

import 'package:digiguru/app/auth/service/authentication_service.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/common/constants/media_types.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/enums.dart';
import 'package:digiguru/app/common/service/base_service.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/media_tile.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/input_field.dart';
import 'package:digiguru/app/course/model/course_view_model.dart';
import 'package:digiguru/app/video/model/video_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
//import 'package:form_field_validator/form_field_validator.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class CourseView extends StatefulWidget {
  final Course editingCourse;

  CourseView({Key key = const ValueKey('CourseView'), required this.editingCourse}) : super(key: key);

  @override
  _CourseViewState createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  final courseTitleController = TextEditingController();
  final instructorNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final urlController = TextEditingController();
  CourseBackground background = new CourseBackground();
  CourseDetailDoc courseDetailDoc = new CourseDetailDoc();
  VideoInfo courseVideo = new VideoInfo();
  late File backgroundImageFile, courseDetailDocFile, videoFile;
  // List<CourseMedia> medias = List.empty(growable: true);
  bool? _published = false;
  String? _language = Language.english;
  String? _instructor;
  Course? editingCourse;
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final BusinessService _businessService = locator<BusinessService>();

  List<String> instructors = List.empty(growable: true);

  final _courseFormKey = GlobalKey<FormState>();

  Future getInstructors() async {
    List<String> _instructors = List.empty(growable: true);
    await _businessService
        .getAllInstructors(BaseService.currentBusiness.id ?? '')
        .then((instructor) => {_instructors.addAll(instructor)});

    setState(() {
      instructors = _instructors;
    });
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    editingCourse = widget.editingCourse;
    getInstructors();
  }

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return ViewModelBuilder<CourseViewModel>.reactive(
        viewModelBuilder: () => CourseViewModel(),
        onModelReady: (model) {
          if (editingCourse != null) {
            // update the text in the controller
            courseTitleController.text = editingCourse?.title ?? '';
            descriptionController.text = editingCourse?.description ?? '';
            instructorNameController.text = editingCourse?.instructorName ?? '';
            phoneController.text = editingCourse?.instructorPhone ?? '';
            emailController.text = editingCourse?.instructorEmail ?? '';
            background = editingCourse?.background ?? new CourseBackground();
            courseDetailDoc =
                editingCourse?.courseDetailDoc ?? new CourseDetailDoc();
            courseVideo = editingCourse?.courseVideo ?? new VideoInfo();
            //medias = editingCourse?.courseMedia ?? model.defaultMedias();
            // courseMedia = editingCourse?.courseMedia ?? null;

            courseTitleController.text = editingCourse?.title ?? '';
            _instructor = editingCourse?.instructorName ?? '';
            if (editingCourse != null) {
              model.setEditingCourse(editingCourse!);
            }
          }
        },
        builder: (context, model, child) => SafeArea(
              child: CommonScaffold(
                  appTitle: Strings.courseViewTitle,
                  showAppbar: true,
                  showDrawer: false,
                  model: model,
                  showBottomNav: true,
                  bottomNavBarIndex: 0,
                  bodyData: SingleChildScrollView(
                    padding: viewPadding,
                    child: Form(
                      key: _courseFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: _buildFields(context, model),
                    ),
                  ),
                  body: Center(),)
            ));
  }

  Column _buildFields(BuildContext context, CourseViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // TopNavigationBar(model: model, text: "Course Details"),
        verticalSpaceMedium,
        InputField(
          label: Strings.courseTitle,
          placeholder: Strings.courseTitle,
          controller: courseTitleController,
          validator: RequiredValidator(errorText: Strings.required),
        ),
        InputField(
          label: Strings.description,
          placeholder: Strings.courseDescription,
          maxLines: 2,
          maxLength: 100,
          textInputType: TextInputType.multiline,
          smallVersion: false,
          controller: descriptionController,
        ),
        Row(children: [
          horizontalSpaceSmall,
          Text(Strings.selectInstructor),
          horizontalSpaceSmall,
          instructors.isNotEmpty
              ? DropdownButton<String>(
                  items: instructors.map((e) {
                    return DropdownMenuItem(
                        child: Text('${e}',
                            style: Theme.of(context).textTheme.headlineSmall),
                        value: e);
                  }).toList(),
                  // hint: Text("Select Instructor"),
                  onChanged: (newBehavior) {
                    setState(() => _instructor = newBehavior);
                  },
                  value: _instructor,
                  //dropdownColor: Colors.grey,
                )
              : Text(Strings.addInstructor),
        ]),
        Row(children: [
          horizontalSpaceSmall,
          Text(Strings.courseLanguage),
          horizontalSpaceMedium,
          DropdownButton<String>(
            items: Language.values.map((e) {
              return DropdownMenuItem(
                  child: Text('${e}',
                      style: Theme.of(context).textTheme.headlineSmall),
                  value: e);
            }).toList(),
            onChanged: (newBehavior) {
              setState(() => _language = newBehavior);
            },
            value: _language,
          ),
          horizontalSpaceMedium,
        ]),
        verticalSpaceSmall,
        /* horizontalSpaceMedium,
            GFToggle(              
              onChanged: (val) {
                setState(() {
                  _published = val;
                });
              },
              value: _published,
              type: GFToggleType.ios,
            ),
            Checkbox(
                value: _published,
                // activeColor: Theme.of(context).primaryColor,
                // checkColor: Theme.of(context).accentColor,
                onChanged: (bool? newValue) {
                  setState(() {
                    _published = newValue ?? false;
                  });
                }),
            new Text("Publish"),
            horizontalSpaceMedium,*/

        _buildMediaUploadPanel(context, model),
        verticalSpaceMedium,
        _buildActionBar(context, model),
      ],
    );
  }

  Row _buildActionBar(BuildContext context, CourseViewModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BusyButton(
          title: 'Save',
          busy: model.busy,
          onPressed: () {
            if (_courseFormKey.currentState!.validate()) {
              model.save(
                  title: courseTitleController.text,
                  instructorName: _instructor ?? '',
                  description: descriptionController.text,
                  language: _language.toString(),
                  instructorEmail: emailController.text,
                  instructorPhone: phoneController.text,
                  background: background,
                  courseDetailDoc: courseDetailDoc,
                  courseVideo: courseVideo);
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(Strings.dialogFailed)));
            }
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

  Container _buildMediaUploadPanel(
      BuildContext context, CourseViewModel model) {
    return Container(
        decoration: boxDecoration(context),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              MediaTile(
                label: Strings.background,
                mediaType: MediaTypes.IMAGE,
                isEditing: model.isEditingCourse != null,
                height: 100,
                width: 100,
                localFile: model.backgroundImage,
                mediaLink: background.imageUrl,
                onTap: () => {
                  model
                      .selectBannerImage()
                      .then((value) => {model.setBannerImage(value)})
                },
                onView: () => {
                  setState(() {
                    if (editingCourse != null &&
                        editingCourse!.background?.imageUrl != null)
                      model.viewImage(editingCourse!.background!.imageUrl!);
                    if (editingCourse?.background?.imageUrl != null)
                      print("viewing: " + (editingCourse!.background!.imageUrl ?? ""));
                  })
                },
                onDelete: () => {
                  setState(() {
                    if (editingCourse != null)
                      editingCourse!.background!.imageUrl = "";
                  })
                },
              ),
              horizontalSpaceSmall,
              MediaTile(
                label: Strings.document,
                mediaType: MediaTypes.DOCUMENT,
                isEditing: model.isEditingCourse != null,
                height: 100,
                width: 100,
                localFile: model.syllabusDocument,
                mediaLink: courseDetailDoc.docUrl,
                onTap: () => {
                  model
                      .selectCouseSyllabusImage()
                      .then((v) => {model.setSyllabusDocument(v)})
                },
                onView: () => {
                  setState(() {
                    if (editingCourse != null &&
                        editingCourse!.courseDetailDoc?.docUrl != null)
                      model.viewPdf(editingCourse!.courseDetailDoc!.docUrl!);
                    print("viewing: " + (editingCourse?.background?.imageUrl ?? ""));
                  })
                },
                onDelete: () => {
                  setState(() {
                    if (editingCourse != null)
                      editingCourse!.courseDetailDoc!.docUrl = "";
                  })
                },
              ),
              horizontalSpaceSmall,
              MediaTile(
                label: Strings.video,
                mediaType: MediaTypes.VIDEO,
                isEditing: model.isEditingCourse != null,
                height: 100,
                width: 100,
                localFile: model.videoFile,
                mediaLink: courseVideo.thumbUrl,
                onTap: () => {
                  model
                      .selectCourseVideo()
                      .then((v) => {model.setCourseVideo(v)})
                },
                onView: () => {
                  setState(() {
                    if (editingCourse != null &&
                        editingCourse!.courseVideo!.videoUrl != null)
                      model.viewVideo(editingCourse!.courseVideo!);
                    print("viewing: " + (editingCourse!.courseVideo!.videoUrl ?? ""));
                  })
                },
                onDelete: () => {
                  setState(() {
                    if (editingCourse != null)
                      editingCourse!.courseVideo!.videoUrl = "";
                  })
                },
              ),
            ]));
  }
}
