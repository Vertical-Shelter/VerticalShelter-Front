import 'package:app/Vertical-Tracking/profil/profil_controller.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/apiClient/requestMemoryManager.dart';
import 'package:app/data/models/FCMManager/apiFCM.dart';
import 'package:app/data/models/logout/api.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/ConfirmDialog.dart';

class DisconnectDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConfirmDialog(
        title: AppLocalizations.of(context)!.confirmer_la_deconnexion,
        mainText: AppLocalizations.of(context)!.etes_vous_sur_de_vouloir_se_deconnecter,
        onCancel: onCancelTap,
        onConfirm: onConfirmTap);
  }

  void onConfirmTap(BuildContext context) async {
    deleteFCMToServer();
    logout();
    Get.find<MultiAccountManagement>().removeAccount();
    RequestMemoryManager.instance.clearData();
    Get.offAllNamed(GeneralAppRoutes.WelcomeScreenRoute);
    if (Get.find<MultiAccountManagement>().accounts != []){
    OnChangeAccountTap(context);
    }
  }

  onCancelTap(BuildContext context) {
    Navigator.of(context).pop();
  }
}
