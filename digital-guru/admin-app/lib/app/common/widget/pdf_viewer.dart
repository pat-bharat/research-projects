import 'package:advanced_pdf_viewer/advanced_pdf_viewer.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/base_model.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:flutter/material.dart';

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
  final AdvancedPdfViewerController _pdfController =
      AdvancedPdfViewerController();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    if (widget.url != null) {
      setState(() => _isLoading = false);
    } else {
      setState(() => _isLoading = false);
      //showToast(context, 'Failed to load document');
      _navigationService.pop();
    }
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
      child: AdvancedPdfViewer.network(
        widget.url!,
        controller: _pdfController,
        key: ValueKey(widget.url),
        config: PdfViewerConfig(
          showTextButton: true,
          drawColor: Colors.red,
          allowFullScreen: false,
          showZoomButtons: true,
          toolbarColor: Colors.white,
          enablePageNumber: true,

          language: PdfViewerLanguage.arabic,

          onFullScreenInit: () {
            //log('full screen initialized');
          },
          showBookmarkButton: true,
          enableBookmarks: true,
          showBookmarksListButton: true,

          // showToolbarSettings: false,
          toolbarStyle: PdfToolbarStyle(
              // activeColor: Colors.red,
              // inactiveColor: Colors.black,
              // useBlur: true,
              // blurSigma: 100,
              // backgroundColor: Colors.orange,
              // elevation: 20,
              ),

          // bookmarkStorageKey: ,
          highlightColor: Color(
            0x8000FF00,
          ), // Semi-transparent green
        ),
      ),
    );
  }
}
