import 'dart:io';

import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/textFieldsWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'log_in_controller.dart';
import 'package:app/core/app_export.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore_for_file: must_be_immutable
class LogInScreen extends GetWidget<LogInController> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: false,
              title: BackButtonWidget(onPressed: () {
                onTapBtnArrowleft();
              }),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Obx(() => controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                          .hereux_de_vous_revoir +
                                      ' ' +
                                      AppLocalizations.of(context)!
                                          .connecte_toi,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 32,
                                      ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Form(
                                  key: _formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFieldWidget(
                                          controller:
                                              controller.emailController,
                                          isPassword: false,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .entre_ton_email,
                                          validator: (value) =>
                                              controller.loginError),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFieldWidget(
                                        controller:
                                            controller.passwordController,
                                        hintText: AppLocalizations.of(context)!
                                            .entre_ton_mot_de_passe,
                                        validator: (value) =>
                                            controller.passwordError,
                                        isPassword: true,
                                        suffixIcon: Icon(
                                          Icons.visibility,
                                          color: ColorsConstant.greyText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: onTapTxtForgotpassword,
                                    child: Padding(
                                      padding: getPadding(bottom: 30),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .mot_de_passe_oublie,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ButtonWidget(
                                    onPressed: () async {
                                      controller.loginError = null;
                                      controller.passwordError = null;
                                      if (_formKey.currentState!.validate()) {
                                        await controller.Login();
                                      }
                                      _formKey.currentState!.validate();
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .se_connecter,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: ColorsConstantDarkTheme
                                                    .neutral_black))),
                                Spacer(),
                                ButtonWidget(
                                  onPressed: controller.handleGoogleSignin,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(FontAwesomeIcons.google,
                                            color: ColorsConstantDarkTheme
                                                .neutral_black,
                                            size: 25),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            AppLocalizations.of(context)!
                                                .googleConnection,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color:
                                                        ColorsConstantDarkTheme
                                                            .neutral_black))
                                      ]),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (Platform.isIOS)
                                  ButtonWidget(
                                    onPressed: controller.handleAppleSignin,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(FontAwesomeIcons.apple,
                                              color: ColorsConstantDarkTheme
                                                  .neutral_black,
                                              size: 25),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .apple_connection,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color:
                                                          ColorsConstantDarkTheme
                                                              .neutral_black))
                                        ]),
                                  ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .vous_navez_pas_de_compte,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!,
                                    ),
                                    TextButton(
                                      onPressed: onTapGoRegister,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .s_inscrire,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                      ),
                                    ),
                                  ],
                                ),
                              ]));
                    },
                  )))));
  }

  onTapBtnArrowleft() {
    Get.back();
  }

  onTapTxtForgotpassword() {
    Get.toNamed(GeneralAppRoutes.ForgotPasswordScreenRoute);
  }

  onTapGoRegister() {
    Map<String, String> params = {};
    if (Get.parameters['climbingLocationId'] != null) {
      params['climbingLocationId'] = Get.parameters['climbingLocationId']!;
    }
    if (Get.parameters['secteurName'] != null) {
      params['secteurName'] = Get.parameters['secteurName']!;
    }
    Get.toNamed(GeneralAppRoutes.RegisterScreenRoute, parameters: params);
  }
}
