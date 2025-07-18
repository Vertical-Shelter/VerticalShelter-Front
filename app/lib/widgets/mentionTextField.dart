import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/userApi.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/widgets/profil/profilMinivertical.dart';
import 'package:flutter/gestures.dart';

class TextMentionField extends StatefulWidget {
  final Key? key;
  final String hintText;
  final TextEditingController? controller;
  final FormFieldValidator validator;
  final bool readOnly;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Widget? prefixIcon;
  final Function()? onTap;

  TextMentionField(
      {this.key,
      this.prefixIcon,
      this.fillColor,
      this.hintStyle,
      required this.hintText,
      this.controller,
      this.readOnly = false,
      this.suffixIcon,
      this.onTap,
      required this.validator})
      : super(key: key);

  @override
  _TextMentionFieldState createState() => _TextMentionFieldState();
}

class _TextMentionFieldState extends State<TextMentionField> {
  List<String> words = [];
  String str = '';
  List<UserMinimalResp> users = <UserMinimalResp>[].obs;

  void searchRequest(String p0) async {
    users.clear();
    users = await list_name(p0);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
        validator: widget.validator,
        builder: (field) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                str.length > 1
                    ? ListView(
                        shrinkWrap: true,
                        children: users.map((s) {
                          if (('@' + s.username!).contains(str)) {
                            return ProfileMiniVertical(
                                id: s.id,
                                name: s.username,
                                image: s.image,
                                onTap: () {
                                  String tmp = str.substring(1, str.length);
                                  setState(() {
                                    str = '';
                                    widget.controller!.text += s.username!
                                        .substring(
                                            s.username!.indexOf(tmp) +
                                                tmp.length,
                                            s.username!.length)
                                        .replaceAll(' ', '_');
                                  });
                                });
                          } else
                            return SizedBox();
                        }).toList())
                    : SizedBox(),
                SizedBox(height: 25),
                Row(children: [
                  if (widget.prefixIcon != null) widget.prefixIcon!,
                  SizedBox(width: 10),
                  Expanded(
                      child: TextField(
                    onTap: widget.onTap,
                    readOnly: widget.readOnly,
                    controller: widget.controller,
                    onChanged: (val) {
                      setState(() {
                        words = val.split(' ');
                        str = words.length > 0 &&
                                words[words.length - 1].startsWith('@')
                            ? words[words.length - 1]
                            : '';
                        if (str.length > 1) searchRequest(str.substring(1));
                        print(str);
                      });
                    },
                    decoration: InputDecoration(
                        hintText: widget.hintText,
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true,
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        suffixIcon: widget.suffixIcon,
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
                  )),
                  if (field.hasError)
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        field.errorText!,
                        style: AppTextStyle.rrResizable(10)
                            .copyWith(color: Colors.red),
                      ),
                    ),
                ])
              ]);
        });
  }
}
