import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:digiguru/app/common/widget/top_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class PdfViewer extends StatefulWidget {
  final String? url;
  PdfViewer({
    Key? key,
    this.url,
  }) : super(key: key);
  @override
  _PdfViewwerState createState() => _PdfViewwerState();
}

class _PdfViewwerState extends State<PdfViewer> {
  bool _isLoading = true;
  PDFDocument? document;
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    try {
      if (widget.url != null) {
        document = await PDFDocument.fromURL(widget.url!);
      }
    } catch (e) {
      print(e);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    //portraitModeOnly();
    return SafeArea(
      child: CommonScaffold(
          model: BaseModel(),
          appTitle: Strings.document,
          showBottomNav: false,
          showDrawer: false,
          body: Center(
            child: _isLoading
                ? Center(child: buildCircularLoader(context))
                : _buildPdfViewer(context),
          )),
    );
  }

  _buildPdfViewer(BuildContext context) {
    return Container(
      height: screenHeight(context),
      width: screenWidth(context),
      child: PDFViewer(
        document: document!,
        zoomSteps: 1,
        
        pickerIconColor: Theme.of(context).scaffoldBackgroundColor,
        pickerButtonColor: Theme.of(context).primaryColor,
        indicatorBackground: Theme.of(context).primaryColor,
        showNavigation: false,
        indicatorText: Theme.of(context).scaffoldBackgroundColor,
        showPicker: true,
        showIndicator: true,
      ),
    );
  }
}
