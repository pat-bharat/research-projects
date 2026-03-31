import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/model/enums.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/expansion_list.dart';
import 'package:digiguru/app/common/widget/input_field.dart';
import 'package:digiguru/app/signup/model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                verticalSpaceSmall,
                InputField(
                  label: Strings.fullName,
                  placeholder: Strings.fullName,
                  controller: fullNameController,
                ),
                InputField(
                  label: Strings.email,
                  placeholder: Strings.email,
                  controller: emailController,
                ),
                InputField(
                  label: Strings.password,
                  placeholder: Strings.password,
                  password: true,
                  smallVersion: false,
                  controller: passwordController,
                  additionalNote: Strings.pwdAdditionalNote,
                ),
                ExpansionList<String>(
                    items: [UserRole.admin, UserRole.user, UserRole.system],
                    title: model.selectedRole,
                    onItemSelected: model.setSelectedRole),
                verticalSpaceMedium,
                Column(
                  // mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /*BusyButton(
                    title: 'Sign Up',
                    busy: model.busy,
                    onPressed: () {
                      model.signUpWithEmail(
                          email: emailController.text,
                          password: passwordController.text,
                          fullName: fullNameController.text);
                    },
                  ),*/
                    Container(
                      padding: EdgeInsets.all(10),
                      width: screenWidth(context),
                      height: 50,
                      color: Theme.of(context).primaryColor,
                      child: ElevatedButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.mail, size: 25),
                            horizontalSpaceSmall,
                            Text(
                              Strings.signUpWithEmail,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                        onPressed: () {
                          model.signUpWithEmail(
                              email: emailController.text,
                              password: passwordController.text,
                              fullName: fullNameController.text);
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
