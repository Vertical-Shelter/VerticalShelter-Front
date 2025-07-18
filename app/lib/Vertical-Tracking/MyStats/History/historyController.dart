import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/SentWall/sentWallResp.dart';
import 'package:app/data/models/Stats/statsApi.dart';
import 'package:app/data/models/Stats/statsResp.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/widgets/colorFilter/colorFilterController.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/date_symbol_data_local.dart';

class VTHistoryController extends GetxController {
  RxMap<String, List<SentWallResp>> history =
      <String, List<SentWallResp>>{}.obs;
  StatsResp stats = StatsResp();
  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;

  RxMap<String, int> offsetMap = <String, int>{"global": 0}.obs;
  RxList<ClimbingLocationMinimalResp> gymLists =
      <ClimbingLocationMinimalResp>[].obs;
  final RefreshController refreshController = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.idle);
  RxString currentGymId = "".obs;
  ClimbingLocationMinimalResp? climbingLocationRespChoosen;
  RxBool isVisble = false.obs;
  Rxn<ColorFilterController> colorFilterController =
      Rxn<ColorFilterController>();

  @override
  void onInit() async {
    initializeDateFormatting();
    gymLists.value = await getMyCloc();
    gymLists.forEach((element) {
      offsetMap[element.id] = 0;
    });
    await getHistory(null);
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void clickBack() {
    Get.back();
  }

  Future<void> getHistory(String? ClimbingLocationId) async {
    List<SentWallResp> _stats = [];
    if (ClimbingLocationId == null) {
      _stats = await statsGetHistory(offsetMap["global"]!,
          climbingLocationID: ClimbingLocationId);
      _stats.forEach((element) {
        if (history[element.wall!.climbingLocation!.id] == null) {
          history[element.wall!.climbingLocation!.id] = [element];
          offsetMap[element.wall!.climbingLocation!.id] = 1;
        } else if (history[element.wall!.climbingLocation!.id]!
            .contains(element)) {
          print('already in');
        } else {
          history[element.wall!.climbingLocation!.id]!.add(element);
          offsetMap[element.wall!.climbingLocation!.id] =
              offsetMap[element.wall!.climbingLocation!.id]! + 1;
        }
      });
      stats = ListSentWallToStatResp(
          history.values.expand((element) => element).toList());
    } else {
      _stats = await statsGetHistory(offsetMap[ClimbingLocationId]!,
          climbingLocationID: ClimbingLocationId);

      if (history[ClimbingLocationId] == null) {
        history[ClimbingLocationId] = _stats;
      } else {
        history[ClimbingLocationId]!.addAll(_stats);
      }
      stats = ListSentWallToStatResp(history[ClimbingLocationId]!);
    }
    isLoading.value = false;
    isLoading.refresh();
  }

  StatsResp ListSentWallToStatResp(List<SentWallResp> list) {
    Map<String, dynamic> obj = {};
    for (var i = 0; i < list.length; i++) {
      String formattedDate =
          DateFormat.yMMMMd(AppLocalizations.of(Get.context!)!.pays_code)
              .format(list[i].date!.toLocal());
      if (obj[formattedDate] == null) {
        obj[formattedDate] = [];
      }
      obj[formattedDate].add(list[i]);
    }
    return StatsResp(obj: obj);
  }

  void addActivity(WallResp wall, DateTime date) {
    isLoading.value = true;
    String formattedDate =
        DateFormat.yMMMMd(AppLocalizations.of(Get.context!)!.pays_code)
            .format(date);
    if (stats.obj![formattedDate] == null) {
      stats.obj![formattedDate] = [];
    }
    stats.obj![formattedDate].add(wall);
    isLoading.value = false;
  }

  void removeActivity(wallID) {
    isLoading.value = true;
    stats.obj!.forEach((key, value) {
      value.removeWhere((element) => element.id == wallID);
      print(value);
    });
    isLoading.value = false;
  }

  void changeCurrentGym(String tapedGym) async {
    isLoading.value = true;
    isLoading.refresh();
    currentGymId.value = tapedGym;
    currentGymId.refresh();
    climbingLocationRespChoosen =
        gymLists.firstWhere((element) => element.id == currentGymId.value);

    colorFilterController.value = ColorFilterController(
        gradesTree: GradeTreeFromList(climbingLocationRespChoosen!.gradeSystem),
        refresh: () => filterWall());
    await getHistory(tapedGym);

    isLoading.value = false;
    isLoading.refresh();
  }

  Future<void> filterWall() async {
    DateTime now = DateTime.now();
    isLoading.value = true;
    isLoading.refresh();
    print('now');
    Map<String, dynamic> filtre = {};
    List<SentWallResp> _displayedWalls = [];
    filtre['color'] = colorFilterController.value!.selectedGradeRef;
    filtre['ref2'] = colorFilterController.value!.ref2;
    for (SentWallResp sentWalls in history[currentGymId.value]!) {
      bool add = true;

      // filtre par couleur
      if (filtre.containsKey('color') && filtre['color'] != null) {
        if (filtre['color'] != sentWalls.wall!.grade?.ref1) {
          add = false;
        } else if (filtre['ref2'] != null &&
            filtre['ref2'] != sentWalls.wall!.grade?.ref2) {
          add = false;
        }
      }
      if (add == true) {
        _displayedWalls.add(sentWalls);
      }
      print('end of filter');
    }
    stats = ListSentWallToStatResp(_displayedWalls);
    isLoading.value = false;
    isLoading.refresh();
    print('${DateTime.now().difference(now).inMilliseconds} ms');
  }
}
