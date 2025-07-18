import 'dart:io';

import 'package:app/Vertical-Tracking/Gyms/gymsController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/core/utils/svgparse.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Secteur/secteur_svg.dart';
import 'package:app/data/models/Wall/Api.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:app/widgets/colorFilter/colorFilterController.dart';
import 'package:app/widgets/snappingSheet/src/snapping_position.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_widget.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class BoulderController extends GetxController {
  RxBool is_done_loading_wall = false.obs;
  RxnBool isDone = RxnBool(null);
  RxDouble grabbingHeigh = 110.0.obs;
  SnappingSheetController snappingSheetController = SnappingSheetController();
  RxBool isSnappingSheetDown = true.obs;
  Rxn<SecteurSvg> selectedSecteur = Rxn<SecteurSvg>(null);
  RxBool hasError = false.obs;
  RxBool gymIdIsSet = true.obs;
  RxInt index = 0.obs;

  ClimbingLocationController climbingLocationController =
      Get.find<ClimbingLocationController>();

  @override
  void onInit() async {
    super.onInit();
    await getBoulders();
    await updateFilterByQrCode();
  }

  Future<void> updateFilterByQrCode() async {
    if (Get.parameters['secteurName'] != null) {
      String secteurName = Get.parameters['secteurName']!;
      SecteurSvg? secteur = climbingLocationController.secteurSvgList
          .firstWhereOrNull((element) => element.secteurName == secteurName);
      if (secteur != null) {
        await climbingLocationController.filterWall({'area': secteur});
      }
    }

    if (selectedSecteur.value != null) {
      //put the snapping sheet in the middle
      while (snappingSheetController.isAttached == false) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      isSnappingSheetDown.value = false;
      snappingSheetController
          .snapToPosition(snappingSheetController.snappingPositions[1]);
    }
  }

  Future<void> getBoulders() async {
    try {
      is_done_loading_wall.value = false;
      is_done_loading_wall.refresh();

      while (climbingLocationController.climbingLocationResp == null) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      snappingSheetController.snappingPositions = [
        SnappingPosition.factor(
          positionFactor: 0.3,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 500),
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
        SnappingPosition.factor(
          positionFactor: 0.8,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 500),
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
      ];
      Get.find<PrefUtils>().setGradeSystem(
          climbingLocationController.climbingLocationResp!.gradeSystem!);

      gymIdIsSet.value = true;
      gymIdIsSet.refresh();
      await climbingLocationController.filterWall({});
      is_done_loading_wall.value = true;
      is_done_loading_wall.refresh();
    } on ClimbingLocationResp {
    } on NoInternetException catch (e) {
      hasError.value = true;
      hasError.refresh();
      Get.rawSnackbar(
          message: e.toString(),
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 5));
    } on Exception catch (e) {
      hasError.value = true;
      hasError.refresh();

      Get.rawSnackbar(
          message: e.toString(),
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 5));
    }
  }

  RxList<SecteurSvg> selectSectorByColor() {
    RxList<SecteurSvg> _selectedSecteur = <SecteurSvg>[].obs;
    for (var sector in climbingLocationController.secteurSvgList) {
      _selectedSecteur.add(sector);
    }

    if (climbingLocationController.filtre.containsKey('color') &&
        climbingLocationController.filtre['color'] != null) {
      List<String> wallToGrey = [];
      for (var wall in climbingLocationController.allWalls["actual"]!) {
        if (wall.grade?.ref1 == climbingLocationController.filtre['color'] &&
            !wallToGrey.contains(wall.secteurResp?.id)) {
          wallToGrey.add(wall.secteurResp!.newlabel);
        }
      }

      for (var sector in climbingLocationController.secteurSvgList) {
        if (!wallToGrey.contains(sector.secteurName)) {
          _selectedSecteur.remove(sector);
        }
      }
      return _selectedSecteur;
    } else {
      return _selectedSecteur;
    }
  }

  void onTapCreate() {
    Get.toNamed(AppRoutesVT.createWallAmbasseur, arguments: {
      'climbingLocation': climbingLocationController.climbingLocationResp
    });
  }

  Rxn<File> creationImage = Rxn<File>();
  Rxn<String> creationState = Rxn<String>();
  RxInt mousquettesWon = 0.obs;

  void onTapEdit() {
    Get.toNamed(AppRoutesVT.editWallAmbassador, arguments: {
      'climbingLocation': climbingLocationController.climbingLocationResp,
      "walls": climbingLocationController.allWalls["actual"]!,
    });
  }
}
