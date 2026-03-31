import 'package:digiguru/app/AppConfig.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/enums.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/text_link.dart';
import 'package:digiguru/app/startup/model/accept_legal_model.dart';
import 'package:digiguru/app/startup/model/startup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:stacked/stacked.dart';

class AcceptLegalView extends StatefulWidget {
  const AcceptLegalView({Key key}) : super(key: key);

  @override
  AcceptLegalViewState createState() => AcceptLegalViewState();
}

class AcceptLegalViewState extends State<AcceptLegalView> {
  bool isAdmin;
  AcceptLegalModel model;
  bool _tocAccepted = false;
  bool _provacyPolicyAccepted = false;
  List<dynamic> _legals = List.empty(growable: true);
  final DialogService _dialogService = locator<DialogService>();
  @override
  void initState() {
    super.initState();
    model = AcceptLegalModel();
    getLegals();
  }

  void getLegals() async {
    List<dynamic> legals = List.empty(growable: true);
    await model.getLegalList().then((value) => {
          if (value != null) {legals.addAll(value)}
        });

    setState(() {
      _legals = legals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AcceptLegalModel>.reactive(
      viewModelBuilder: () => model,
      onModelReady: (model) => () {},
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          // backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            height: screenHeight(context),
            width: screenHeightFraction(context),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: _buildAcceptLegalCard(_legals, model)),
          ),
        ),
      ),
    );
  }

  _buildAcceptLegalCard(List<dynamic> legals, AcceptLegalModel model) {
    List<Widget> widgets = List.empty(growable: true);
    if (legals.isEmpty) {
      return widgets;
    }

    legals.forEach((l) {
      if (l.legalType == LegalType.toc) {
        widgets.add(Row(
          children: [
            TextLink("Please read Terms and Conditions", onPressed: () {
              model.viewPdf(l.pdfDoc);
            }, style: Theme.of(context).textTheme.headline2),
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                if (l.pdfDoc != null && l.pdfDoc.length > 0)
                  model.viewPdf(l.pdfDoc);
              },
            ),
          ],
        ));
        widgets.add(Row(
          children: [
            GFToggle(
              onChanged: (val) {
                setState(() {
                  _tocAccepted = val;
                });
              },
              value: _tocAccepted,
              type: GFToggleType.ios,
            ),
            horizontalSpaceSmall,
            Text("Accept " + l.title),
          ],
        ));
      }
      widgets.add(verticalSpaceMedium);
      if (l.legalType == LegalType.privacy_policy) {
        widgets.add(Row(
          children: [
            TextLink("Please read Privacy Polivy", onPressed: () {
              model.viewPdf(l.pdfDoc);
            }, style: Theme.of(context).textTheme.headline2),
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                if (l.pdfDoc != null && l.pdfDoc.length > 0)
                  model.viewPdf(l.pdfDoc);
              },
            ),
          ],
        ));
        widgets.add(Row(
          children: [
            GFToggle(
              onChanged: (val) {
                setState(() {
                  _provacyPolicyAccepted = val;
                });
              },
              value: _provacyPolicyAccepted,
              type: GFToggleType.ios,
            ),
            horizontalSpaceSmall,
            Text("Accept " + l.title),
          ],
        ));
      }
    });
    widgets.add(verticalSpaceMedium);
    widgets.add(Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BusyButton(
            title: Strings.accept,
            onPressed: () {
              if (_tocAccepted && _provacyPolicyAccepted) {
                model.legalAccepted();
              } else {
                _dialogService.showDialog(
                    title: "Error!",
                    description: "You must accept all terms and services!",
                    buttonTitle: "ok");
              }
            }),
        horizontalSpaceMedium,
        BusyButton(
            title: Strings.cancel,
            onPressed: () {
              model.legalCancelled();
            })
      ],
    ));
    return widgets;
    /*return Card(
      //color: Colors.blueGrey,
      key: ValueKey(l.documentId),
      elevation: 2,
      child: Column(children: widgets),
    );*/
  }
}
