import 'package:digiguru/app/business/model/business.dart';
import 'package:digiguru/app/common/constants/media_types.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/constants/tooltips.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/bottom_nav_bar.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/drawer.dart';
import 'package:digiguru/app/common/widget/input_field.dart';
import 'package:digiguru/app/common/widget/media_tile.dart';
import 'package:digiguru/app/business/model/bisuness_view_model.dart';
import 'package:digiguru/app/common/widget/text_link.dart';
import 'package:digiguru/app/common/widget/top_navigation_bar.dart';
import 'package:digiguru/app/system/model/system_legal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:stacked/stacked.dart';

class BusinessView extends StatefulWidget {
  final Business editingBusiness;

  BusinessView({Key key, this.editingBusiness}) : super(key: key);

  @override
  _BusinessViewState createState() => _BusinessViewState();
}

class _BusinessViewState extends State<BusinessView> {
  final bnameController = TextEditingController();
  final punchLineController = TextEditingController();
  String _country = "US";
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final contactEmailController = TextEditingController();
  final urlController = TextEditingController();

  String businesssName = "";
  String punchline = "";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var _businessFormKey = GlobalKey<FormState>();

  bool _tocAccepted;
  bool _privacyPolicyAccepted;
  List<SystemLegal> _legals = List.empty(growable: true);

  BusinessViewModel model;
  @override
  void initState() {
    super.initState();
    model = BusinessViewModel();
    if (widget.editingBusiness == null) {
      getSystemBusinessLegals();
    }
  }

  Future getSystemBusinessLegals() async {
    List<SystemLegal> lgls = List.empty(growable: true);
    await model
        .getSystemBusinessOnlyLegals()
        .then((value) => {lgls.addAll(value)});

    setState(() {
      _legals = lgls;
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessViewModel>.reactive(
        viewModelBuilder: () => model,
        onModelReady: (model) {
          if (widget.editingBusiness != null) {
            // update the text in the controller
            bnameController.text = widget.editingBusiness?.name ?? '';
            businesssName = widget.editingBusiness?.name ?? '';
            punchLineController.text = widget.editingBusiness?.punchLine ?? '';

            _country = widget.editingBusiness?.country ?? 'US';
            phoneController.text = widget.editingBusiness?.mobilePhone ?? '';
            emailController.text = widget.editingBusiness?.emailId ?? '';
            contactEmailController.text =
                widget.editingBusiness?.contactEmail ?? '';
            urlController.text = widget.editingBusiness?.url ?? '';
            model.setEditingBusiness(widget.editingBusiness);
          }
        },
        builder: (context, model, child) => SafeArea(
              child: CommonScaffold(
                  appTitle: Strings.businessViewTtile,
                  model: model,
                  bottomNavBarIndex: 0,
                  showDrawer: false,
                  bodyData: SingleChildScrollView(
                    padding: viewPadding,
                    child: Form(
                      key: _businessFormKey,
                      child: _buildFields(context, model),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  )),
            ));
  }

  Column _buildFields(BuildContext context, BusinessViewModel model) {
    return Column(
      //mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        verticalSpaceMedium,
        InputField(
          label: Strings.businessName,
          placeholder: Strings.businessName,
          tooltip: Tooltips.businessName,
          controller: bnameController,
          validator: RequiredValidator(
              errorText: Strings.businessName + Strings.required),
        ),
        InputField(
          label: Strings.websiteUrl,
          placeholder: Strings.websiteUrl,
          controller: urlController,
          tooltip: Tooltips.businessUrl,
        ),
        IntlPhoneField(
          initialValue: phoneController.text,
          initialCountryCode: _country,
          style: Theme.of(context).textTheme.bodyText1,
          decoration: InputDecoration(
            labelText: Strings.mobileNumber,
            border: OutlineInputBorder(),
            hintText: Strings.mobileNumber,
            suffixIcon: buildToolTip(context, Tooltips.mobileNumber),
            contentPadding:
                new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          ),
          onChanged: (phone) {
            _country = phone.countryISOCode;
            phoneController.text = phone.number;
          },
        ),
        verticalSpaceSmall,
        InputField(
          label: Strings.loginEmail,
          placeholder: Strings.loginEmail,
          controller: emailController,
          isReadOnly: true,
          tooltip: Tooltips.loginEmail,
        ),
        Container(
            decoration: boxDecoration(context),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MediaTile(
                  label: Strings.logo,
                  height: 70,
                  width: 70,
                  isEditing: widget.editingBusiness != null,
                  mediaType: MediaTypes.IMAGE,
                  localFile: model.logoImage,
                  mediaLink: widget.editingBusiness != null
                      ? widget.editingBusiness.logoLink
                      : null,
                  onTap: () => model.selectLogoImage(),
                  onDelete: () => {
                    setState(() {
                      widget.editingBusiness != null
                          ? widget.editingBusiness.logoLink = null
                          : model.setLogoImage(null);
                    })
                  },
                  onView: () =>
                      {model.viewImage(widget.editingBusiness.logoLink)},
                ),
                MediaTile(
                  label: Strings.splash,
                  height: 70,
                  width: 150,
                  isEditing: widget.editingBusiness != null,
                  mediaType: MediaTypes.IMAGE,
                  localFile: model.bannerImage,
                  mediaLink: widget.editingBusiness != null
                      ? widget.editingBusiness.bannerLink
                      : null,
                  onTap: () => model.selectBannerImage(),
                  onDelete: () => {
                    setState(() {
                      widget.editingBusiness != null
                          ? widget.editingBusiness.bannerLink = null
                          : model.setBannerImage(null);
                    })
                  },
                  onView: () =>
                      {model.viewImage(widget.editingBusiness.logoLink)},
                ),
              ],
            )),
        verticalSpaceMedium,
        _buildActionButtonBar(model),
        if (widget.editingBusiness == null)
          Column(
            children: _buildAcceptLegalsPanel(context, model),
          )
      ],
    );
  }

  _buildActionButtonBar(BusinessViewModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BusyButton(
          title: Strings.save,
          busy: model.busy,
          onPressed: () {
            if (_businessFormKey.currentState.validate()) {
              model.save(
                name: bnameController.text,
                punchLine: punchLineController.text,
                country: _country,
                email: emailController.text,
                contactEmail: contactEmailController.text,
                phone: phoneController.text,
                url: urlController.text,
              );
            }
          },
        ),
        horizontalSpaceSmall,
        BusyButton(
          title: Strings.cancel,
          onPressed: () {
            model.cancel();
          },
        ),
      ],
    );
  }

  _buildAcceptLegalsPanel(BuildContext context, BusinessViewModel model) async {
    List<Widget> widgets = List.empty(growable: true);
    _legals.forEach((legal) {
      widgets.add(
        Row(
          children: [
            Checkbox(
                value: false,
                onChanged: (value) {
                  _tocAccepted = value;
                }),
            TextLink(
              Strings.accept + legal.title,
              onPressed: () {
                model.viewPdf(legal.pdfDoc);
              },
            ),
          ],
        ),
      );
      widgets.add(verticalSpaceSmall);
    });
  }
}
