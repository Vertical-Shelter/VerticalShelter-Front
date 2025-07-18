import 'package:get/get.dart';
import 'package:app/Vertical-Tracking/edit_profil_screen/edit_profil_controller.dart';

class VTEditProfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VTEditProfilController>(() => VTEditProfilController());
  }
}
