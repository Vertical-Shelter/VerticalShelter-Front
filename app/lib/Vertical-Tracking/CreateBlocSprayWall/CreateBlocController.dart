import 'dart:async';
import 'dart:ui' as ui;

import 'package:app/Vertical-Tracking/CreateBlocSprayWall/SelectHolds.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/Annotation/Annotation.dart';
import 'package:app/data/models/SprayWall/hold.dart';
import 'package:app/data/models/SprayWall/sprayWallApi.dart';
import 'package:app/data/models/SprayWall/sprayWallBoulderReq.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:app/utils/sprayWallController.dart';
import 'package:app/widgets/colorFilter/colorFilterController.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_widget.dart';
import 'package:app/widgets/vid%C3%A9oCapture.dart';

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

class CreateBlocController extends GetxController {
  RxList<String> attributesSelectedList = <String>[].obs;
  RxString selectedCotation = "".obs;
  ColorFilterController? colorFilterController;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  RxDouble grabbingHeigh = 150.0.obs;
  RxBool errorGrade = false.obs;
  RxBool errorAttribute = false.obs;
  RxBool isFirstStep = true.obs;
  RxBool errorEquivalentExte = false.obs;
  RxBool errorName = false.obs;
  final SnappingSheetController snappingSheetController =
      SnappingSheetController();
  VideoCapture videoCapture = VideoCapture('createSprayWall');

  RxnString currentWallImage = RxnString();
  String currentSprayWallId = "";

  RxList<HoldResp> selectedPolygons = <HoldResp>[].obs;

  RxDouble imageWidth = 100.0.obs;
  RxDouble imageHeight = 100.0.obs;

  RxBool isLoading = true.obs;

  RxDouble imageAspectRatio = 1.0.obs;

  ClimbingLocationController climbingLocationController =
      Get.find<ClimbingLocationController>();

  SprayWallController sprayWallController = Get.find<SprayWallController>();

 

  // Rxn<ui.Image> image = Rxn<ui.Image>();

  // Future<ui.Image> loadNetworkImage(String url) async {
  //   final completer = Completer<ui.Image>();
  //   final networkImage = NetworkImage(url);

  //   networkImage.resolve(ImageConfiguration()).addListener(
  //     ImageStreamListener((ImageInfo info, bool _) {
  //       completer.complete(info.image);
  //     }),
  //   );

  //   return completer.future;
  // }

  @override
  void onInit() {
    super.onInit();

    getSprayWall();
    colorFilterController = ColorFilterController(
      gradesTree: GradeTreeFromList(
          climbingLocationController.climbingLocationResp!.gradeSystem!),
    );
  }

  Future<void> getSprayWall() async {
    currentSprayWallId = Get.parameters['sprayWallId']!;
    try {
      final saveImage =
          Image.network(sprayWallController.actualSprayWallResp.value!.image!);

      saveImage.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo info, bool synchronousCall) {
          // Récupérer la taille de l'image une fois chargée
          imageWidth.value = info.image.width.toDouble();
          imageHeight.value = info.image.height.toDouble();

          imageAspectRatio.value = imageWidth.value / imageHeight.value;
        }),
      );
      isLoading.value = false;
      isLoading.refresh();
    } on Exception catch (e) {
      // hasError.value = true;
      isLoading.value = false;
    }
  }

  List<Offset> convertAnnotation(
      double scaleX, double scaleY, Annotation? hold) {
    if (hold == null) {
      return [];
    }
    List<Offset> segment = [];
    for (var i = 0; i < hold.segmentation.length - 1; i += 2) {
      segment.add(Offset(
          hold.segmentation[i] * scaleX, hold.segmentation[i + 1] * scaleY));
    }
    return segment;
  }

  void selectPolygon(PolygonPainterController painterController, String id) {
    if (!selectedPolygons.any((x) => (x.id.compareTo(id) == 0))) {
      selectedPolygons.add(HoldResp(id: id, type: 0));
    } else {
      HoldResp current =
          selectedPolygons.firstWhere((x) => (x.id.compareTo(id) == 0));
      if (current.type < 2) {
        current.type += 1;
      } else {
        selectedPolygons.remove(current);
      }
    }
    painterController.redraw();
  }

 

  // // Fonction pour charger l'image et obtenir ses dimensions
  // Future<void> fetchImageSize() async {
  //   if (currentWallImage.value == null) return;

  //   final Completer<void> completer = Completer();
  

  //   // Attendre la fin du chargement
  //   await completer.future;
  // }

  // Rxn<ui.Image> image = Rxn<ui.Image>();

  // Future<ui.Image> loadNetworkImage(String url) async {
  //   final completer = Completer<ui.Image>();
  //   final networkImage = NetworkImage(url);

  //   networkImage.resolve(ImageConfiguration()).addListener(
  //     ImageStreamListener((ImageInfo info, bool _) {
  //       completer.complete(info.image);
  //     }),
  //   );

  //   return completer.future;
  // }


  double calculatePolygonPerimeter(List<Offset> points) {
    double perimeter = 0.0;
    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];
      perimeter += (p1 - p2).distance;
    }
    return perimeter;
  }

  Future<void> CreateBlocPost() async {
    errorGrade.value = false;
    errorAttribute.value = false;
    errorEquivalentExte.value = false;
    errorName.value = false;
    if (colorFilterController!.selectedGrade.value == null) {
      errorGrade.value = true;
    }
    if (selectedCotation.value.isEmpty) {
      errorEquivalentExte.value = true;
    }
    if (nameController.value.text.isEmpty) {
      errorName.value = true;
    }
    if (attributesSelectedList.isEmpty) {
      errorAttribute.value = true;
    }

    if (errorGrade.value ||
        errorAttribute.value ||
        errorEquivalentExte.value ||
        errorName.value) {
      return;
    }

    SprayWallBoulderMinimalReq bloc = SprayWallBoulderMinimalReq(
        name: nameController.value.text,
        description: descriptionController.value.text,
        gradeId: colorFilterController!.selectedGrade.value!.id,
        holds: selectedPolygons,
        attributes: attributesSelectedList,
        equivalentExte: selectedCotation.value,
        date: DateTime.now().toString());
    SprayWallBoulderReq req = SprayWallBoulderReq(
        spraywall_bloc: bloc,
        betaOuvreur: videoCapture.file,
        beta_url: videoCapture.url);
    createBlocPost(req, climbingLocationController.climbingLocationResp!.id!,
            currentSprayWallId)
        .then((value) {
      sprayWallController.allWalls.add(value);
      sprayWallController.filterWall({});
    });
    Get.back();
  }
}
