import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/business/model/bisuness_view_model.dart';
import 'package:digiguru/app/common/widget/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class InvoiceView extends StatefulWidget {
  InvoiceView({Key? key}) : super(key: key);

  @override
  _InvoiceViewState createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  final bnameController = TextEditingController();
  final punchLineController = TextEditingController();
  //final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final contactEmailController = TextEditingController();
  final urlController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessViewModel>.reactive(
        viewModelBuilder: () => BusinessViewModel(),
        onViewModelReady: (model) {},
        builder: (context, model, child) => SafeArea(
              child: CommonScaffold(
                  model: model,
                  appTitle: Strings.invoiceViewTitle,
                  showBottomNav: false,
                  //bottomNavigationBar: businessBottomNavBar(context, 1),
                  bodyData: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  )
                  ,body:Center()),
            ));
  }

  _buildActionButtonBar(BusinessViewModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BusyButton(
          title: 'Save',
          busy: model.busy,
          onPressed: () {
            model.save(
              name: bnameController.text,
              punchLine: punchLineController.text,
              // description: descriptionController.text,
              email: emailController.text,
              contactEmail: contactEmailController.text,
              phone: phoneController.text,
              url: urlController.text,
              country: '',
            );
          },
        ),
        horizontalSpaceTiny,
        BusyButton(
          title: 'Legals',
          busy: model.busy,
          onPressed: () {
            model.navigateToLegals();
          },
        ),
        horizontalSpaceTiny,
        BusyButton(
          title: 'Instructors',
          busy: model.busy,
          onPressed: () {
            model.navigateToInstructors();
          },
        ),
        horizontalSpaceTiny,
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () {
            model.cancel();
          },
        ),
      ],
    );
  }
}
