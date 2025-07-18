import 'package:app/Vertical-Setting/editSecteur/editSecteurController.dart';
import 'package:app/core/app_export.dart';

class VSEditSecteurBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VSEditSecteurController>(() => VSEditSecteurController());
  }
}
