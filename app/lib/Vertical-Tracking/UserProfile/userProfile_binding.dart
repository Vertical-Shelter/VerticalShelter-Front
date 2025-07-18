import 'package:app/Vertical-Tracking/UserProfile/userProfile_controller.dart';
import 'package:app/core/app_export.dart';

class VTUserProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VTUserProfilController>(() => VTUserProfilController());
  }
}
