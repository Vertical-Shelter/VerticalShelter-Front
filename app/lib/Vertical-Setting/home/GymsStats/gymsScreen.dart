import 'package:app/Vertical-Setting/BottomBar/bottomBarController.dart';
import 'package:app/Vertical-Setting/home/homeController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/colorFilter/colorsFilterWidget.dart';
import 'package:app/widgets/gymMap.dart';
import 'package:app/widgets/createWallWidgets/ouvreurNameWidgets.dart';
import 'package:app/widgets/reloadButton.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_content.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_widget.dart';

class GymStatScreen extends GetWidget<VSHomeController> {
  RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
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
            child: Obx(
              () => controller.is_done_loading_wall.value == false
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.hasError.value == true
                      ? Center(child: ReloadButtonWidget(onPressed: () {
                          controller.getGym();
                        }))
                      : statBlocContainer(context)
            )),
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
        Obx(() => Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
                "${controller.climbingLocationController.numberOfWallSelected} ${AppLocalizations.of(context)!.blocs_actuels}"))),
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
        SizedBox(
          height: 10,
        ),
        LimitedBox(
            maxHeight: 80,
            child: OuvreurNameWidget(
              onTap: controller.climbingLocationController.filterWall,
              controllers: controller
                  .climbingLocationController.climbingLocationResp!.ouvreurNames
                  .map((element) => TextEditingController(text: element))
                  .toList(),
            )),
      ]),
    );
  }

  Widget statBlocContainer(BuildContext context) {
    if (controller.climbingLocationController.dataStats.values.isEmpty) {
      return Center(
          child: Text(AppLocalizations.of(Get.context!)!
              .aucun_mur_trouve_pour_ce_secteur));
    }
    int lenght = controller.climbingLocationController.dataStats.values
        .reduce((a, b) => a + b)
        .toInt();

    return Obx(() => Container(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 10),
            controller: controller.scrollController,
            itemBuilder: (context, index) {
              if (index ==
                  controller.climbingLocationController.dataStats.keys.length) {
                return SizedBox(
                  height: height * 0.2,
                );
              } else {
                String key = controller
                    .climbingLocationController.dataStats.keys
                    .elementAt(index);
                double value =
                    controller.climbingLocationController.dataStats[key]!;
                return Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(key,
                            style: Theme.of(context).textTheme.bodyMedium!)),
                    Flexible(
                        flex: 3,
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text((value * 100 / lenght).round().toString() + '%',
                              style: Theme.of(context).textTheme.bodyMedium!),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: AnimatedContainer(
                            constraints: BoxConstraints(maxWidth: 200),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.surface,
                                Theme.of(context).colorScheme.surface
                              ], stops: [
                                0,
                                value / lenght,
                                value / lenght,
                                1
                              ]),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            height: 10,
                          ))
                        ])),
                  ],
                );
              }
            },
            itemCount:
                controller.climbingLocationController.dataStats.keys.length +
                    1)));
  }
}
