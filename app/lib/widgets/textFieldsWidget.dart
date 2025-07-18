import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app/core/app_export.dart';

class TextFieldWidget extends StatefulWidget {
  final Key? key;
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final FormFieldValidator validator;
  final bool readOnly;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Widget? prefixIcon;
  final Function()? onTap;

  TextFieldWidget(
      {this.key,
      this.prefixIcon,
      this.fillColor,
      this.hintStyle,
      required this.hintText,
      this.controller,
      this.isPassword = false,
      this.readOnly = false,
      this.suffixIcon,
      this.onTap,
      required this.validator})
      : super(key: key);

  @override
  TextFieldWidgetState createState() => TextFieldWidgetState();
}

class TextFieldWidgetState extends State<TextFieldWidget> {
  bool isObscureText = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isObscureText = widget.isPassword;
    });
  }

  void onTapSuffixIcon() {
    setState(() {
      if (widget.isPassword) {
        isObscureText = !isObscureText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      widget.prefixIcon != null
          ? Padding(
              padding: EdgeInsets.only(right: 10),
              child: widget.prefixIcon,
            )
          : Container(),
      Expanded(
          child: FormField<String>(
        validator: widget.validator,
        builder: (field) {
          return Column(children: [
            TextField(
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              controller: widget.controller,
              obscureText: isObscureText,
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  prefixIconConstraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.06,
                      maxWidth: MediaQuery.of(context).size.height * 0.06),
                  contentPadding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  fillColor: Theme.of(context).colorScheme.surface,
                  filled: true,
                  suffixIcon: widget.suffixIcon != null
                      ? IconButton(
                          icon: widget.suffixIcon!, onPressed: onTapSuffixIcon)
                      : null,
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: field.hasError
                              ? ColorsConstant.redAction
                              : ColorsConstant.lightGreyStroke)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: field.hasError
                              ? ColorsConstant.redAction
                              : ColorsConstant.lightGreyStroke))),
            ),
            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  field.errorText!,
                  style:
                      AppTextStyle.rrResizable(10).copyWith(color: Colors.red),
                ),
              )
          ]);
        },
      ))
    ]);
  }
}
