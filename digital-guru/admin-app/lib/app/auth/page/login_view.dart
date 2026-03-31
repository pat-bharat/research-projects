import 'package:digiguru/app/common/constants/strings.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';
import 'package:digiguru/app/common/widget/busy_button.dart';
import 'package:digiguru/app/common/widget/input_field.dart';
import 'package:digiguru/app/common/widget/text_link.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
//import 'package:form_field_validator/form_field_validator.dart';
import 'package:stacked/stacked.dart';
import 'package:digiguru/app/auth/model/login_view_model.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 150,
                  child: Image.asset('assets/images/title.png'),
                ),
                InputField(
                    label: Strings.email,
                    placeholder: 'Email',
                    controller: emailController,
                    validator: EmailValidator(
                        errorText: 'enter a valid email address')),
                InputField(
                  label: Strings.password,
                  placeholder: 'Password',
                  password: true,
                  controller: passwordController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'password is required'),
                    MinLengthValidator(8,
                        errorText: 'password must be at least 8 digits long'),
                    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                        errorText:
                            'passwords must have at least one special character')
                  ]),
                ),
                verticalSpaceSmall,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: BusyButton(
                        title: Strings.signInWithEmailPassword,
                        busy: model.busy,
                        onPressed: () {
                          model.loginWithEmail(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Row(
                  children: [
                    Expanded(
                      child: BusyButton(
                        title: Strings.signInWithGoogleId,
                        busy: model.busy,
                        onPressed: () {
                          model.loginWithGoogleId('User');
                        },
                      ),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextLink(
                      Strings.signUp,
                      onPressed: () {
                        model.navigateToSignUp();
                      },
                    ),
                    horizontalSpaceSmall,
                    TextLink(
                      Strings.forgotPassword,
                      onPressed: () {
                        model.navigateToForgotPassword();
                      },
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
