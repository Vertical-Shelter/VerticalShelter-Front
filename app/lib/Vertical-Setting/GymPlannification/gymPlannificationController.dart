import 'package:app/Vertical-Setting/BottomBar/bottomBarController.dart';
import 'package:app/Vertical-Setting/home/homeController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/utils/climbingLocationController.dart';

class GymPlannificationController extends GetxController {
  RxMap<DateTime?, Map<String, List<WallResp>>> dateSecteurList =
      <DateTime?, Map<String, List<WallResp>>>{}.obs;

  RxList<DateTime?> dates = <DateTime?>[].obs;
  ClimbingLocationController climbingLocationController =
      Get.find<ClimbingLocationController>();

  @override
  void onReady() {
    super.onReady();
    sortSecteurlist("actual");
  }

  void sortSecteurlist(String isActual) {
    dateSecteurList.clear();
    for (var element in climbingLocationController.allWalls[isActual]!) {
      DateTime? date = element.date;
      if (date != null) {
        date = DateTime(date!.year, date.month, date.day);
      }
      if (dateSecteurList[date] == null) {
        dateSecteurList[date] = {};
      }
      if (dateSecteurList[date]![element.secteurResp!.newlabel] == null) {
        dateSecteurList[date]![element.secteurResp!.newlabel] = [];
      }
      dateSecteurList[date]![element.secteurResp!.newlabel]!.add(element);
    }
    //sort the map by date : put the last date first
    dates = dateSecteurList.keys.toList().obs;
    dates.sort((a, b) {
      if (a == null || b == null) {
        return 1;
      }
      return a.compareTo(b);
    });
  }
}
