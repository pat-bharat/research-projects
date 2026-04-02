import 'dart:io';

import 'package:digiguru/app/business/model/business_legal.dart';
import 'package:digiguru/app/business/service/business_service.dart';
import 'package:digiguru/app/common/constants/media_types.dart';
import 'package:digiguru/app/common/constants/route_names.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';
import 'package:digiguru/app/common/service/navigation_service.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/media_tile.dart';
import 'package:digiguru/app/firebase_services/service/cloud_storage_service.dart';
import 'package:flutter/material.dart';

class BusinessLegalItem extends StatefulWidget {
  // final List<SystemLegal> systemLegals;
  final BusinessLegal businessLegal;
  final Function()? onDeleteItem;
  final Function()? onEditItem;
  final bool? isAdmin;

  const BusinessLegalItem(
      {Key? key,
      // @required this.systemLegals,
      required this.businessLegal,
      this.onDeleteItem,
      this.onEditItem,
      this.isAdmin})
      : super(key: key);

  @override
  _BusinessLegalItemState createState() => _BusinessLegalItemState();
}

class _BusinessLegalItemState extends State<BusinessLegalItem> {
  //SystemLegal _selectedLegal;
  File? pdfFile;
  final NavigationService _navigationService = locator<NavigationService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  final BusinessService _businessService = locator<BusinessService>();
  final DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(right: 10, top: 5),
      alignment: Alignment.center,
      child: _buildBusinessLegalPanel(context, widget.businessLegal),
    );
  }

  _buildBusinessLegalPanel(BuildContext context, BusinessLegal businessLegal) {
    return Container(
      //height: MediaQuery.of(context).size.height / 5,
      decoration: boxDecoration(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              horizontalSpaceSmall,
              Text(
                businessLegal.title,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      Strings.createdOn +
                          (businessLegal.createdTimestamp ?? " "),
                      style: Theme.of(context).textTheme.bodySmall),
                  Text(
                      Strings.updatedOn+
                          (businessLegal.updatedTimestamp ?? " "),
                      style: Theme.of(context).textTheme.bodySmall),
                  Text(
                      Strings.modifiedBy +
                          (businessLegal.modifiedBy ?? " "),
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: MediaTile(
                    label: Strings.document,
                    height: 60,
                    width: 100,
                    isEditing: true,
                    mediaType: MediaTypes.DOCUMENT,
                    localFile: pdfFile,
                    mediaLink: businessLegal.pdfDoc,
                    onTap: () {
                      if (widget.onEditItem != null) {
                        setState(() {
                          widget.onEditItem!();
                        });
                      }
                    },
                    onDelete: null,
                    onView: () {
                      _navigationService.navigateTo(ViewPdfRoute,
                          arguments: widget.businessLegal.pdfDoc);
                    },
                  ),
                ),
                horizontalSpaceSmall,
                buildToolTip(
                    context,
                    Strings.tapToadd +
                        businessLegal.title +
                        '"'),
              ]),
          verticalSpaceSmall,
          /* Text("Change :", style: textStyle_medium_b),
          DropdownButton<Legal>(
            items: widget.systemLegals.map((e) {
              return DropdownMenuItem(
                  child: Text('${e.title}', style: textStyle_medium_b),
                  value: e);
            }).toList(),
            // hint: Text("Select Instructor"),
            onChanged: (newBehavior) {
              setState(() => _selectedLegal = newBehavior);
            },
            value: _selectedLegal,
            //dropdownColor: Colors.grey,
          ),*/
        ],
      ),
    );
  }
}
