import 'package:digital_guru_app/app/common/widget/custom_button.dart';
import 'package:flutter/material.dart';

class SignInButton extends CustomButton {
  SignInButton({
    Key? key,
    required String text,
    required Color color,
    required VoidCallback onPressed,
    Color textColor = Colors.black87,
    double height = 50.0,
  }) : super(
          key: key,
          label: text,
          color: color,
          textColor: textColor,
          onPressed: onPressed,
        );
}
