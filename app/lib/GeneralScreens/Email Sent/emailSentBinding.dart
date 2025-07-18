import 'emailSentController.dart';
import 'package:get/get.dart';

class EmailSentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmailSentController());
  }
}
