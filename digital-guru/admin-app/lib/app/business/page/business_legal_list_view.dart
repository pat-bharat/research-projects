import 'package:digiguru/app/business/model/business_legal.dart';
import 'package:digiguru/app/business/model/business_legal_list_model.dart';
import 'package:digiguru/app/business/page/business_legal_item.dart';
import 'package:digiguru/app/business/service/business_legal_service.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/creation_aware_list_item.dart';
import 'package:digiguru/app/system/model/system_legal.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BusinessLegalListView extends StatefulWidget {
  BusinessLegalListView({Key? key}) : super(key: key);

  @override
  _BusinessListViewState createState() => _BusinessListViewState();
}

class _BusinessListViewState extends State<BusinessLegalListView> {
  final BusinessLegalService _systemService = locator<BusinessLegalService>();
  List<SystemLegal> systemLegalList = List.empty(growable: true);

  Future getAllConsumerLegals() async {
    List<SystemLegal> _legalList = List.empty(growable: true);
    _systemService.getConsumerLegals().then((legals) {
      _legalList.addAll(legals);
    });
    setState(() {
      systemLegalList = _legalList;
    });
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    getAllConsumerLegals();
  }

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return ViewModelBuilder<BusinessLegalListModel>.reactive(
      viewModelBuilder: () => BusinessLegalListModel(),
      onModelReady: (model) => model.listenToBusinessLegals(),
      builder: (context, model, child) => SafeArea(
          child: CommonScaffold(
        appTitle: Strings.businessLegalListTitle,
        model: model,
        bodyData: Padding(
          padding: listPadding,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              verticalSpace(5),
              if (model.showMainBanner) _buildRemoteConfigBanner(context),
              Expanded(
                  child: ListView(
                children: <Widget>[
                  for (final item in BusinessLegalListModel.getBusinessLegals)
                    _buildBusinessLegalCard(systemLegalList, model, item),
                ],
              )),
              // _buildBottomButtonRaw(model),
              verticalSpaceSmall,
            ],
          ),
        ),
        body: Center(),
      )),
    );
  }

  _buildRemoteConfigBanner(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: boxDecoration(context),
        alignment: Alignment.center,
        child: Text(
          'Banner from emote Config',
          textAlign: TextAlign.center,
        ));
  }

/*
  _buildBottomButtonRaw(BusinessLegalListModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BusyButton(
            title: "Add BusinessLegal",
            onPressed: () => {model.navigateToAddInstructorToBusiness()}),
        horizontalSpaceSmall,
      ],
    );
  }
*/
  _buildBusinessLegalCard(List<SystemLegal> systemLegals,
      BusinessLegalListModel model, BusinessLegal item) {
    return Card(
      //color: Colors.blueGrey,
      key: ValueKey(item.documentId),
      elevation: 2,
      child: CreationAwareListItem(
        child: GestureDetector(
          // onTap: () => model.editCourse(index),
          child: BusinessLegalItem(
            isAdmin: model.isAdmin,
            //systemLegals: systemLegals,
            businessLegal: item,
            onEditItem: () => model.updateBusinessLegal(item),
            //onEditItem: () => model.editBusinessLegal(item),
          ),
        ),
      ),
    );
  }
}
