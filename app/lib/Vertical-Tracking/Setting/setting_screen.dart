import 'package:app/widgets/BackButton.dart';
import 'package:flutter/material.dart';
import 'package:app/Vertical-Tracking/Setting/setting_controller.dart';
import 'package:app/core/app_export.dart';

class VTSettingScreen extends GetWidget<VTSettingController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            color: ColorsConstant.white,
            child: Column(children: [
              Padding(
                  padding: getPadding(left: 20, top: 20),
                  child: Row(children: [
                    BackButtonWidget(
                      onPressed: controller.onBackButtonPressed,
                    ),
                    Spacer()
                  ])),
              Padding(
                  padding: getPadding(bottom: 25),
                  child: Text(
                    AppLocalizations.of(context)!.politique_de_confidentialite,
                    style: AppTextStyle.rb30,
                    textAlign: TextAlign.center,
                  )),
              Expanded(
                  child: Column(
                children: [],
              ))
            ])));
  }
}
