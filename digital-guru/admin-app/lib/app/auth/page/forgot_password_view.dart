import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/input_field.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:digiguru/app/auth/model/login_view_model.dart';

class ForgotPasswordView extends StatelessWidget {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 150,
                  child: Image.asset('assets/images/title.png'),
                ),
                // Text(Strings.enterEmail),
                verticalSpaceSmall,
                InputField(
                  label: Strings.enterEmail,
                  placeholder: Strings.email,
                  controller: emailController,
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BusyButton(
                      title: Strings.send,
                      busy: model.busy,
                      onPressed: () {
                        model.sendForgotPasswordLinkEmail(
                            email: emailController.text);
                      },
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
