import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/textButton.dart';
import 'package:app/widgets/textFieldsWidget.dart';
import 'package:app/widgets/buttonWidget.dart';

import 'forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:app/core/app_export.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore_for_file: must_be_immutable
class ForgotPasswordScreen extends GetWidget<ForgotPasswordController> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: BackButtonWidget(onPressed: () {
            onTapBtnArrowleft();
          }),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SafeArea(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.mot_de_passe_oublie,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 32,
                            ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(AppLocalizations.of(context)!.ne_t_en_fais_pas,
                          style: Theme.of(context).textTheme.bodyMedium!),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: TextFieldWidget(
                            controller: controller.emailController,
                            hintText: AppLocalizations.of(context)!.email,
                            validator: (value) {
                              return controller.emailError;
                            }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonWidget(
                          onPressed: () async {
                            controller.emailError = null;
                            if (_formKey.currentState!.validate()) {
                              await controller.getCode();
                            }
                            _formKey.currentState!.validate();
                          },
                          child: Text(
                              AppLocalizations.of(context)!
                                  .envoyer_code_verification,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).colorScheme.primary))),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.il_t_es_revenu,
                            style: Theme.of(context).textTheme.bodySmall!,
                          ),
                          TextButton(
                            onPressed: onTapBackToLogin,
                            child: Text(
                              AppLocalizations.of(context)!.connecte_toi,
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
                    ],
                  )));
        }));
  }

  onTapBtnArrowleft() {
    Get.back();
  }

  onTapBackToLogin() {
    Get.toNamed(GeneralAppRoutes.VTLogInScreenRoute);
  }
}
