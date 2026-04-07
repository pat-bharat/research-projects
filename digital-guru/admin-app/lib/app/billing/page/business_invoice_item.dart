import 'package:digiguru/app/billing/model/business_invoice.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:flutter/material.dart';

class BusinessInvoiceItem extends StatelessWidget {
  final BusinessInvoice invoice;
  final Function onView;
  //final bool isAdmin;

  const BusinessInvoiceItem(
      {Key? key, required this.invoice, required this.onView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      //margin: const EdgeInsets.only(top: 20),
      decoration: boxDecoration(context),
      //alignment: Alignment.center,
      child: Container(),
    );
  }

  Row _buildActionIconsRow(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        IconButton(
          color: Theme.of(context).iconTheme.color,
          icon: Icon(Icons.edit),
          tooltip: "View Invoice",
          onPressed: () {
            onView();
          },
        ),
      ],
    );
  }
}
