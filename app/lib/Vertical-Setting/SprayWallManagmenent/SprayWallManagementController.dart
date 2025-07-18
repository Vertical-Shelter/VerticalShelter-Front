import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/SprayWall/sprayWallResp.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:app/utils/sprayWallController.dart';
import 'package:app/widgets/sprayWallCardPopup.dart';

class SprayWallManagementController extends GetxController {
  RxList<SprayWallResp> sprayWallListResp = <SprayWallResp>[].obs;

  SprayWallController sprayWallController = Get.find<SprayWallController>();

  @override
  void onInit() {
    super.onInit();
    sprayWallListResp.value = sprayWallController.sprayWallListResp;
  }

  Future<void> showPopupCreateSprayWall(int index) async {
    ClimbingLocationResp climbingLocationResp =
        Get.find<ClimbingLocationController>().climbingLocationResp!;
    SprayWallResp? sprayWallResp =
        index < sprayWallListResp.length ? sprayWallListResp[index] : null;
    Get.dialog(
      Dialog(
        child: SprayWallCardPopup(
          onValidate: (sprayWallResp) {
            SprayWallResp? _spr = sprayWallListResp.firstWhereOrNull((e) {
              return e.id == sprayWallResp.id;
            });

            if (_spr != null) {
              _spr.name = sprayWallResp.name;
              _spr.image = sprayWallResp.image;
              _spr.annotations = sprayWallResp.annotations;
            } else {
              sprayWallListResp.add(sprayWallResp);
            }
            sprayWallController.actualSprayWallResp.value ??= sprayWallResp;
            sprayWallListResp.refresh();
          },
          climbingLocationResp: climbingLocationResp,
          sprayWallResp: sprayWallResp,
        ),
      ),
    );
  }
}
