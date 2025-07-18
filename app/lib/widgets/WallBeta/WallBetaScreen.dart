import 'dart:math';

import 'package:flutter/material.dart';
import 'package:app/widgets/WallBeta/WallBetaController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/BetaWidget.dart';

class WallBetaScreen extends GetWidget<WallBetaController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
        itemCount: controller.users
            .where(
                (element) => element.beta != null || element.beta_url != null)
            .length,
        shrinkWrap: true,
        // itemCount: controller.users.length,
        itemBuilder: ((context, index) => Padding(
            padding: EdgeInsets.only(
              top: 10,
            ),
            child: BetaWidget(
              sentWallResp: controller.users
                  .where((element) =>
                      element.beta != null || element.beta_url != null)
                  .toList()[index],
            )))));
  }
}
