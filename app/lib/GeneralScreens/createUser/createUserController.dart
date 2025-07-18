import 'package:app/core/app_export.dart';
import 'package:app/core/utils/progress_dialog_utils.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/createUser/create_user_req.dart';
import 'package:app/data/models/User/createUser/create_user_resp.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  TextEditingController confirmpasswordController = TextEditingController();

  PostCreateUserResp postCreateUserResp = PostCreateUserResp();

  RxBool isLoaded = false.obs;

  // Validator prompt
  String? emailError;
  String? passwordError;
  String? gymError;
  String? confirmPasswordError;

  String? firstNameError;

  String? lastNameError;

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.onClose();
  }

  Future<void> callCreateCreateUser(PostCreateUserReq req) async {
    try {
      postCreateUserResp = await create_user(req);
      if (postCreateUserResp.email != null) {
        throw postCreateUserResp;
      }
      if (postCreateUserResp.password != null) {
        throw postCreateUserResp;
      }
    } on PostCreateUserResp catch (e) {
      postCreateUserResp = e;
      rethrow;
    }
  }

  Future<void> register() async {
    ProgressDialogUtils.showProgressDialog();
    bool hasError = false;
    if (emailController.text.isEmpty || !emailController.text.isEmail) {
      hasError = true;
      emailError = AppLocalizations.of(Get.context!)!.email_error;
    }
    if (usernameController.text.isEmpty) {
      hasError = true;
      firstNameError = AppLocalizations.of(Get.context!)!.first_name_error;
    }
    if (passwordController.text.isEmpty) {
      hasError = true;
      passwordError = AppLocalizations.of(Get.context!)!.password_error;
    }
    if (confirmpasswordController.text.isEmpty) {
      hasError = true;
      confirmPasswordError = AppLocalizations.of(Get.context!)!.password_error;
    }
    if (passwordController.text != confirmpasswordController.text) {
      hasError = true;
      confirmPasswordError =
          AppLocalizations.of(Get.context!)!.password_dont_match_error;
    }

    if (hasError) {
      ProgressDialogUtils.hideProgressDialog();
      return;
    }
    try {
      PostCreateUserReq postCreateUserReq = PostCreateUserReq(
        email: emailController.text,
        password: passwordController.text,
        password2: confirmpasswordController.text,
        username: usernameController.text,
      );

      await callCreateCreateUser(
        postCreateUserReq,
      );
      ProgressDialogUtils.hideProgressDialog();
      _onRegisterSuccess();
    } on NoInternetException catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      Get.rawSnackbar(message: e.toString());
    } on PostCreateUserResp catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      _onRegisterError(e);
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      Get.rawSnackbar(message: e.toString());
    }
  }

  void _onRegisterSuccess() {
    Map<String, String> params = {};
    if (Get.parameters['climbingLocationId'] != null) {
      params['climbingLocationId'] = Get.parameters['climbingLocationId']!;
    }
    if (Get.parameters['secteurName'] != null) {
      params['secteurName'] = Get.parameters['secteurName']!;
    }
    Get.snackbar("Bravo", "Connectez-vous pour continuer",
        snackPosition: SnackPosition.TOP);
    Get.toNamed(GeneralAppRoutes.VTLogInScreenRoute, parameters: params);
  }

  void _onRegisterError(PostCreateUserResp e) {
    emailError = e.email;
    passwordError = e.password;
  }

  // void onPressedGym()
}
