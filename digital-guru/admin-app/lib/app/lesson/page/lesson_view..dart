import 'package:digiguru/app/common/constants/media_types.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/media_tile.dart';
import 'package:digiguru/app/common/widget/top_navigation_bar.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/lesson/model/lesson.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/input_field.dart';
import 'package:digiguru/app/lesson/model/lesson_view_model.dart';
import 'package:digiguru/app/video/model/video_info.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stacked/stacked.dart';

class LessonView extends StatefulWidget {
  final Lesson editingLesson;
  final Module module;
  final Course course;
  LessonView({Key? key, required this.course, required this.editingLesson, required this.module})
      : super(key: key);
  @override
  _LessonViewState createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  final titleController = TextEditingController();
  final instructorNotesController = TextEditingController();
  bool _freeTrial = false;
  late Lesson editingLesson;
  late Module _module;
  late Course _course;
  InstructionDoc instructionDoc = new InstructionDoc();
  VideoInfo lessonVideo = new VideoInfo();

  final _lessonViewKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    editingLesson = widget.editingLesson;
    _module = widget.module;
    _course = widget.course;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return ViewModelBuilder<LessonViewModel>.reactive(
        viewModelBuilder: () => LessonViewModel(_course, _module),
        onModelReady: (model) {
          if (editingLesson != null) {
            // update the text in the controller
            titleController.text = editingLesson?.title ?? '';
            instructorNotesController.text =
                editingLesson?.instructorNotes ?? '';
            instructionDoc = editingLesson?.instructionDoc ?? InstructionDoc();
            lessonVideo = editingLesson?.videoInfo ?? VideoInfo();
            _freeTrial = editingLesson?.freeTrial ?? false;
            model.setEditingLesson(editingLesson);
          }
        },
        builder: (context, model, child) => SafeArea(
              child: CommonScaffold(
                  appTitle: Strings.lessonViewTitle,
                  showDrawer: false,
                  model: model,
                  showBottomNav: true,
                  bottomNavBarIndex: 0,
                  bodyData: SingleChildScrollView(
                    padding: viewPadding,
                    child: Form(
                      child: _buildFields(context, model),
                      key: _lessonViewKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  body: Center(),),
            ));
  }

  Widget _buildFields(BuildContext context, LessonViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        verticalSpaceSmall,
        InputField(
          label: Strings.lessonTitle,
          placeholder: Strings.lessonTitle,
          controller: titleController,
          validator: RequiredValidator(errorText: Strings.required),
        ),
        InputField(
          label: Strings.details,
          maxLines: 2,
          maxLength: 100,
          textInputType: TextInputType.multiline,
          smallVersion: false,
          placeholder: Strings.lessonDescription,
          controller: instructorNotesController,
          validator: RequiredValidator(errorText: Strings.required),
        ),
        Row(
          children: [
            Checkbox(
              value: _freeTrial,
              onChanged: (value) {
                setState(() {
                  _freeTrial = value!;
                });
              },
            ),
            Text(Strings.offerAsTrial),
          ],
        ),
        verticalSpaceSmall,
        Container(
            decoration: boxDecoration(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediaTile(
                  label: Strings.document,
                  mediaType: MediaTypes.DOCUMENT,
                  isEditing: model.isEditting,
                  height: 70,
                  width: 70,
                  localFile: model.lessonDetailDocument,
                  mediaLink: instructionDoc.docUrl,
                  onTap: () => {
                    model
                        .selectLessonDocument()
                        .then((v) => {model.setLessonDetailDocument(v)})
                  },
                  onDelete: () => {
                    setState(() {
                      editingLesson.instructionDoc!.docUrl = "";
                    })
                  },
                ),
                horizontalSpaceSmall,
                MediaTile(
                  label: Strings.video,
                  mediaType: MediaTypes.VIDEO,
                  isEditing: model.isEditting,
                  height: 70,
                  width: 70,
                  localFile: model.lessonVideoFile,
                  mediaLink: lessonVideo.thumbUrl,
                  onTap: () => {
                    model
                        .selectLessonVideo()
                        .then((v) => {model.setLessonVideoFile(v)})
                  },
                  onDelete: () => {
                    setState(() {
                      if (model.isEditting)
                        editingLesson.videoInfo!.videoUrl = "";
                    })
                  },
                ),
              ],
            )),
        verticalSpaceMedium,
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BusyButton(
              title: Strings.save,
              busy: model.busy,
              onPressed: () {
                if (_lessonViewKey.currentState?.validate() ?? false) {
                  model.save(
                      moduleId: _module.id,
                      moduleTitle: _module.title,
                      courseTitle: _course.title,
                      instructorName: _course.instructorName,
                      title: titleController.text,
                      instructorNotes: instructorNotesController.text,
                      freeTrial: !_freeTrial,
                      instructionDoc: instructionDoc,
                      videoInfo: lessonVideo);
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
        ),
      ],
    );
  }
}
