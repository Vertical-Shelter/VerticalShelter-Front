import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:app/Vertical-Setting/home/homeController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/SprayWall/sprayWallApi.dart';
import 'package:app/data/models/SprayWall/sprayWallResp.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:app/widgets/colorFilter/colorFilterController.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_widget.dart';

class SprayWallController extends GetxController {
  RxBool is_done_loading_wall = false.obs;
  RxnBool isDone = RxnBool(null);
  List<String> cotationList = [
    "4a",
    "4b",
    "4c",
    "5a",
    "5b",
    "5c",
    "6a",
    "6a+",
    "6b",
    "6b+",
    "6c",
    "6c+",
    "7a",
    "7a+",
    "7b",
    "7b+",
    "7c",
    "7c+",
    "8a",
    "8a+",
    "8b",
    "8b+",
    "8c",
    "8c+",
    "9a",
  ];
  RxList<String> selectedCotation = <String>[].obs;
  RxDouble grabbingHeigh = 150.0.obs;
  RxList<WallResp> displayedWalls = <WallResp>[].obs;
  List<WallResp> allWalls = <WallResp>[];
  List<String> _selectedColors = <String>[];
  List<String> path = <String>[];
  SnappingSheetController snappingSheetController = SnappingSheetController();
  RxBool isSnappingSheetDown = true.obs;
  Map<String, dynamic> _filtre = {"isActual": true};
  RxList<NavigationDestination> allDestinations = <NavigationDestination>[].obs;
  Rxn<ColorFilterController> colorFilterController = Rxn();

  //List<SecteurSvg> secteurSvgList = <SecteurSvg>[];
  RxBool hasError = false.obs;

  Rxn<SprayWallResp> actualSprayWallResp = Rxn<SprayWallResp>();

  List<SprayWallResp> sprayWallListResp = [];
  int indexSprayWall = 0;

  RxBool gymIdIsSet = true.obs;

  RxInt index = 0.obs;

  Rxn<ui.Image> image = Rxn<ui.Image>(null);

  RxBool isSprayWallDoneBack = false.obs;

  ClimbingLocationController gymController =
      Get.find<ClimbingLocationController>();

  @override
  void onInit() {
    super.onInit();
    getGym();
  }

  Future<void> refreshWall() async {
    is_done_loading_wall.value = false;
    is_done_loading_wall.refresh();
    allWalls = await SprayWallListBloc(gymController.climbingLocationResp!.id,
        actualSprayWallResp.value!.id!, {'color': _selectedColors});
    filterWall({});
    is_done_loading_wall.value = true;
    is_done_loading_wall.refresh();
  }

  Future<void> filterWall(Map<String, dynamic> filtre) async {
    is_done_loading_wall.value = false;
    is_done_loading_wall.refresh();
    displayedWalls.clear();

    _filtre['color'] = colorFilterController.value!.selectedGradeRef;
    _filtre['ref2'] = colorFilterController.value!.ref2;
    _filtre['isDone'] = isDone.value;
    if (selectedCotation.isNotEmpty) {
      _filtre['font'] = selectedCotation.value;
    } else {
      _filtre['font'] = null;
    }

    for (WallResp wall in allWalls) {
      bool add = true;
      // filtre par couleur
      if (_filtre.containsKey('color') && _filtre['color'] != null) {
        String gradeId = colorFilterController.value!.selectedGrade.value!.id;
        if (gradeId != wall.gradeId) {
          add = false;
        }
      }

      if (_filtre.containsKey('font') &&
          _filtre['font'] != null &&
          !_filtre['font'].contains(wall.equivalentExte)) {
        add = false;
      }

      if (_filtre.containsKey('isDone') &&
          _filtre['isDone'] != null &&
          _filtre['isDone'] != wall.isDone) {
        add = false;
      }

      //filtre par area

      if (add == true) {
        displayedWalls.add(wall);
      }
      print('end of filter');
    }
    is_done_loading_wall.value = true;
    is_done_loading_wall.refresh();

    displayedWalls.refresh();
    colorFilterController.refresh();
  }

  void onTapAddWall() {
    Get.toNamed(AppRoutesVT.createBlocSprayWall,
        parameters: {'sprayWallId': actualSprayWallResp.value!.id!});
  }

  Future<void> getGym() async {
    try {
      while (gymController.climbingLocationResp == null) {
        await Future.delayed(Duration(seconds: 1));
      }

      sprayWallListResp =
          await ListSprayWalls(gymController.climbingLocationResp!.id);

      colorFilterController.value = ColorFilterController(
          gradesTree: GradeTreeFromList(
              gymController.climbingLocationResp!.gradeSystem!),
          refresh: () {
            filterWall({});
          });

      if (sprayWallListResp.isNotEmpty) {
        actualSprayWallResp.value = sprayWallListResp[indexSprayWall];
        image.value = await loadNetworkImage(actualSprayWallResp.value!.image!);

        isSprayWallDoneBack.value =
            actualSprayWallResp.value!.annotations.isNotEmpty;

        await refreshWall();
      } else {
        image.value = null;
        image.refresh();
        actualSprayWallResp.value = null;
        allWalls.clear();
        isSprayWallDoneBack.value = false;
        displayedWalls.clear();
        isSprayWallDoneBack.refresh();
        is_done_loading_wall.value = true;
        is_done_loading_wall.refresh();
      }

      gymIdIsSet.value = true;
      gymIdIsSet.refresh();
      colorFilterController.refresh!();
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

  Future<ui.Image> loadNetworkImage(String url) async {
    final completer = Completer<ui.Image>();
    final networkImage = NetworkImage(url);

    networkImage.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );

    return completer.future;
  }

  void onTapCreate() {
    Get.toNamed(AppRoutesVT.createWallAmbasseur,
        arguments: {'climbingLocation': gymController.climbingLocationResp});
  }

  Rxn<File> creationImage = Rxn<File>();
  Rxn<String> creationState = Rxn<String>();
  RxInt mousquettesWon = 0.obs;

  Map<String, dynamic> get getFilter => _filtre;

  void onTapEdit() {
    Get.toNamed(AppRoutesVT.editWallAmbassador, arguments: {
      'climbingLocation': gymController.climbingLocationResp,
      "walls": allWalls,
    });
  }

  void onPreviousSprayWall() async {
    indexSprayWall = indexSprayWall - 1 < 0 ? 0 : indexSprayWall - 1;
    actualSprayWallResp.value = sprayWallListResp[indexSprayWall];
    image.value = await loadNetworkImage(actualSprayWallResp.value!.image!);
    isSprayWallDoneBack.value =
        actualSprayWallResp.value!.annotations.isNotEmpty;
    await refreshWall();
  }

  void onNextSprayWall() async {
    indexSprayWall = indexSprayWall + 1 >= sprayWallListResp.length
        ? sprayWallListResp.length - 1
        : indexSprayWall + 1;
    actualSprayWallResp.value = sprayWallListResp[indexSprayWall];
    image.value = await loadNetworkImage(actualSprayWallResp.value!.image!);
    isSprayWallDoneBack.value =
        actualSprayWallResp.value!.annotations.isNotEmpty;
    refreshWall();
  }
}
