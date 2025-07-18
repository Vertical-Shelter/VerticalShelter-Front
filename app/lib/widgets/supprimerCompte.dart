import 'package:app/core/app_export.dart';
import 'package:app/data/apiClient/requestMemoryManager.dart';
import 'package:app/data/models/FCMManager/apiFCM.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/ConfirmDialog.dart';

class DeleteAccountDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ConfirmDialog(
        title: AppLocalizations.of(context)!.confirmer_supprimer_compte,
        mainText: AppLocalizations.of(context)!.etes_vous_sur_de_vouloir_supprimer_compte,
        onCancel: onCancelTap,
        onConfirm: onConfirmTap);
  }

  void onConfirmTap(BuildContext context) async {
    deleteFCMToServer();
    user_delete();
    Get.find<MultiAccountManagement>().removeAccount();
    RequestMemoryManager.instance.clearData();
    Get.offAllNamed(GeneralAppRoutes.WelcomeScreenRoute);
  }

  onCancelTap(BuildContext context) {
    Navigator.of(context).pop();
  }
}
