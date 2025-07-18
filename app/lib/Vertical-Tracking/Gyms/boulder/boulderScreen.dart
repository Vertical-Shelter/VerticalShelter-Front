import 'package:app/Vertical-Tracking/Gyms/boulder/boulderController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/widgets/colorFilter/colorsFilterWidget.dart';
import 'package:app/widgets/floatingButtonWidget.dart';
import 'package:app/widgets/gymMap.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_content.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_widget.dart';
import 'package:app/widgets/walls/wallMinimalistIndoor.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class BoulderScreen extends GetWidget<BoulderController> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.is_done_loading_wall.value == false
        ? const Center(child: CircularProgressIndicator())
        : Stack(children: [
            SnappingSheet(
              // TODO: Add your content that is placed
              // behind the sheet. (Can be left empty)
              lockOverflowDrag: true,
              controller: controller.snappingSheetController,
              grabbingHeight: controller.grabbingHeigh.value,
              onSnapStart: (positionData, snappingPosition) {
                if (snappingPosition ==
                    controller
                        .snappingSheetController.snappingPositions.first) {
                  controller.climbingLocationController.selectedSecteur.value =
                      null;
                  controller.climbingLocationController.selectedSecteur
                      .refresh();
                  controller.climbingLocationController
                      .filterWall({"area": null});
                  controller.isSnappingSheetDown.value = true;
                } else {
                  controller.isSnappingSheetDown.value = false;
                }
              },

              grabbing: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 5,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Obx(() => controller.climbingLocationController
                                  .selectedSecteur.value !=
                              null
                          ? Text(
                              controller.climbingLocationController
                                  .selectedSecteur.value!.secteurName
                                  .toString(),
                            )
                          : Container()),
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(
                                  opacity:
                                      controller.isDone.value == null ? 1 : 0.5,
                                  child: TextButton(
                                    onPressed: () {
                                      controller.isDone.value = null;
                                      controller.climbingLocationController
                                          .filterWall({"isDone": null});
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.tous,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  )),
                              Opacity(
                                  opacity:
                                      controller.isDone.value == true ? 1 : 0.5,
                                  child: TextButton(
                                    onPressed: () {
                                      controller.isDone.value = true;
                                      controller.climbingLocationController
                                          .filterWall({"isDone": true});
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.deja_fait,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  )),
                              Opacity(
                                opacity:
                                    controller.isDone.value == false ? 1 : 0.5,
                                child: TextButton(
                                  onPressed: () {
                                    controller.isDone.value = false;
                                    controller.climbingLocationController
                                        .filterWall({"isDone": false});
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.a_faire,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      _FilterSection(),
                    ]),
              ),
              // TODO: Add your grabbing controller here,
              sheetBelow: SnappingSheetContent(
                  childScrollController: _scrollController,
                  draggable: true,
                  // TODO: Add your sheet content here
                  child: Obx(
                    () => controller.is_done_loading_wall.value == false
                        ? const Center(child: CircularProgressIndicator())
                        : boulders(context),
                  )),
              child: MapContainer(context),
            ),
            //every time the selectedSecteur changes, animate the display of a red dot

            Positioned(
              bottom: 20,
              right: 10,
              child: controller.climbingLocationController.climbingLocationResp!
                          .isPartnership ==
                      false
                  ? floatingButtonWidget(
                      creationImage: controller.creationImage,
                      creationState: controller.creationState,
                      count: controller.mousquettesWon.value,
                      children: [
                        SpeedDialChild(
                          child: const Icon(
                            Icons.add,
                            size: 30,
                          ),
                          foregroundColor:
                              Theme.of(context).colorScheme.surface,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          label: AppLocalizations.of(Get.context!)!
                              .nouveau_secteur,
                          onTap: controller.onTapCreate,
                        ),
                        SpeedDialChild(
                          child: const Icon(Icons.brush),
                          foregroundColor:
                              Theme.of(context).colorScheme.surface,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          label: AppLocalizations.of(Get.context!)!
                              .modifier_secteur,
                          onTap: controller.onTapEdit,
                        ),
                      ],
                    )
                  : SizedBox(),
            )
          ]));
  }

  Widget MapContainer(BuildContext context) {
    return Column(children: [
      Expanded(
          child: GestureDetector(
              onTap: () async {
                // Action to perform when clicked outside the Stack
                // For example, you can deselect any selected shape
                controller.climbingLocationController.selectedSecteur.value =
                    null;
                controller.snappingSheetController.snapToPosition(
                    controller.snappingSheetController.snappingPositions.first);
                Future.delayed(const Duration(milliseconds: 250), () {
                  controller.climbingLocationController
                      .filterWall({"area": null});
                });
              },
              child: Obx(() => Opacity(
                    opacity: controller.isSnappingSheetDown.value ? 1 : 0.5,
                    child: GymMap(
                        secteurSvgList: controller
                            .climbingLocationController.secteurSvgList,
                        selectedSecteur: controller.selectSectorByColor(),
                        onShapeSelected:
                            controller.climbingLocationController.filterWall,
                        snappingSheetController:
                            controller.snappingSheetController,
                        labelNextSecteur: controller
                            .climbingLocationController.labelNextSecteur.value!,
                        labelSecteurRecent: controller
                            .climbingLocationController
                            .labelSecteurRecent
                            .value),
                  ))))
    ]);
  }

  Widget _FilterSection() {
    return Container(
        width: width,
        child: ColorFilterWidget(
          controller.climbingLocationController.colorFilterController.value!,
          onPressed: () {
            if (controller.climbingLocationController.colorFilterController
                    .value!.is_SubGrade &&
                controller.climbingLocationController.colorFilterController
                        .value!.index.value !=
                    -1) {
              controller.grabbingHeigh.value = 150;
            } else {
              controller.grabbingHeigh.value = 110;
            }
          },
        ));
  }

  Widget boulders(BuildContext context) {
    return Container(
        clipBehavior: Clip.hardEdge,
        height: double.infinity,
        width: width,
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Container(
            padding: EdgeInsets.only(
              top: height * 0.01,
            ),
            child: controller.climbingLocationController.displayedWalls.isEmpty
                ? ListView(controller: _scrollController, children: [
                    Center(
                        child: Text(
                      AppLocalizations.of(context)!
                          .aucun_mur_trouve_pour_ce_secteur,
                      textAlign: TextAlign.center,
                    ))
                  ])
                : ListView.separated(
                    shrinkWrap: true,
                    controller: _scrollController,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    itemCount: controller
                            .climbingLocationController.displayedWalls.length +
                        1,
                    separatorBuilder: (context, index) => SizedBox(
                          height: height * 0.01,
                        ),
                    itemBuilder: (context, index) {
                      if (index ==
                          controller.climbingLocationController.displayedWalls
                              .length) {
                        return SizedBox(
                          height: height * 0.1,
                        );
                      }
                      return Column(children: [
                        DisplaySector(index),
                        WallMinimalistIndoorWidget(
                          secteurPk: controller.climbingLocationController
                              .displayedWalls[index].secteurResp!.id,
                          climbingLocPk: controller.climbingLocationController
                              .climbingLocationResp!.id,
                          wallMinimalResp: controller
                              .climbingLocationController.displayedWalls[index],
                          isNext: controller
                              .climbingLocationController.labelNextSecteur
                              .contains(controller.climbingLocationController
                                  .displayedWalls[index].secteurResp!.newlabel
                                  .toString()),
                          isRecent: controller
                              .climbingLocationController.labelSecteurRecent
                              .contains(controller.climbingLocationController
                                  .displayedWalls[index].secteurResp!.newlabel
                                  .toString()),
                          onPressed: () => (Get.toNamed(
                              AppRoutesVT.WallScreenRoute,
                              parameters: {
                                'WallId': controller.climbingLocationController
                                    .displayedWalls[index].id!,
                                'SecteurId': controller
                                    .climbingLocationController
                                    .displayedWalls[index]
                                    .secteurResp!
                                    .id,
                                'climbingLocationId': controller
                                    .climbingLocationController
                                    .climbingLocationResp!
                                    .id,
                                'WallIdNext': index + 1 ==
                                        controller.climbingLocationController
                                            .displayedWalls.length
                                    ? controller.climbingLocationController
                                        .displayedWalls[0].id!
                                    : controller.climbingLocationController
                                        .displayedWalls[index + 1].id!,
                                'SecteurIdNext': index + 1 ==
                                        controller.climbingLocationController
                                            .displayedWalls.length
                                    ? controller.climbingLocationController
                                        .displayedWalls[0].secteurResp!.id
                                    : controller
                                        .climbingLocationController
                                        .displayedWalls[index + 1]
                                        .secteurResp!
                                        .id,
                                'ClimbingIdNext': controller
                                    .climbingLocationController
                                    .climbingLocationResp!
                                    .id,
                              })),
                        )
                      ]);
                    })));
  }

  bool oneSector(List<WallResp> listwalls, int index) {
    bool res = true;
    String sector = listwalls[index].secteurResp!.newlabel;
    listwalls.forEach((x) =>
        (x.secteurResp!.newlabel.compareTo(sector) != 0 ? res = false : null));
    return res;
  }

  Widget DisplaySector(int index) {
    if (!oneSector(
        controller.climbingLocationController.displayedWalls, index)) {
      if (index == 0) {
        return Container(
            width: width,
            height: 25,
            padding: EdgeInsets.only(left: 10),
            child: Text(controller.climbingLocationController
                .displayedWalls[index].secteurResp!.newlabel));
      }
      if (index > 0 &&
          controller.climbingLocationController.displayedWalls[index]
                  .secteurResp!.newlabel
                  .compareTo(controller.climbingLocationController
                      .displayedWalls[index - 1].secteurResp!.newlabel) !=
              0) {
        return Container(
            width: width,
            height: 25,
            padding: EdgeInsets.only(left: 10),
            child: Text(controller.climbingLocationController
                .displayedWalls[index].secteurResp!.newlabel));
      }
    }
    return Container();
  }
}
