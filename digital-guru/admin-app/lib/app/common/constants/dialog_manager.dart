import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:digiguru/app/common/locator.dart';
import 'package:digiguru/app/common/model/dialog_models.dart';
import 'package:digiguru/app/common/service/dialog_service.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key? key, required this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    var isConfirmationDialog = request.cancelTitle != null;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(request.title),
              content: Text(request.description),
              actions: <Widget>[
                if (isConfirmationDialog)
                  BusyButton(
                    title: request.cancelTitle,
                    onPressed: () {
                      _dialogService
                          .dialogComplete(DialogResponse(confirmed: false));
                    },
                  ),
                BusyButton(
                  title: request.buttonTitle,
                  onPressed: () {
                    _dialogService
                        .dialogComplete(DialogResponse(confirmed: true));
                  },
                ),
              ],
            ));
  }
}
