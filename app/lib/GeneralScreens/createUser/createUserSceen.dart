import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/climbingLocationMinimalist.dart';
import 'package:app/widgets/textFieldsWidget.dart';
import 'createUserController.dart';
import 'package:app/core/app_export.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore_for_file: must_be_immutable
class RegisterScreen extends GetWidget<RegisterController> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isButtonCalled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: BackButtonWidget(onPressed: () {
            Get.back();
          }),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
              padding: EdgeInsets.all(20),
              child: ListView(children: [
                Text(
                  AppLocalizations.of(context)!.salut_grimpeur +
                      ' ' +
                      AppLocalizations.of(context)!
                          .entre_tes_informations_pour_commencer,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 32,
                      ),
                ),

                SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          TextFieldWidget(
                              controller: controller.emailController,
                              hintText: AppLocalizations.of(context)!.email,
                              validator: (value) => controller.emailError),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                              controller: controller.usernameController,
                              hintText: AppLocalizations.of(context)!
                                  .nom_d_utilisateur,
                              validator: (value) => controller.firstNameError),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                            controller: controller.passwordController,
                            hintText:
                                AppLocalizations.of(context)!.mot_de_passe,
                            isPassword: true,
                            validator: (value) => controller.passwordError,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                              controller: controller.confirmpasswordController,
                              hintText: AppLocalizations.of(context)!
                                  .confirme_ton_mot_de_passe,
                              isPassword: true,
                              validator: (value) =>
                                  controller.confirmPasswordError),
                        ]))),
                SizedBox(
                  height: 20,
                ),
                ButtonWidget(
                    onPressed: () async {
                      controller.emailError = null;
                      controller.passwordError = null;
                      controller.firstNameError = null;
                      controller.lastNameError = null;
                      controller.gymError = null;
                      controller.confirmPasswordError = null;
                      if (_formKey.currentState!.validate())
                        await controller.register();
                      _formKey.currentState!.validate();
                    },
                    child: Text(AppLocalizations.of(context)!.s_inscrire,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.surface))),

                SizedBox(
                  height: 20,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    AppLocalizations.of(context)!.tu_as_deja_un_compte,
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                  TextButton(
                    onPressed: () => onTapGoLogin(),
                    child: Text(AppLocalizations.of(context)!.connecte_toi,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                ]), // TO DO REGISTER WITH GOOGLE
              ]));
        })));
  }

  onTapBtnArrowleft() {
    Get.back();
  }

  onTapGoLogin() {
    Get.toNamed(GeneralAppRoutes.VTLogInScreenRoute);
  }
}
