import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sign_in_flutter/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key key,
    @required this.hintText,
    @required this.onChanged,
    @required this.onSubmit,
    @required this.controller,
    this.maxLength,
    this.paswordValid,
    this.focusNode,
    this.textFormatter,
    this.keyboardInputType,
    this.validator,
    this.docfield = false,
    this.isReadOnly = false,
    this.giveUpdateToDoctor = false,
    this.textCapitalization = TextCapitalization.sentences,
  }) : super(key: key);

  final String hintText;
  final int maxLength;
  final String paswordValid;
  final bool giveUpdateToDoctor;
  final List<TextInputFormatter> textFormatter;
  final Function onChanged;
  final Function onSubmit;
  final Function validator;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardInputType;
  final bool isReadOnly;
  final bool docfield;
  final TextCapitalization textCapitalization;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      // height: 70,
      child: TextFormField(
        maxLength: maxLength,
        autovalidateMode: giveUpdateToDoctor
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.onUserInteraction,
        autocorrect: false,
        readOnly: isReadOnly,
        textCapitalization: textCapitalization,
        validator: (value) {
          return validator(value);
        },
        keyboardType: keyboardInputType,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        controller: controller,
        obscureText: hintText == 'Password' || hintText == 'Confirm Password' || hintText == 'Current Password' || hintText == 'New Password'
        ? true : false,
        autofocus: false,
        inputFormatters: textFormatter,
        style: TextStyle(
          color: ColorPickers.blackColor,
          height: 1.5,
        ),
        onChanged: (value) {
          onChanged(controller.text);
        },
        onFieldSubmitted: (value) {
          onSubmit(controller.text);
        },
        textAlign: TextAlign.start,
        maxLines: 1,
        decoration: InputDecoration(
          errorText: paswordValid,
          filled: true,
          fillColor: ColorPickers.whiteColor,
          hintText: hintText,
          hintStyle: TextStyle(color: ColorPickers.textHintColor),
          contentPadding:
              const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 10.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorPickers.blackColor),
            borderRadius: BorderRadius.circular(10.7),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.7),
          ),
          errorBorder: this.docfield
              ? OutlineInputBorder(
                  borderSide:
                      BorderSide(color: ColorPickers.blackColor),
                  borderRadius: BorderRadius.circular(10.7),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10.7),
                ),
          focusedErrorBorder: this.docfield
              ? OutlineInputBorder(
                  borderSide:
                      BorderSide(color: ColorPickers.blackColor),
                  borderRadius: BorderRadius.circular(10.7),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10.7),
                ),
        ),
      ),
    );
  }
}
