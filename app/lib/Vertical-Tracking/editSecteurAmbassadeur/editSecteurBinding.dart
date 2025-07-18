import 'package:app/Vertical-Tracking/editSecteurAmbassadeur/editSecteurController.dart';
import 'package:app/core/app_export.dart';

class EditSecteurAmabassadeurBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditSecteurAmabassadeurController>(() => EditSecteurAmabassadeurController());
  }
}
