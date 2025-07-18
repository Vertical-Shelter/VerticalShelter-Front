import 'package:app/Vertical-Setting/home/homeController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/colorFilter/colorsFilterWidget.dart';
import 'package:app/widgets/gymMap.dart';
import 'package:app/widgets/createWallWidgets/ouvreurNameWidgets.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_content.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_widget.dart';
import 'package:app/widgets/walls/wallMinimalistOuvreurWidget.dart';

class GymBoulderScreen extends GetWidget<VSHomeController> {
  RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    height = height - height * 0.0569;
    return SnappingSheet(
      // TODO: Add your content that is placed
      // behind the sheet. (Can be left empty)
      lockOverflowDrag: true,
      controller: controller.snappingSheetController,
      grabbingHeight: controller.grabbingHeigh.value,
      onSnapStart: (positionData, snappingPosition) {
        if (snappingPosition ==
            controller.snappingSheetController.snappingPositions.first) {
          controller.isSheetOpen.value = false;
          controller.climbingLocationController.selectedSecteur.value = null;
          controller.climbingLocationController.filterWall({"area": null});
        } else {
          controller.isSheetOpen.value = true;
        }
      },
      grabbing: _grabbing(context),
      // TODO: Add your grabbing widget here,
      sheetBelow: SnappingSheetContent(
        childScrollController: controller.scrollController,
        draggable: true,
        // TODO: Add your sheet content here
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: double.infinity,
          width: width,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: blocsContaier(context),
        ),
      ),
      child: MapContainer(context),
    );
  }

  Widget MapContainer(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          // Action to perform when clicked outside the Stack
          // For example, you can deselect any selected shape
          controller.climbingLocationController.selectedSecteur.value = null;
          controller.snappingSheetController.snapToPosition(
              controller.snappingSheetController.snappingPositions.first);
          Future.delayed(const Duration(milliseconds: 250), () {
            controller.climbingLocationController.filterWall({"area": null});
          });
        },
        child: Obx(() => Opacity(
              opacity: controller.isSheetOpen.value ? 0.5 : 1,
              child: GymMap(
                  secteurSvgList:
                      controller.climbingLocationController.secteurSvgList,
                  selectedSecteur: controller.climbingLocationController
                              .selectedSecteur.value ==
                          null
                      ? null
                      : [],
                  onShapeSelected:
                      controller.climbingLocationController.filterWall,
                  snappingSheetController: controller.snappingSheetController,
                  labelNextSecteur: controller
                      .climbingLocationController.labelNextSecteur.value,
                  labelSecteurRecent: controller
                      .climbingLocationController.labelSecteurRecent.value),
            )));
  }

  Widget _grabbing(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Theme.of(context).colorScheme.surfaceContainer),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          height: 5,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.onSurface),
        ),
        Obx(() =>
            controller.climbingLocationController.selectedSecteur.value != null
                ? Text(
                    controller.climbingLocationController.selectedSecteur.value!
                        .secteurName
                        .toString(),
                  )
                : Container()),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Opacity(
                    opacity:
                        controller.climbingLocationController.isActual.value ==
                                "actual"
                            ? 1
                            : 0.5,
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.only(top: 10, bottom: 10)),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent)),
                      onPressed: () {
                        controller.climbingLocationController
                            .filterWall({"isActual": true});
                      },
                      child: Text(
                        AppLocalizations.of(context)!.secteurs_actuels,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )),
                Opacity(
                    opacity:
                        controller.climbingLocationController.isActual.value ==
                                "old"
                            ? 1
                            : 0.5,
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.only(top: 10, bottom: 10)),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent)),
                      onPressed: () {
                        controller.climbingLocationController
                            .filterWall({"isActual": false});
                      },
                      child: Text(
                        AppLocalizations.of(context)!.secteurs_demonter,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )),
              ],
            )),
        ColorFilterWidget(
          controller.climbingLocationController.colorFilterController.value!,
          onPressed: () {
            if (controller.climbingLocationController.colorFilterController
                    .value!.is_SubGrade &&
                controller.climbingLocationController.colorFilterController
                        .value!.index.value !=
                    -1) {
              controller.grabbingHeigh.value = 265;
            } else {
              controller.grabbingHeigh.value = 200;
            }
          },
        ),
        LimitedBox(
            maxHeight: 80,
            child: OuvreurNameWidget(
              onTap: controller.climbingLocationController.filterWall,
              controllers: controller
                  .climbingLocationController.climbingLocationResp!.ouvreurNames
                  .map((element) => TextEditingController(text: element))
                  .toList(),
            ))
      ]),
    );
  }

  Widget navigationBarContainer(double height, double width) {
    return Container(
        padding: EdgeInsets.only(
            left: width * 0.01,
            right: width * 0.01,
            bottom: height * 0.01,
            top: height * 0.01),
        decoration: BoxDecoration(
          color: ColorsConstantDarkTheme.neutral_white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: ColorsConstantDarkTheme.neutral_white,
          surfaceTintColor: Colors.transparent,
          height: height * 0.06,
          destinations: [
            NavigationDestination(
                icon: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(AppLocalizations.of(Get.context!)!.secteurs_actuels,
                      style: AppTextStyle.rmResizable(18).copyWith(
                          color: ColorsConstant.greyText.withOpacity(0.2))),
                  Container(
                    height: height * 0.008,
                  )
                ]),
                selectedIcon: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(AppLocalizations.of(Get.context!)!.secteurs_actuels,
                      style: AppTextStyle.rmResizable(18)),
                  Container(
                    height: height * 0.008,
                    width: width * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: ColorsConstant.blue),
                  )
                ]),
                label: "Actual"),
            NavigationDestination(
                icon: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(AppLocalizations.of(Get.context!)!.secteurs_demonter,
                      style: AppTextStyle.rmResizable(18).copyWith(
                          color: ColorsConstant.greyText.withOpacity(0.2))),
                  Container(
                    height: height * 0.008,
                    width: width * 0.12,
                  )
                ]),
                selectedIcon: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(AppLocalizations.of(Get.context!)!.secteurs_demonter,
                      style: AppTextStyle.rmResizable(18)),
                  Container(
                    height: height * 0.008,
                    width: width * 0.11,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: ColorsConstant.blue),
                  )
                ]),
                label: "Old"),
          ],
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: selectedIndex.value,
          onDestinationSelected: (int index) {
            selectedIndex.value = index;
            selectedIndex.refresh();
            controller.climbingLocationController
                .filterWall({'isActual': index == 0 ? true : false});
          },
        ));
  }

  Widget blocsContaier(BuildContext context) {
    return Obx(() => Container(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: controller.climbingLocationController.displayedWalls.isEmpty
            ? Center(
                child: Text(
                AppLocalizations.of(Get.context!)!
                    .aucun_mur_trouve_pour_ce_secteur,
                style: AppTextStyle.rb30,
                textAlign: TextAlign.center,
              ))
            : ListView.separated(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                itemCount: controller
                        .climbingLocationController.displayedWalls.length +
                    1,
                shrinkWrap: true,
                controller: controller.scrollController,
                separatorBuilder: (context, index) =>
                    SizedBox(height: height * 0.01),
                itemBuilder: (context, index) {
                  if (index ==
                      controller
                          .climbingLocationController.displayedWalls.length) {
                    return SizedBox(height: height * 0.2);
                  } else {
                    return WallMinimalistOuvreurWidget(
                      onPressed: () =>
                          Get.toNamed(AppRoutesVS.WallScreenRoute, parameters: {
                        'wallId': controller.climbingLocationController
                            .displayedWalls[index].id!,
                        'SecteurId': controller.climbingLocationController
                            .displayedWalls[index].secteurResp!.id,
                        'climbingLocationId': controller
                            .climbingLocationController
                            .climbingLocationResp!
                            .id,
                      }),
                      wallMinimalResp: controller
                          .climbingLocationController.displayedWalls[index],
                    );
                  }
                })));
  }
}
