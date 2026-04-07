import 'package:digiguru/app/billing/model/business_invoice.dart';
import 'package:digiguru/app/billing/model/business_invoice_list_view_model.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class BusinessInvoiceListView extends StatefulWidget {
  List<BusinessInvoice>? businessInvoice;
  BusinessInvoiceListView({Key? key}) : super(key: key);

  @override
  _BusinessInvoiceListViewState createState() =>
      _BusinessInvoiceListViewState();
}

class _BusinessInvoiceListViewState extends State<BusinessInvoiceListView> {
  // List<BusinessInvoice> invoices;
  late BusinessInvoiceListModel model;
  @override
  void initState() {
    super.initState();
    model = BusinessInvoiceListModel();
    // model.listenToBusinessInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessInvoiceListModel>.reactive(
        viewModelBuilder: () => model,
        onModelReady: (model) {
          model.listenToBusinessInvoices();
        },
        builder: (context, model, child) => SafeArea(
              child: CommonScaffold(
                model: model,
                appTitle: Strings.invoiceListViewTitle,
                bodyData: Padding(
                    padding: listPadding,
                    child: !model.busy
                        ? Column(
                            mainAxisSize: MainAxisSize.max,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                //_buildTitleRow(model),
                                //verticalSpace(5),
                                // if (model.showMainBanner) _buildRemoteConfigBanner(context),
                                Expanded(
                                    child: new ListView(
                                  //padding: const EdgeInsets.all(5),
                                  children: _buildInvoice(context, model),
                                )),
                              ])
                        : buildCircularLoader(context)),
                body: Center(),
              ),
            ));
  }

  _buildInvoice(BuildContext context, BusinessInvoiceListModel model) {
    List<Widget> invoiceList = List.empty(growable: true);
    for (final invoice in model.businessInvoices) {
      invoiceList.add(buildScorabbleAccordian(context,
          headChildren: [
            Text(
              DateFormat.yMMMMd().format(invoice.invoiceDate) +
                  '  ' +
                  Strings.amount +
                  NumberFormat.currency(symbol: '\$', decimalDigits: 2)
                      .format(invoice.invoiceAmount),
              style: Theme.of(context).textTheme.headlineSmall,
            )
          ],
          bodyChildren: buildInvoiceDetails(invoice)));
      // for (final ci in um.courseInfo) {
      /*invoiceList.add(GFAccordion(
        showAccordion: true,
        title: DateFormat.yMMMMd().format(invoice.invoiceDate) +
            '  ' +
            Strings.amount +
            NumberFormat.currency(symbol: '\$', decimalDigits: 2)
                .format(invoice.invoiceAmount),
        contentPadding: const EdgeInsets.all(5),
        textStyle: Theme.of(context).textTheme.headline3,
        collapsedTitleBackgroundColor: Theme.of(context).backgroundColor,
        contentBackgroundColor: Theme.of(context).backgroundColor,
        contentChild: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: buildlBillingItems(invoice)),
      ));*/
    }
    return invoiceList;
  }

  buildInvoiceDetails(BusinessInvoice invoice) {
    List<Widget> billingItems = List.empty(growable: true);
    billingItems.add(Row(children: [
      Text(
        "Paid By " +
            invoice.paidBy +
            " On:" +
            DateFormat.yMMMMd().format(invoice.paidDate),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ]));
    invoice.billingItems.forEach((bi) {
      billingItems.add(Text(
        Strings.quantity +
            bi.quantity.toString() +
            '  ' +
            Strings.rate +
            ' ' +
            NumberFormat.currency(symbol: '\$', decimalDigits: 2)
                .format(bi.rate) +
            '  ' +
            Strings.amount +
            ' ' +
            NumberFormat.currency(symbol: '\$', decimalDigits: 2)
                .format(bi.quantity.toDouble() * bi.rate),
        style: Theme.of(context).textTheme.bodySmall,
      ));
    });
    return billingItems;
  }
}
