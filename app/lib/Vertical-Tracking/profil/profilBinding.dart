import 'package:app/Vertical-Tracking/profil/profil_controller.dart';
import 'package:app/core/app_export.dart';

class VTProfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VTProfilController>(() => VTProfilController());
  }
}
