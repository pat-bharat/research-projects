import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/system/model/system_dashboard_view_model.dart';
import 'package:digiguru/app/system/model/system_legal.dart';
import 'package:digiguru/app/system/service/system_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SystemLegalView extends StatefulWidget {
  SystemLegalView({Key? key}) : super(key: key);
  @override
  _SystemLegalViewState createState() => _SystemLegalViewState();
}

class _SystemLegalViewState extends State<SystemLegalView> {
  List<SystemLegal> businessLegalList = List.empty(growable: true);
  List<SystemLegal> cosumerLegalList = List.empty(growable: true);

  late SystemDashBoardViewModel model;
  void initState() {
    super.initState();
    model = SystemDashBoardViewModel();
    getSystemLegals();
  }

  void getSystemLegals() async {
    List<SystemLegal> bLigelas = await model.getAllSystemLegals(true);
    List<SystemLegal> cLigelas = await model.getAllSystemLegals(false);
    setState(() {
      businessLegalList = bLigelas;
      cosumerLegalList = cLigelas;
    });
  }

  @override
  Widget build(BuildContext context) {
    portraitModeOnly();
    return ViewModelBuilder<SystemDashBoardViewModel>.reactive(
      viewModelBuilder: () => SystemDashBoardViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(),
            )),
      ),
    );
  }
}
