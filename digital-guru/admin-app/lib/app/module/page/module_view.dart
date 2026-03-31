import 'dart:io';

import 'package:digiguru/app/common/constants/media_types.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/constants/tooltips.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/media_tile.dart';
import 'package:digiguru/app/common/widget/top_navigation_bar.dart';
import 'package:digiguru/app/course/model/course.dart';
import 'package:digiguru/app/module/model/module.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/input_field.dart';
import 'package:digiguru/app/module/model/module_view_model.dart';
import 'package:digiguru/app/video/model/video_info.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:stacked/stacked.dart';
import 'package:spinner_input/spinner_input.dart';

class ModuleView extends StatefulWidget {
  final Module editingModule;
  final Course course;

  ModuleView({Key key, this.editingModule, this.course}) : super(key: key);

  @override
  _ModuleViewState createState() => _ModuleViewState();
}

class _ModuleViewState extends State<ModuleView> {
  final titleController = TextEditingController();
  final instructorNameController = TextEditingController();
  final nameController = TextEditingController();
  final discountController = TextEditingController();
  final priceController = TextEditingController();
  int _discount = 0;
  final tagController = TextEditingController();

  bool _published = false;

  ModuleBackground background = new ModuleBackground();
  ModuleDetailDoc moduleDetailDoc = new ModuleDetailDoc();
  VideoInfo moduleVideo = new VideoInfo();
  List<String> tags = new List<String>.empty(growable: true);
  List<PricePlan> pricePlans = List<PricePlan>.empty(growable: true);
  Course course;
  Module editingModule;

  final _moduleViewKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    course = widget.course;
    editingModule = widget.editingModule;
  }

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return ViewModelBuilder<ModuleViewModel>.reactive(
      viewModelBuilder: () => ModuleViewModel(widget.course),
      onModelReady: (model) {
        if (widget.editingModule != null) {
          // update the text in the controller
          titleController.text = editingModule?.title ?? '';
          nameController.text = editingModule?.name ?? '';
          //discountController.text = editingModule?.discountPercentage ?? '';
          _discount = editingModule?.discountPercentage ?? 0;
          tagController.text =
              editingModule.tags != null ? editingModule.tags.join(',') : '';
          priceController.text = editingModule?.purchaseAmount.toString() ?? '';
          background =
              editingModule?.moduleBackground ?? new ModuleBackground();
          moduleDetailDoc =
              editingModule?.moduleDetailDoc ?? new ModuleDetailDoc();
          moduleVideo = editingModule?.moduleVideo ?? new ModuleVideo();
          pricePlans = editingModule?.pricePlan ??
              new List<PricePlan>.empty(growable: true);
          _published = editingModule?.published ?? false;
          model.setEditingModule(editingModule);
        }
      },
      builder: (context, model, child) => SafeArea(
        child: CommonScaffold(
            appTitle: Strings.moduleViewTitle,
            showDrawer: false,
            model: model,
            bottomNavBarIndex: 0,
            bodyData: SingleChildScrollView(
              padding: viewPadding,
              child: Form(
                key: _moduleViewKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: _buildFields(context, model),
              ),
            )),
      ),
    );
  }

  Widget _buildFields(BuildContext context, ModuleViewModel model) {
    return Column(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        verticalSpaceSmall,
        InputField(
          placeholder: Strings.moduleName,
          label: Strings.moduleName,
          controller: nameController,
          validator: RequiredValidator(errorText: Strings.required),
        ),
        InputField(
          label: Strings.mduleTitle,
          placeholder: Strings.mduleTitle,
          controller: titleController,
          validator: RequiredValidator(errorText: Strings.required),
        ),
        InputField(
          label: Strings.purchasedAmount,
          placeholder: Strings.purchasedAmount,
          controller: priceController,
          textInputType: TextInputType.number,
          validator: RequiredValidator(errorText: Strings.required),
        ),
        Row(
          children: [
            horizontalSpaceSmall,
            Text(
              Strings.moduleDiscount,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            horizontalSpaceMedium,
            SpinnerInput(
                spinnerValue: _discount.toDouble(),
                minValue: 0,
                maxValue: 100,
                fractionDigits: 0,
                plusButton: SpinnerButtonStyle(
                    elevation: 0,
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(15)),
                minusButton: SpinnerButtonStyle(
                    elevation: 0,
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(15)),
                middleNumberWidth: 60,
                middleNumberStyle: Theme.of(context).textTheme.bodyText1,
                middleNumberBackground: Colors.grey[200].withOpacity(0.7),
                onChange: (newValue) {
                  setState(() {
                    _discount = newValue.toInt();
                  });
                }),
            horizontalSpaceMedium,
            buildToolTip(context, Tooltips.moduleDiscountOffer),
          ],
        ),
        verticalSpaceSmall,
        Row(
          children: [
            GFToggle(
              onChanged: (val) {
                setState(() {
                  _published = val;
                });
              },
              value: _published,
              type: Platform.isIOS ? GFToggleType.ios : GFToggleType.android,
            ),
            /*new Checkbox(
                value: _published,
                activeColor: Colors.grey,
                onChanged: (value) {
                  setState(() {
                    _published = value;
                  });
                }),*/
            new Text(Strings.publish),
            horizontalSpaceMedium,
            buildToolTip(context, Tooltips.mustPublishModule),
          ],
        ),
        verticalSpaceMedium,
        InputField(
          label: Strings.moduleTagLabel,
          maxLines: 2,
          maxLength: 100,
          textInputType: TextInputType.multiline,
          smallVersion: false,
          validator: RequiredValidator(errorText: Strings.required),
          placeholder: Strings.moduleTags,
          tooltip: Tooltips.moduleTagsPlaceHolder,
          controller: tagController,
        ),
        Container(
            decoration: boxDecoration(context),
            child: Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                horizontalSpaceSmall,
                MediaTile(
                  label: Strings.background,
                  mediaType: MediaTypes.IMAGE,
                  isEditing: editingModule != null,
                  height: 70,
                  width: 100,
                  localFile: model.backgroundImage,
                  mediaLink: background.imageUrl,
                  onTap: () => {
                    model
                        .selectBannerImage()
                        .then((v) => {model.setBackgroundImage(v)})
                  },
                  onDelete: () => {
                    setState(() {
                      if (editingModule != null)
                        editingModule.moduleBackground.imageUrl = "";
                    })
                  },
                ),
                horizontalSpaceMedium,
                MediaTile(
                  label: Strings.document,
                  mediaType: MediaTypes.DOCUMENT,
                  isEditing: editingModule != null,
                  height: 70,
                  width: 100,
                  localFile: model.moduleDetailDocument,
                  mediaLink: moduleDetailDoc.docUrl,
                  onTap: () => {
                    model
                        .selectModuleDocument()
                        .then((v) => {model.setModuleDetailDocument(v)})
                  },
                  onDelete: () => {
                    setState(() {
                      if (editingModule != null)
                        editingModule.moduleDetailDoc = null;
                    })
                  },
                ),
                horizontalSpaceMedium,
                MediaTile(
                  label: Strings.video,
                  mediaType: MediaTypes.VIDEO,
                  isEditing: editingModule != null,
                  height: 70,
                  width: 100,
                  localFile: model.moduleVideo,
                  mediaLink: moduleVideo.videoUrl,
                  onTap: () => {
                    model
                        .selectModuleVideo()
                        .then((v) => {model.setModuleVideo(v)})
                  },
                  onDelete: () => {
                    setState(() {
                      if (editingModule != null)
                        editingModule.moduleVideo.videoUrl = "";
                    })
                  },
                ),
              ],
            )),
        verticalSpaceSmall,
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BusyButton(
                title: Strings.save,
                busy: model.busy,
                onPressed: () {
                  if (_moduleViewKey.currentState.validate()) {
                    model.save(
                        courseId: course.documentId,
                        name: nameController.text,
                        title: titleController.text,
                        purchaseAmount: double.tryParse(priceController.text),
                        discountPercentage: _discount,
                        published: _published,
                        tagData: tagController.text,
                        pricePlan: pricePlans,
                        background: background,
                        moduleDetailDoc: moduleDetailDoc,
                        moduleVideo: moduleVideo);
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
        verticalSpaceSmall,
      ],
    );
  }
}
