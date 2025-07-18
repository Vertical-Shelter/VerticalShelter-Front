import 'package:app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  ///common method for showing progress dialog
  static void showProgressDialog({isCancellable = false, text = ""}) async {
    if (!isProgressVisible) {
      Get.dialog(
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorsConstantDarkTheme.neutral_white,
                ),
              ),
              SizedBox(
                height: height * 0.027,
              ),
              Text(
                text,
                style: AppTextStyle.rr14
                    .copyWith(color: ColorsConstantDarkTheme.neutral_white),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        barrierDismissible: isCancellable,
        transitionCurve: Curves.easeInOut,
      );

      isProgressVisible = true;
    }
  }

  ///common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible) {
      Get.back();
    }
    isProgressVisible = false;
  }
}
