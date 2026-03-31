import 'dart:io';

import 'package:digiguru/app/business/model/business_legal.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/system/model/system_legal.dart';
import 'package:flutter/material.dart';

class SystemLegalItem extends StatefulWidget {
  final SystemLegal systemLegal;
  final Function onDeleteItem;
  final Function onEditItem;
  final bool isAdmin;

  const SystemLegalItem(
      {Key key,
      @required this.systemLegal,
      this.onDeleteItem,
      this.onEditItem,
      this.isAdmin})
      : super(key: key);

  @override
  _SystemLegalItemState createState() => _SystemLegalItemState();
}

class _SystemLegalItemState extends State<SystemLegalItem> {
  SystemLegal _selectedLegal;
  File pdfFile;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: lesson.videoInfo != null ? null : 60,
      margin: const EdgeInsets.only(right: 10, top: 5),
      alignment: Alignment.center,
      child: _buildSystemLegalPanel(context, widget.systemLegal),
    );
  }

  _buildSystemLegalPanel(BuildContext context, SystemLegal systemLegal) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      // padding: EdgeInsets.all(5.0),
      //height: screenHeight(context) / 14,
      decoration: boxDecoration(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Text(systemLegal.title,
                    style: Theme.of(context).textTheme.headline2),
              ),
            ],
          ),
          Row(children: [
            Column(children: [
              Text(
                "Created On:",
                style: Theme.of(context).textTheme.headline4,
              )
            ]),
            Column(
              children: [
                Text(
                  systemLegal.createdTimestamp != null
                      ? systemLegal.createdTimestamp
                      : "",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ]),
          Row(
            children: [
              Column(children: [
                Text(
                  "Updated On:",
                  style: Theme.of(context).textTheme.headline4,
                )
              ]),
              Column(children: [
                Text(
                  systemLegal.updatedTimestamp != null
                      ? systemLegal.updatedTimestamp
                      : "",
                  style: Theme.of(context).textTheme.headline4,
                )
              ]),
            ],
          ),
          Row(
            children: [
              Column(children: [
                Text(
                  "Modified By:",
                  style: Theme.of(context).textTheme.headline4,
                )
              ]),
              Column(children: [
                Text(
                  systemLegal.modifiedBy != null ? systemLegal.modifiedBy : "",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
