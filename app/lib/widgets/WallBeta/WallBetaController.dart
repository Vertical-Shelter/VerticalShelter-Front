import 'package:app/core/app_export.dart';
import 'package:app/data/models/SentWall/sentWallResp.dart';

class WallBetaController extends GetxController {
  RxList<SentWallResp> users = <SentWallResp>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void refreshBetas(List<SentWallResp>? sentWalls) {
    users.refresh();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // void updateValue(SentWallResp sentWallResp) async {
  //   if (users.indexWhere((element) => element.id == sentWallResp.id) == -1) {
  //     users.add(sentWallResp);
  //   } else {
  //     users[users.indexWhere((element) => element.id == sentWallResp.id)] =
  //         sentWallResp;
  //   }
  //   users.refresh();
  // }

  void updateValues(List<SentWallResp> _users) async {
    users.value = _users;
  }
}
