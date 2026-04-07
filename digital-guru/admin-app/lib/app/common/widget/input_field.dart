import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:digiguru/app/common/constants/shared_styles.dart';
import 'package:digiguru/app/common/util/ui_helpers.dart';

import 'note_text.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool password;
  final bool isReadOnly;
  final String placeholder;
  final String? validationMessage;
  final Function()? enterPressed;
  final bool smallVersion;
  final FocusNode? fieldFocusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction textInputAction;
  final String? additionalNote;
  final Function(String)? onChanged;
  final TextInputFormatter? formatter;
  final String? label;
  final int? maxLines;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final String? tooltip;

  InputField({
    required this.controller,
    required this.placeholder,
    this.enterPressed,
    this.fieldFocusNode,
    this.nextFocusNode,
    this.additionalNote,
    this.onChanged,
    this.formatter,
    this.validationMessage,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.password = false,
    this.isReadOnly = false,
    this.smallVersion = false,
    this.label,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.tooltip,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool isPassword;
  //double fieldHeight = 50;

  @override
  void initState() {
    super.initState();
    isPassword = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // widget.label != null ? Text(widget.label) : verticalSpaceTiny,
        // verticalSpaceTiny,
        Container(
          height:
              widget.smallVersion ? 40 : fieldHeight * (widget.maxLines ?? 1),
          alignment: Alignment.centerLeft,
          //decoration: boxDecoration(context),
          // padding: fieldPadding,
          //decoration: widget.isReadOnly ? disabledFieldDecortaion : fieldDecortaion,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                      labelText: widget.label,
                      // labelStyle: Theme.of(context).textTheme.bodyText1,
                      hintText: widget.placeholder,
                      // hintStyle: Theme.of(context).textTheme.bodyText2,
                      suffixIcon: isPassword
                          ? GestureDetector(
                              onTap: () => setState(() {
                                    isPassword = !isPassword;
                                  }),
                              child: Icon(isPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off))
                          : widget.tooltip != null
                              ? buildToolTip(context, widget.tooltip!)
                              : null),
                  maxLines: isPassword ? 1 : widget.maxLines,
                  keyboardType: widget.textInputType,
                  maxLength: widget.maxLength,
                  controller: widget.controller,
                  focusNode: widget.fieldFocusNode,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  inputFormatters: widget.formatter != null
                      ? <TextInputFormatter>[widget.formatter!]
                      : null,
                  onEditingComplete: () {
                    if (widget.enterPressed != null) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.enterPressed!();
                    }
                  },
                  onFieldSubmitted: (value) {
                    if (widget.nextFocusNode != null) {
                      widget.nextFocusNode!.requestFocus();
                    }
                  },
                  obscureText: isPassword,
                  readOnly: widget.isReadOnly,
                  validator: widget.validator,
                ),
              ), //getToolTip(context, widget.tooltip),
            ],
          ),
        ),
        if (widget.validationMessage != null)
          NoteText(
            widget.validationMessage!,
            color: Colors.red,
          ),
        if (widget.additionalNote != null) verticalSpace(5),
        if (widget.additionalNote != null) NoteText(widget.additionalNote!),
        verticalSpaceSmall
      ],
    );
  }
}
