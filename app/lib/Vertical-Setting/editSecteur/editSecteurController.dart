import 'dart:io';
import 'package:app/Vertical-Setting/BottomBar/bottomBarController.dart';
import 'package:app/Vertical-Setting/GymPlannification/gymPlannificationController.dart';
import 'package:app/Vertical-Setting/home/homeController.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Secteur/secteur_svg.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:app/widgets/colorFilter/colorFilterController.dart';

import 'package:app/core/app_export.dart';
import 'package:app/core/utils/progress_dialog_utils.dart';
import 'package:app/core/utils/svgparse.dart';
import 'package:app/data/models/Secteur/secteur_api.dart';
import 'package:app/data/models/Secteur/secteurResp.dart';
import 'package:app/data/models/Wall/Api.dart';
import 'package:app/data/models/Wall/WallReq.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/data/models/grade/gradeResp.dart';
import 'package:app/widgets/createWallWidgets/createWallWidget.dart';
import 'package:app/widgets/ConfirmDialog.dart';
import 'package:app/widgets/vid%C3%A9oCapture.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:app/widgets/snappingSheet/snapping_sheet.dart';

class VSEditSecteurController extends GetxController {
  // ignore: non_constant_identifier_names
  PageController pageController = PageController();
  RxList<dynamic> imageList = <dynamic>[].obs;
  RxList<CreateWallWidget> createWallList = <CreateWallWidget>[].obs;
  RxBool isSheetOpen = false.obs;
  //ERROR
  String? gradeError;
  String? typeError;
  String? descriptionError;
  String? imageError;
  RxBool is_done_loading = false.obs;
  List<SecteurSvg> secteurSvgList = [];
  SnappingSheetController snappingSheetController = SnappingSheetController();

  Map<String, dynamic> WallModules = <String, dynamic>{};
  SecteurResp? secteurResp;
  Rxn<SecteurSvg> selectedSecteur = Rxn<SecteurSvg>(null);
  ScrollController scrollController = ScrollController();
  ClimbingLocationController climbingLocationController =
      Get.find<ClimbingLocationController>();

  @override
  void onReady() async {
    secteurSvgList = await loadSvgImage(
        svgImage:
            climbingLocationController.climbingLocationResp!.new_topo_url);

    for (var wall in climbingLocationController.allWalls["actual"]!) {
      //get the number of wall
      if (WallModules[wall.secteurResp!.newlabel.toString()] == null) {
        WallModules[wall.secteurResp!.newlabel.toString()] = {
          "wall": [wall],
          "image": wall.secteurResp!.images
        };
      } else {
        WallModules[wall.secteurResp!.newlabel.toString()]!["wall"].add(wall);
      }
    }

    is_done_loading.value = true;
    is_done_loading.refresh();
    super.onReady();
  }

  void constructCreateWallList() {
    createWallList.clear();
    if (WallModules[selectedSecteur.value!.secteurName] == null) {
      return;
    }
    for (var wall in WallModules[selectedSecteur.value!.secteurName]!["wall"]) {
      //get the number of wall
      int wallNumber = createWallList.length + 1;
      secteurResp = (wall as WallResp).secteurResp;
      //get the selected attributes

      CreateWallWidget _createWallWidget = CreateWallWidget(
          wallId: wall.id,
          holds: climbingLocationController.climbingLocationResp!.holds_color,
          key: UniqueKey(),
          validator: (value) => imageError,
          date: wall.date!,
          videoCapture: VideoCapture(
            'createWall',
            isRouteSetter: true,
          ),
          system: climbingLocationController.climbingLocationResp!.gradeSystem!,
          expandableController: ExpandableController(),
          removeIndex: createWallList.length,
          initialOuvreur: wall.routeSetterName!,
          initialDesc: wall.description!,
          ouvreurNames: climbingLocationController
              .climbingLocationResp!.ouvreurNames
              .map((e) => TextEditingController(text: e))
              .toList(),
          initialPrise: wall.hold_to_take!,
          initialAttributes: wall.attributes,
          onPressTrash: (index) {
            CreateWallWidget createWallWidget = createWallList[index];
            deleteWallConfirm(Get.context!, createWallWidget.wallId!, index);
          },
          attributesAllList:
              climbingLocationController.climbingLocationResp!.attributes,
          text: 'Bloc n°' + (wallNumber).toString());

      //set the grade
      _createWallWidget.colorFilterController = ColorFilterController(
          gradesTree: GradeTreeFromList(
              climbingLocationController.climbingLocationResp!.gradeSystem!),
          initialGrade: wall.grade!);

      //set the beta if there is
      if (wall.betaOuvreur != null) {
        _createWallWidget.videoCapture = VideoCapture('edit',
            isRouteSetter: true,
            controller:
                VideoPlayerController.networkUrl(Uri.parse(wall.betaOuvreur!)));
      }

      //get the selected attributes
      _createWallWidget.attributeNameWidget.selectedAttribute = wall.attributes;
      //add to the list
      createWallList.add(_createWallWidget);
    }
    createWallList.refresh();
  }

  Future<void> filterWall(Map<String, dynamic> filtre) async {
    if (filtre.containsKey('area') && filtre['area'] != null) {
      selectedSecteur.value = filtre['area'];
      imageList.clear();
      constructCreateWallList();

      if (WallModules[selectedSecteur.value!.secteurName] != null) {
        for (var _image
            in WallModules[selectedSecteur.value!.secteurName]!["image"]) {
          imageList
              .add(CachedNetworkImage(imageUrl: _image, fit: BoxFit.cover));
        }
      } else {
        snappingSheetController
            .snapToPosition(snappingSheetController.snappingPositions.last);
      }
      imageList.refresh();
    } else {
      selectedSecteur.value = null;
      imageList.clear();
      createWallList.clear();
    }
  }

  void deleteImageAt(int index) {
    imageList.removeAt(index);
    imageList.refresh();
  }

  Future<void> getImages() async {
    final ImagePicker picker = ImagePicker();
    await showDialog<PickedFile>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(Get.context!)!.choisissez_une_option,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                var _image = await picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 50);
                if (_image != null) {
                  imageList.add(new File(_image.path));
                  imageList.refresh();
                }
              },
              child: Text(
                AppLocalizations.of(Get.context!)!.depuis_la_galerie,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                var _image = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                );

                if (_image != null) {
                  var imageFile = File(_image.path);
                  imageList.add(imageFile);
                  imageList.refresh();
                }
              },
              child: Text(
                AppLocalizations.of(Get.context!)!.prendre_une_photo,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> modifyImages(
    BuildContext context,
  ) async {
    // imageList.clear();
    imageList.refresh();
    await showDialog(
        context: context,
        builder: ((context) => Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            backgroundColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: SizedBox(
                height: height * 0.5,
                child: Obx(() => Stack(children: [
                      ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) => SizedBox(
                                width: 10,
                              ),
                          clipBehavior: Clip.none,
                          itemCount: imageList.length + 1,
                          itemBuilder: (context, index) {
                            if (index == imageList.length) {
                              return GestureDetector(
                                  onTap: () {
                                    getImages();
                                  },
                                  child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      width: width * 0.8,
                                      child: Center(
                                        child: IconButton(
                                          icon: Center(
                                              child: Icon(
                                            Icons.add,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            size: 80,
                                          )),
                                          onPressed: () {
                                            getImages();
                                          },
                                        ),
                                      )));
                            }
                            return Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Stack(children: [
                                  Container(
                                      width: width * 0.8,
                                      child:
                                          imageList[index] is CachedNetworkImage
                                              ? imageList[index]
                                              : Image.file(
                                                  imageList[index],
                                                  fit: BoxFit.cover,
                                                )),
                                  Positioned(
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          size: 45,
                                          color: ColorsConstant.redAction,
                                        ),
                                        onPressed: () {
                                          deleteImageAt(index);
                                        },
                                      ))
                                ]));
                          }),
                    ]))))));
  }

  void onTapPlus() {
    createWallList.add(CreateWallWidget(
        validator: (value) => imageError,
        holds: climbingLocationController.climbingLocationResp!.holds_color,
        key: UniqueKey(),
        date: DateTime.now(),
        videoCapture: VideoCapture(
          'createWall',
          isRouteSetter: true,
        ),
        system: climbingLocationController.climbingLocationResp!.gradeSystem!,
        ouvreurNames: climbingLocationController
            .climbingLocationResp!.ouvreurNames
            .map((e) => TextEditingController(text: e))
            .toList(),
        expandableController: ExpandableController(),
        attributesAllList:
            climbingLocationController.climbingLocationResp!.attributes,
        removeIndex: createWallList.length,
        onPressTrash: (index) {
          int removeIndex = (createWallList.removeAt(index)).removeIndex;

          for (int i = removeIndex; i < createWallList.length; i++) {
            createWallList[i].removeIndex = createWallList[i].removeIndex - 1;
            createWallList[i].text = 'Bloc n°${i + 1}';
          }
        },
        text: 'Bloc n°${createWallList.length + 1}'));
  }

  Future<void> popupEditWall(BuildContext context) async {
    try {
      // VERIFICATION DU SECTEUR

      // TODO : send the two images
      if (imageList.isEmpty) {
        imageError =
            AppLocalizations.of(Get.context!)!.veuillez_ajouter_une_image;
        Get.showSnackbar(GetSnackBar(
          message: imageError,
          duration: 3.seconds,
          snackPosition: SnackPosition.BOTTOM,
        ));
        throw Exception();
      }

      if (selectedSecteur.value == null) {
        Get.showSnackbar(GetSnackBar(
          message: AppLocalizations.of(Get.context!)!
              .veuillez_selectionner_un_secteur,
          duration: 3.seconds,
          snackPosition: SnackPosition.BOTTOM,
        ));
        throw Exception();
      }

      for (int i = 0; i < createWallList.length; i++) {
        CreateWallWidget createWallWidget = createWallList[i];

        //get the selected attributes

        if (createWallWidget.attributeNameWidget.selectedAttribute.isEmpty &&
            createWallWidget.initialAttributes.isEmpty) {
          typeError = AppLocalizations.of(Get.context!)!
              .veuillez_choisir_un_type_de_bloc;
          Get.showSnackbar(GetSnackBar(
            message: typeError,
            duration: 3.seconds,
            snackPosition: SnackPosition.BOTTOM,
          ));
          throw Exception();
        }
        GradeResp? _gradeResp =
            createWallWidget.colorFilterController.selectedGrade.value;

        if (_gradeResp == null) {
          gradeError =
              AppLocalizations.of(Get.context!)!.veuillez_choisir_une_cotation;
          Get.showSnackbar(GetSnackBar(
            message: gradeError,
            duration: 3.seconds,
            snackPosition: SnackPosition.BOTTOM,
          ));

          throw Exception();
        }
      }

      await showDialog(
          context: context,
          builder: (context) => ConfirmDialog(
                title: AppLocalizations.of(Get.context!)!.modifier_secteur,
                mainText: AppLocalizations.of(Get.context!)!
                    .alerte_creation_nouveau_secteur,
                onConfirm: (context) {
                  Navigator.of(context).pop();
                  EditWall(context);
                },
                onCancel: (context) {
                  Navigator.of(context).pop();
                },
              ));
    } on Exception {}
  }

  Future deleteWallConfirm(BuildContext context, String id, int index) async {
    print(index);
    await showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
              title: AppLocalizations.of(Get.context!)!.supprimer_un_secteur,
              mainText: AppLocalizations.of(Get.context!)!
                  .alerte_creation_nouveau_secteur,
              onConfirm: (context) async {
                int removeIndex = (createWallList.elementAt(index)).removeIndex;
                createWallList.removeAt(removeIndex);
                createWallList.refresh();
                for (int i = removeIndex; i < createWallList.length; i++) {
                  createWallList[i].removeIndex =
                      createWallList[i].removeIndex - 1;
                  createWallList[i].text = 'Bloc n°${i + 1}';
                }

                deleteWallApi(
                    id,
                    climbingLocationController.climbingLocationResp!.id,
                    secteurResp!.id);
                WallResp wr = climbingLocationController.allWalls["actual"]!
                    .firstWhere((element) => element.id == id);
                climbingLocationController.allWalls["actual"]!
                    .removeWhere((element) => element.id == id);
                Navigator.of(context).pop();
              },
              onCancel: (context) {
                Navigator.of(context).pop();
              },
            ));
  }

  Future<void> EditWall(BuildContext context) async {
    try {
      final cache = DefaultCacheManager(); // Gives a Singleton instance

      Get.find<VSHomeController>().creationImage.value =
          imageList[0] is CachedNetworkImage
              ? await cache.getSingleFile(imageList[0].imageUrl)
              : imageList[0];
      Get.back();

      List<File> _imageList = [];
      for (var _image in imageList) {
        if (_image is File) {
          _imageList.add(_image);
        } else if (_image is CachedNetworkImage) {
          final cache = DefaultCacheManager(); // Gives a Singleton instance
          final file = await cache.getSingleFile(_image.imageUrl);
          _imageList.add(file);
        }
      }
      for (int i = 0; i < createWallList.length; i++) {
        CreateWallWidget createWallWidget = createWallList[i];

        WallReq wallReq = WallReq(
            id: createWallWidget.wallId,
            description: createWallWidget.description.text,
            hold_to_take: createWallWidget.holdNameWidget.selectedHold,
            beta: createWallWidget.videoCapture.file,
            ouvreurName: createWallWidget.ouvreurNameWidget.selectedOuvreur,
            attributes: createWallWidget.attributeNameWidget.selectedAttribute,
            grade: createWallWidget.colorFilterController.selectedGrade.value,
            date: createWallWidget.date);

        if (createWallWidget.wallId == null) {
          wall_post(
                  wallReq,
                  climbingLocationController.climbingLocationResp!.id,
                  secteurResp!.id)
              .then((value) {
            climbingLocationController.allWalls["actual"]!.add(value);
            Get.find<GymPlannificationController>().sortSecteurlist("actual");
            climbingLocationController.filterWall({});
          });
        } else {
          wall_put(
                  wallReq,
                  createWallWidget.wallId!,
                  climbingLocationController.climbingLocationResp!.id,
                  secteurResp!.id)
              .then((value) {
            int index = climbingLocationController.allWalls["actual"]!
                .indexWhere((element) => element.id == value.id);
            climbingLocationController.allWalls["actual"]![index] = value;
            climbingLocationController.filterWall({});
            Get.find<GymPlannificationController>().sortSecteurlist("actual");
          });
        }
      }

      await secteur_update(climbingLocationController.climbingLocationResp!.id,
          secteurResp!.id, _imageList);

      // await Get.find<ClimbingLocationController>().refreshWall();

      Get.find<VSHomeController>().creationState.value = 'success';
      Get.showSnackbar(GetSnackBar(
        message: AppLocalizations.of(Get.context!)!.secteur_modifier_succes,
        duration: 3.seconds,
        snackPosition: SnackPosition.TOP,
      ));
      Future.delayed(Duration(seconds: 3), () {
        Get.find<VSHomeController>().creationState.value = null;
        Get.find<VSHomeController>().creationImage.value = null;
      });
    } on WallResp catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      // if (e.error!.keys.contains('grades'))
      //   gradeError = e.error!['grades'][0]['grade'][0];
    } on Exception {
      Get.find<VSHomeController>().creationState.value = 'error';
      Get.showSnackbar(GetSnackBar(
        message: AppLocalizations.of(Get.context!)!
            .une_erreur_est_survenue_essayez_plus_tard,
        duration: 3.seconds,
        snackPosition: SnackPosition.TOP,
      ));

      Future.delayed(Duration(seconds: 3), () {
        Get.find<VSHomeController>().creationState.value = null;
        Get.find<VSHomeController>().creationImage.value = null;
      });

      rethrow;
    }
  }

  WallReq? EditWallReqMatchingDifference(
      CreateWallWidget createWallWidget, WallResp wallResp) {
    WallReq wallReq = WallReq();

    if (createWallWidget.videoCapture.file != null &&
        createWallWidget.videoCapture.file!.path != wallResp.betaOuvreur) {
      wallReq.beta = createWallWidget.videoCapture.file;
    }
    if (!listEquals(createWallWidget.attributeNameWidget.selectedAttribute,
        wallResp.attributes)) {
      wallReq.attributes =
          createWallWidget.attributeNameWidget.selectedAttribute;
    }
    if (createWallWidget.holdNameWidget.selectedHold != wallResp.hold_to_take) {
      wallReq.hold_to_take = createWallWidget.holdNameWidget.selectedHold;
    }
    if (createWallWidget.ouvreurNameWidget.selectedOuvreur !=
        wallResp.routeSetterName) {
      wallReq.ouvreurName = createWallWidget.ouvreurNameWidget.selectedOuvreur;
    }
    if (createWallWidget.description.text != wallResp.description) {
      wallReq.description = createWallWidget.description.text;
    }
    GradeResp? _gradeResp =
        createWallWidget.colorFilterController.selectedGrade.value;
    if (_gradeResp != wallResp.grade) {
      wallReq.grade = _gradeResp;
    }
    if (wallReq.isNull()) {
      return null;
    }
    return wallReq;
  }
}
