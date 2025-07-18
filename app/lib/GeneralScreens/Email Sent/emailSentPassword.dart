import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/textButton.dart';

import 'emailSentController.dart';
import 'package:app/core/app_export.dart';

class EmailSentScreen extends GetWidget<EmailSentController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Icon(
              Icons.check_circle_outline_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              AppLocalizations.of(context)!.validez_votre_email,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 32,
                  ),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() => Text(controller.message.value,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!)),
            Spacer(),
            ButtonWidget(
              
                onPressed: () async {
                  onTapBackToLogin();
                },
                child: Text(AppLocalizations.of(context)!.se_connecter,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary))),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }

  onTapBackToLogin() {
    Get.toNamed(GeneralAppRoutes.VTLogInScreenRoute);
  }
}
