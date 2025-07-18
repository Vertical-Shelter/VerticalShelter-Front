import 'dart:io';

import 'package:app/Vertical-Setting/home/GymWall/gymWallScreen.dart';
import 'package:app/Vertical-Setting/home/GymsStats/gymsScreen.dart';
import 'package:app/Vertical-Setting/home/sprayWall/sprayWall.dart';

import 'package:app/Vertical-Tracking/profil/profil_controller.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_req.dart';

import 'package:app/data/models/Secteur/secteur_svg.dart';

import 'package:app/data/models/news/userNews/api.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/APIrequest.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/utils/climbingLocationController.dart';

import 'package:app/widgets/gymMap.dart';
import 'package:app/widgets/profil/profilMiniAccount.dart';
import 'package:app/widgets/snappingSheet/src/snapping_position.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_widget.dart';

class VSHomeController extends GetxController with GetTickerProviderStateMixin {
  RxBool hasNotif = false.obs;

  RxList<ClimbingLocationResp> climbingLocationMinimalRespList =
      <ClimbingLocationResp>[].obs;
  RxString actualTab = "".obs;

  Rxn<File> creationImage = Rxn<File>();
  Rxn<String> creationState = Rxn<String>();

  ClimbingLocationController climbingLocationController =
      Get.find<ClimbingLocationController>();

  void onChandeColumnIndex(String tabName) {
    actualTab.value = tabName;
    actualTab.refresh();
  }

  Map<String, dynamic> header = {
    "fr": {
      'Statistiques': Get.put(GymStatScreen()),
      'Blocs': Get.put(GymBoulderScreen()),
      'SprayWall': Get.put(SprayWallViewScreen()),
    },
    "en": {
      'Statistics': Get.put(GymStatScreen()),
      'Boulders': Get.put(GymBoulderScreen()),
      'SprayWall': Get.put(SprayWallViewScreen()),
    }
  };

  @override
  void onInit() async {
    super.onInit();
    await getGym();
    actualTab.value = header[Get.find<PrefUtils>().getLocal()]!.keys.first;
  }

  RxBool is_done_loading_CLoc = false.obs;

  void onTapCreate() {
    Get.toNamed(AppRoutesVS.CreateWallScreenRoute, arguments: {
      'climbingLocation': climbingLocationController.climbingLocationResp
    });
  }

  // void onTapEdit() {
  //   Get.toNamed(AppRoutesVS.EditSecteurScreenRoute, arguments: {
  //     'climbingLocation': climbingLocationResp,
  //     'walls': allWalls["actual"]
  //   });
  // }

  RxList<DateTime?> dates = <DateTime?>[].obs;

  RxInt currentIndex = 1.obs;

  RxBool is_done_loading_wall = false.obs;

  RxBool hasError = false.obs;

  final ScrollController scrollController = ScrollController();

  SnappingSheetController snappingSheetController = SnappingSheetController(
    snappingPositions: [
      SnappingPosition.factor(
        positionFactor: 0.2,
        grabbingContentOffset: GrabbingContentOffset.top,
      ),
      SnappingPosition.factor(positionFactor: 0.8),
    ],
  );

  RxDouble grabbingHeigh = 200.0.obs;

  RxBool isSheetOpen = false.obs;

  Future<void> getGym() async {
    try {
      hasError.value = false;
      hasError.refresh();

      is_done_loading_wall.value = false;
      is_done_loading_wall.refresh();

      is_done_loading_CLoc.value = false;
      is_done_loading_CLoc.refresh();

      await climbingLocationController.getGym(null);

      snappingSheetController.snappingPositions = [
        SnappingPosition.factor(
          positionFactor: 0.3,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 500),
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
        SnappingPosition.factor(
          positionFactor: 0.9,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 500),
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
      ];

      is_done_loading_CLoc.value = true;
      is_done_loading_CLoc.refresh();

      climbingLocationController.filterWall({});

      Get.find<PrefUtils>().setGradeSystem(
          climbingLocationController.climbingLocationResp!.gradeSystem!);

      is_done_loading_wall.value = true;
      is_done_loading_wall.refresh();
    } on ClimbingLocationMinimalResp {
      is_done_loading_wall.value = true;
      is_done_loading_wall.refresh();
    } on NoInternetException catch (e) {
      is_done_loading_wall.value = true;
      is_done_loading_wall.refresh();
      hasError.value = true;
      hasError.refresh();
      Get.rawSnackbar(
          message: e.toString(),
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 5));
    } on Exception catch (e) {
      hasError.value = true;
      hasError.refresh();
      is_done_loading_wall.value = true;
      is_done_loading_wall.refresh();

      Get.rawSnackbar(
          message: e.toString(),
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 5));
    }
  }

  Future<void> changeNewSecteurLabel(List<SecteurSvg> _secteurSvg) async {
    List<String> newlabel = [];
    newlabel = _secteurSvg.map((e) => e.secteurName).toList();

    climbingLocationController.labelNextSecteur.refresh();

    climbingLocation_put(climbingLocationController.climbingLocationResp!.id!,
        ClimbingLocationReq(nextClosedSector: newlabel));

    climbingLocationController.climbingLocationResp!.nextClosedSector =
        newlabel;
    climbingLocationController.labelNextSecteur.value = newlabel;
  }

  void onTapEdit() {
    Get.toNamed(AppRoutesVS.EditSecteurScreenRoute, arguments: {
      'climbingLocation': climbingLocationController.climbingLocationResp,
      'walls': climbingLocationController.allWalls["actual"]
    });
  }

  Future showPopupGymMap(BuildContext context) async {
    RxList<SecteurSvg> _selectedSecteur = <SecteurSvg>[].obs;
    for (var sector in climbingLocationController.secteurSvgList) {
      if (climbingLocationController.labelNextSecteur
          .contains(sector.secteurName)) {
        _selectedSecteur.add(sector);
      }
    }
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    AppLocalizations.of(context)!
                        .veuillez_selectionner_un_secteur,
                  ),
                ),
                Container(
                    height: 300,
                    child: Obx(
                      () => GymMap(
                          height2: 300,
                          secteurSvgList:
                              climbingLocationController.secteurSvgList,
                          selectedSecteur: _selectedSecteur.value,
                          onShapeSelected: (tap) {
                            if (_selectedSecteur.contains(tap["area"])) {
                              _selectedSecteur.remove(tap["area"]);
                            } else {
                              _selectedSecteur.add(tap["area"]);
                            }
                            _selectedSecteur.refresh();
                          },
                          labelNextSecteur:
                              climbingLocationController.labelNextSecteur.value,
                          labelSecteurRecent: climbingLocationController
                              .labelSecteurRecent.value),
                    )),
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 24, right: 24, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!.annuler,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ))),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              changeNewSecteurLabel(_selectedSecteur.value!);

                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 24, right: 24, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!.valider,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: ColorsConstantDarkTheme
                                            .neutral_black),
                              ),
                            )))
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                )
              ],
            )));
  }

  void onTapNotif() {
    VTProfilController profilController = Get.find<VTProfilController>();
    profilController.userResp.value!.lastDateNews = DateTime.now().toUtc();
    profilController.userResp.refresh();
    // colorFilterController?.refresh!();
    // setLastDateNews();
    Get.toNamed(AppRoutesVT.userNewsScreen);
  }

  OnChangeAccountTap(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => Container(
            padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
            child: Column(children: [
              Container(
                height: height * 0.01,
                width: width * 0.3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              SizedBox(height: 20),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  Account account =
                      Get.find<MultiAccountManagement>().accounts[index];

                  if (account.id ==
                      Get.find<MultiAccountManagement>().actifAccount!.id) {
                    return Padding(
                        padding: EdgeInsets.only(bottom: height * 0.01),
                        child: ProfileMiniAccount(
                          isGym: account.isGym,
                          id: account.id,
                          name: account.name,
                          image: account.picture,
                          onTap: () => Get.back(),
                          trailing: Icon(
                            Icons.adjust_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ));
                  }
                  return Padding(
                      padding: EdgeInsets.only(bottom: height * 0.01),
                      child: ProfileMiniAccount(
                        id: account.id,
                        isGym: account.isGym,
                        name: account.name,
                        image: account.picture,
                        onTap: () {
                          Get.find<MultiAccountManagement>()
                              .setActifAccount(account.id);
                          if (account.isGym)
                            Get.offAllNamed(AppRoutesVS.MainPage);
                          else
                            Get.offAllNamed(AppRoutesVT.MainPage);
                        },
                        trailing: Icon(Icons.circle_outlined,
                            color: Theme.of(context).colorScheme.primary),
                      ));
                },
                itemCount: Get.find<MultiAccountManagement>().accounts.length,
              )),
              TextButton(
                  onPressed: () {
                    Get.toNamed(GeneralAppRoutes.VTLogInScreenRoute);
                  },
                  child: Text(AppLocalizations.of(context)!.ajouter_un_compte,
                      style: Theme.of(context).textTheme.bodyMedium!))
            ])));
  }
}
