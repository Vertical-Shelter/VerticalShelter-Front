import 'dart:io';
import 'package:app/Vertical-Tracking/BottomBar/bottomBarController.dart';
import 'package:app/Vertical-Tracking/Gyms/boulder/boulderController.dart';
import 'package:app/Vertical-Tracking/Gyms/gymsController.dart';
import 'package:app/data/models/ClimbingLocation/APIrequest.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_req.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Secteur/secteur_api.dart';
import 'package:app/data/models/Secteur/secteur_req.dart';
import 'package:app/data/models/Secteur/secteurResp.dart';
import 'package:app/data/models/Secteur/secteur_svg.dart';
import 'package:app/data/models/grade/gradeResp.dart';
import 'package:app/widgets/ConfirmDialog.dart';
import 'package:app/widgets/vid%C3%A9oCapture.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:app/core/app_export.dart';
import 'package:app/core/utils/progress_dialog_utils.dart';
import 'package:app/core/utils/svgparse.dart';
import 'package:app/data/models/Wall/Api.dart';
import 'package:app/data/models/Wall/WallReq.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/widgets/createWallWidgets/createWallWidget.dart';

class CreateWallAmbassadeurController extends GetxController {
  // ignore: non_constant_identifier_names
  // ignore: non_constant_identifier_names
  RxList<File> image = <File>[].obs;

  //ERROR
  String? nameError;
  String? climbingLocationError;
  String? gradeError;
  String? typeError;
  String? KOCError;
  String? descriptionError;
  String? imageError;
  String? localizationError;
  RxBool is_done_loading = false.obs;
  List<WallReq> walls = <WallReq>[];
  List<String> selectedAttributes = [];
  ClimbingLocationResp? climbingLocationResp;
  List<SecteurSvg> secteurSvgList = [];
  Rxn<SecteurSvg> selectedSecteur = Rxn<SecteurSvg>(null);
  ScrollController scrollController = ScrollController();
  RxBool isSheetOpen = false.obs;

  List<MultiSelectItem<int>> frameworks = [];
  List<String> _attributesAllList = [];
  RxList<String> labelSecteurRecent = <String>[].obs;
  RxList<String> labelNextSecteur = <String>[].obs;

  RxList<CreateWallWidget> createWallModules = <CreateWallWidget>[].obs;

  @override
  void onInit() async {
    super.onInit();
    climbingLocationResp = Get.arguments['climbingLocation'];
    labelNextSecteur.value = climbingLocationResp!.nextClosedSector ?? [];
    labelNextSecteur.refresh();

    labelSecteurRecent.value = climbingLocationResp!.newSector ?? [];
    labelSecteurRecent.refresh();
  }

  void onTapPlus() {
    if (createWallModules.isNotEmpty) {
      createWallModules.forEach((element) {
        element.expandableController.expanded = false;
      });
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }

    createWallModules.add(CreateWallWidget(
        validator: (value) => imageError,
        holds: climbingLocationResp!.holds_color,
        removeIndex: createWallModules.length,
        date: DateTime.now(),
        key: UniqueKey(),
        expandableController: ExpandableController(initialExpanded: true),
        ouvreurNames: [],
        isAmbaddaseur: true,
        onPressTrash: (index) {
          int removeIndex = (createWallModules.removeAt(index)).removeIndex;

          for (int i = removeIndex; i < createWallModules.length; i++) {
            createWallModules[i].removeIndex =
                createWallModules[i].removeIndex - 1;
            createWallModules[i].text = 'Bloc n°${i + 1}';
          }
        },
        videoCapture: VideoCapture('createWall'),
        system: climbingLocationResp!.gradeSystem!,
        attributesAllList: _attributesAllList,
        text: 'Bloc n°' + (createWallModules.length + 1).toString()));
  }

  Future<void> modifyImages(
    BuildContext context,
  ) async {
    // imageList.clear();
    image.refresh();
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
                          itemCount: image.length + 1,
                          itemBuilder: (context, index) {
                            if (index == image.length) {
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
                                      child: Image.file(
                                        image[index],
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

  @override
  void onReady() async {
    secteurSvgList =
        await loadSvgImage(svgImage: climbingLocationResp!.new_topo_url);
    ;
    _attributesAllList = climbingLocationResp!.attributes;
    onTapPlus();
    is_done_loading.value = true;
    is_done_loading.refresh();
    super.onReady();
  }

  Future<void> filterWall(Map<String, dynamic> filtre) async {
    if (filtre.containsKey('area') && filtre['area'] != null) {
      selectedSecteur.value = filtre['area'];
    } else {
      selectedSecteur.value = null;
    }
  }

  void deleteImageAt(int index) {
    image.removeAt(index);
    image.refresh();
  }

  Future<void> getImages() async {
    final ImagePicker picker = ImagePicker();
    await showDialog<PickedFile>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.choisissez_une_option,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                var _image = await picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 50);
                if (_image != null) {
                  image.add(new File(_image.path));
                  image.refresh();
                }
              },
              child: Text(AppLocalizations.of(context)!.depuis_la_galerie,
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                var _image = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                );

                if (_image != null) {
                  var _imageFile = new File(_image.path);
                  image.add(_imageFile);
                  image.refresh();
                }
              },
              child: Text(
                AppLocalizations.of(context)!.prendre_une_photo,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> createWall(BuildContext context) async {
    try {
      // VERIFICATION DU SECTEUR

      // TODO : send the two images
      if (image.length == 0) {
        imageError = AppLocalizations.of(context)!.veuillez_ajouter_une_image;
        Get.showSnackbar(GetSnackBar(
          message: imageError,
          duration: 3.seconds,
          snackPosition: SnackPosition.BOTTOM,
        ));
        throw Exception();
      }

      if (selectedSecteur.value == null) {
        Get.showSnackbar(GetSnackBar(
          message:
              AppLocalizations.of(context)!.veuillez_selectionner_un_secteur,
          duration: 3.seconds,
          snackPosition: SnackPosition.BOTTOM,
        ));
        throw Exception();
      }

      for (int i = 0; i < createWallModules.length; i++) {
        CreateWallWidget createWallWidget =
            createWallModules[i] as CreateWallWidget;

        //get the selected attributes

        if (createWallWidget.attributeNameWidget.selectedAttribute.isEmpty) {
          typeError =
              'Bloc n°${i + 1} : ${AppLocalizations.of(context)!.veuillez_choisir_un_type_de_bloc}';
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
              'Bloc n°${i + 1} : ${AppLocalizations.of(context)!.veuillez_choisir_une_cotation}';
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
                title: AppLocalizations.of(context)!.creer_votre_secteur,
                mainText: AppLocalizations.of(context)!
                    .alerte_creation_nouveau_secteur,
                onConfirm: (context) {
                  Navigator.of(context).pop();
                  createWallConfirm(context);
                },
                onCancel: (context) {
                  Navigator.of(context).pop();
                },
              ));
    } on Exception {}
  }

  Future<void> createWallConfirm(BuildContext context) async {
    try {
      Get.find<BoulderController>().creationImage.value = image[0];
      Get.back();

      SecteurResp? secteurResp;
      SecteurReq secteurReq = SecteurReq(
        newLabel: selectedSecteur.value!.secteurName,
      );

      // Check if the secteur already exist
      if (climbingLocationResp!.secteurs!.isEmpty ||
          climbingLocationResp!.secteurs!.firstWhereOrNull((element) =>
                  element.newlabel.toString() ==
                  secteurReq.newLabel.toString()) ==
              null) {
        secteurResp = await secteur_post(secteurReq, climbingLocationResp!.id);
      } else {
        secteurResp = climbingLocationResp!.secteurs!.firstWhere((element) =>
            element.newlabel.toString() == secteurReq.newLabel.toString());
        await migrate_to_old_secteur(climbingLocationResp!.id, secteurResp.id);
      }
      await secteur_update(climbingLocationResp!.id, secteurResp.id, image);

      for (int i = 0; i < createWallModules.length; i++) {
        CreateWallWidget createWallWidget =
            createWallModules[i] as CreateWallWidget;

        GradeResp? _gradeResp =
            createWallWidget.colorFilterController.selectedGrade.value;

        WallReq wallReq = WallReq(
          beta: createWallWidget.videoCapture.file,
          hold_to_take: createWallWidget.holdNameWidget.selectedHold,
          description: createWallWidget.description.text,
          attributes: createWallWidget.attributeNameWidget.selectedAttribute,
          grade: _gradeResp!,
          ouvreurName: createWallWidget.ouvreurNameWidget.selectedOuvreur,
        );
        await wall_post(wallReq, climbingLocationResp!.id, secteurResp.id);
      }

      await Get.find<BoulderController>().getBoulders();
      ProgressDialogUtils.hideProgressDialog();

      Get.find<BoulderController>().creationState.value = 'success';
      Get.find<BoulderController>().mousquettesWon.value =
          50 * createWallModules.length;
      Get.showSnackbar(GetSnackBar(
        message:
            AppLocalizations.of(Get.context!)!.votre_secteur_creer_avec_succes,
        duration: 3.seconds,
        snackPosition: SnackPosition.TOP,
      ));
      Future.delayed(Duration(seconds: 4), () {
        Get.find<BoulderController>().creationState.value = null;
        Get.find<BoulderController>().creationImage.value = null;
      });
    } on WallResp catch (e) {
      ProgressDialogUtils.hideProgressDialog();
    } on Exception {
      Get.find<BoulderController>().creationState.value = 'error';
      Get.showSnackbar(GetSnackBar(
        message: AppLocalizations.of(Get.context!)!
            .une_erreur_est_survenue_essayez_plus_tard,
        duration: 3.seconds,
        snackPosition: SnackPosition.TOP,
      ));

      Future.delayed(Duration(seconds: 3), () {
        Get.find<BoulderController>().creationState.value = null;
        Get.find<BoulderController>().creationImage.value = null;
      });

      rethrow;
    }
  }
}
