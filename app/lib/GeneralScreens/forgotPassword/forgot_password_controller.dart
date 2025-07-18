import 'package:app/core/app_export.dart';
import 'package:app/core/utils/progress_dialog_utils.dart';
import 'package:app/data/models/ForgotPassword/api.dart';
import 'package:app/data/models/ForgotPassword/forgotPasswordReq.dart';
import 'package:app/data/models/ForgotPassword/forgotPasswordResp.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  // Validator prompt
  String? emailError;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
  }

  Future getCode() async {
    try {
      ProgressDialogUtils.showProgressDialog();
      ForgotPasswordResp resp =
          await resetPassword(ForgotPassWordReq(email: emailController.text));
      ProgressDialogUtils.hideProgressDialog();
      if (resp.error != null) {
        emailError = resp.error;
        return;
      }
      Get.toNamed(GeneralAppRoutes.EmailSentRoute, parameters: {
        'message': resp.message!,
      });
    } on ForgotPasswordResp catch (e) {
      emailError = e.error;

      ProgressDialogUtils.hideProgressDialog();
    }
  }
}
