import 'package:app/core/app_export.dart';

class EmailSentController extends GetxController {
  RxString message = "".obs;
  @override
  void onReady() {
    message.value = Get.parameters['message']!;
    message.refresh();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
