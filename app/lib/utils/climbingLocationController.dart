import 'package:app/core/app_export.dart';
import 'package:app/core/utils/svgparse.dart';
import 'package:app/data/models/ClimbingLocation/APIrequest.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Secteur/secteur_svg.dart';
import 'package:app/data/models/Wall/Api.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/colorFilter/colorFilterController.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ClimbingLocationController extends GetxController {
  RxBool is_done_loading_CLoc = false.obs;
  ClimbingLocationResp? climbingLocationResp;
  List<SecteurSvg> secteurSvgList = <SecteurSvg>[];
  Rxn<ColorFilterController> colorFilterController =
      Rxn<ColorFilterController>();
  RxMap<String, dynamic> numberOfWall = RxMap<String, dynamic>();
  RxInt numberOfWallSelected = 0.obs;

  RxList<String> labelSecteurRecent = <String>[].obs;
  RxList<String> labelNextSecteur = <String>[].obs;

  Map<String, List<WallResp>> allWalls = {"actual": [], "old": []};

  RxList<WallResp> displayedWalls = <WallResp>[].obs;
  RxMap<String, double> dataStats = {"": 0.0}.obs;

  Rxn<SecteurSvg> selectedSecteur = Rxn<SecteurSvg>(null);

  RxString isActual = "".obs;

  Map<String, dynamic> filtre = {"isActual": true};

  Future<void> getGym(String? clibmingLocationId) async {
    clibmingLocationId ??=
        Get.find<MultiAccountManagement>().actifAccount!.climbingLocationId;

    climbingLocationResp = await climbingLocation_get(clibmingLocationId);

    labelNextSecteur.value = climbingLocationResp!.nextClosedSector ?? [];
    labelNextSecteur.refresh();

    labelSecteurRecent.value = climbingLocationResp!.newSector ?? [];
    labelSecteurRecent.refresh();

    secteurSvgList =
        await loadSvgImage(svgImage: climbingLocationResp!.new_topo_url);
    is_done_loading_CLoc.value = true;
    is_done_loading_CLoc.refresh();

    allWalls["actual"] = await wall_routesetter_actual(clibmingLocationId, {});

    colorFilterController.value = ColorFilterController(
        gradesTree: GradeTreeFromList(climbingLocationResp!.gradeSystem!),
        numberOfWall: numberOfWall,
        refresh: () => filterWall({}));
  }

  void clearNumberOfWall() {
    numberOfWall.clear();
    for (var color in climbingLocationResp!.gradeSystem!) {
      if (color.ref2 != null) {
        if (numberOfWall.containsKey(color.ref1) == false) {
          numberOfWall[color.ref1] = {};
        }
        numberOfWall[color.ref1][color.ref2] = 0;
      } else
        numberOfWall[color.ref1] = 0;
    }
  }

  // Future<void> refreshWall() async {
  //   // wall_routesetter_old(climbingLocation_id.value, {})
  //   //     .then((value) => allWalls["old"] = value);
  //   await filterWall({});
  // }

  Future<void> filterWall(Map<String, dynamic> _filtre) async {
    displayedWalls.clear();
    dataStats.clear();
    displayedWalls.clear();
    filtre['color'] = colorFilterController.value!.selectedGradeRef;
    filtre['ref2'] = colorFilterController.value!.ref2;

    if (_filtre.containsKey('area')) {
      filtre['area'] = _filtre['area'];
      if (_filtre['area'] != null) {
        selectedSecteur.value = _filtre['area'];
        selectedSecteur.refresh();
      } else {
        selectedSecteur.value = null;
        selectedSecteur.refresh();
      }
    }

    if (_filtre.containsKey('isDone')) {
      filtre['isDone'] = _filtre['isDone'];
    }
    if (_filtre.containsKey('ouvreur')) {
      filtre['ouvreur'] = _filtre['ouvreur'];
    }
    if (_filtre.containsKey('isActual') && _filtre['isActual'] != null) {
      filtre['isActual'] = _filtre['isActual'];
    }
    isActual.value = filtre['isActual'] == true ? "actual" : "old";
    isActual.refresh();
    for (WallResp wall in allWalls[isActual.value]!) {
      bool add = true;

      // filtre par couleur
      if (filtre.containsKey('color') && filtre['color'] != null) {
        if (filtre['color'] != wall.grade?.ref1) {
          add = false;
        } else if (filtre['ref2'] != null &&
            filtre['ref2'] != wall.grade?.ref2) {
          add = false;
        }
      }

      if (filtre.containsKey('isDone') &&
          filtre['isDone'] != null &&
          filtre['isDone'] != wall.isDone) {
        add = false;
      }

      if (filtre.containsKey('ouvreur') &&
          filtre['ouvreur'] != null &&
          !(filtre['ouvreur'] == wall.routeSetterName)) {
        add = false;
      }

      //filtre par area
      if (filtre.containsKey('area') &&
          filtre['area'] != null &&
          !(filtre['area'].secteurName == wall.secteurResp?.newlabel)) {
        add = false;
      }

      if (add == true) {
        displayedWalls.add(wall);
        for (var attributes in wall.attributes!) {
          if (dataStats.containsKey(attributes)) {
            dataStats[attributes] = dataStats[attributes]! + 1;
          } else {
            dataStats[attributes] = 1;
          }
        }
      }
    }
    displayedWalls.sort(
        (a, b) => a.secteurResp!.newlabel.compareTo(b.secteurResp!.newlabel));
    displayedWalls.refresh();

    numberOfWallSelected.value = displayedWalls.length;
    numberOfWallSelected.refresh();
    dataStats.refresh();
    colorFilterController.value!.gradeTreeFiltered();
    colorFilterController.refresh();
  }
}
