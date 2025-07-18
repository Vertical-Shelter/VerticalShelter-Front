import 'package:app/Vertical-Tracking/profil/profil_controller.dart';
import 'package:app/core/app_export.dart';
import 'package:app/utils/sprayWallController.dart';
import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/colorFilter/colorsFilterWidget.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_content.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_widget.dart';
import 'package:app/widgets/walls/sprayWallWidget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:app/data/models/Secteur/secteur_svg.dart';

class SprayWallScreen extends GetWidget<SprayWallController> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.is_done_loading_wall.value == false
        ? const Center(child: CircularProgressIndicator())
        : Stack(children: [
            SnappingSheet(
              lockOverflowDrag: true,
              controller: controller.snappingSheetController,
              grabbingHeight: controller.grabbingHeigh.value,
              onSnapStart: (positionData, snappingPosition) {
                if (snappingPosition ==
                    controller
                        .snappingSheetController.snappingPositions.first) {
                  controller.filterWall({"area": null});
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
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(
                                  opacity:
                                      controller.isDone.value == null ? 1 : 0.5,
                                  child: TextButton(
                                    onPressed: () {
                                      controller.isDone.value = null;
                                      controller.filterWall({});
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
                                      controller.filterWall({});
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
                                    controller.filterWall({});
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
                      SizedBox(
                        height: 10,
                      ),
                      _FilterFontGradeSection(),
                    ]),
              ),
              sheetBelow: SnappingSheetContent(
                  childScrollController: _scrollController,
                  draggable: true,
                  child: sprayWallList(context)),
              child: MapContainer(context),
            ),
            Positioned(
                bottom: 20,
                right: 10,
                child: Visibility(
                    visible: controller.isSprayWallDoneBack.value,
                    child: ButtonWidget(
                        borderRadius: 25,
                        width: 50,
                        onPressed: () => {
                              Get.toNamed(AppRoutesVT.createBlocSprayWall,
                                  parameters: {
                                    'ClimbingId': controller.actualSprayWallResp
                                        .value!.climbingLocation_id!,
                                    'sprayWallId': controller
                                        .actualSprayWallResp.value!.id!
                                  })
                            },
                        child: Icon(
                          Icons.add,
                          color: ColorsConstantDarkTheme.Natural_Button,
                        ))))
          ]));
  }

  Widget MapContainer(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        InteractiveViewer(
          minScale: 1,
          maxScale: 4.0,
          child: Obx(() => controller.actualSprayWallResp.value != null &&
                  controller.actualSprayWallResp.value!.image != null
              ? Stack(alignment: AlignmentDirectional.center, children: [
                  Image.network(controller.actualSprayWallResp.value!.image!,
                      fit: BoxFit.fill,
                      opacity: !controller.isSprayWallDoneBack.value
                          ? const AlwaysStoppedAnimation(.5)
                          : null),
                  Visibility(
                      visible: !controller.isSprayWallDoneBack.value,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("SprayWall en cours de traitement ..."),
                            Text("Cela peut prendre une journée complète")
                          ]))
                ])
              : Center(
                  child: Text(
                    "Vous n'avez pas encore ajouté de SprayWall, veuillez en ajouter un pour continuer",
                    textAlign: TextAlign.center,
                  ),
                )),
        ),
        Visibility(
            visible: controller.actualSprayWallResp.value != null &&
                controller.actualSprayWallResp.value!.image != null &&
                controller.indexSprayWall != 0,
            child: Positioned(
                left: 0,
                child: BackButtonWidget(
                  onPressed: () {
                    controller.onPreviousSprayWall();
                  },
                ))),
        Visibility(
            visible: controller.actualSprayWallResp.value != null &&
                controller.actualSprayWallResp.value!.image != null &&
                controller.indexSprayWall !=
                    controller.sprayWallListResp.length - 1,
            child: Positioned(
                right: 0,
                child: InkWell(
                  onTap: () => controller.onNextSprayWall(),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(180)),
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: Icon(Icons.arrow_forward,
                          size: width * 0.05,
                          color: Theme.of(context).colorScheme.onSurface)),
                )))
      ],
    );
  }

  Widget _FilterSection() {
    return Container(
        width: width,
        child: Obx(() => ColorFilterWidget(
              controller.colorFilterController.value!,
              onPressed: () {
                if (controller.colorFilterController.value!.is_SubGrade &&
                    controller.colorFilterController.value!.index.value != -1) {
                  controller.grabbingHeigh.value = 1700;
                } else {
                  controller.grabbingHeigh.value = 150;
                }
              },
            )));
  }

  Widget sprayWallList(BuildContext context) {
    return Scaffold(
        body: Container(
            clipBehavior: Clip.hardEdge,
            height: double.infinity,
            width: width,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer),
            child: Container(
                padding: EdgeInsets.only(
                  top: height * 0.01,
                ),
                child: Obx(() => controller.displayedWalls.isEmpty
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
                        itemCount: controller.displayedWalls.length + 1,
                        separatorBuilder: (context, index) => SizedBox(
                              height: height * 0.01,
                            ),
                        itemBuilder: (context, index) {
                          if (index == controller.displayedWalls.length) {
                            return SizedBox(
                              height: height * 0.1,
                            );
                          }
                          return SprayWallWidget(
                              image: controller.image.value!,
                              annotations: controller
                                  .actualSprayWallResp.value!.annotations!,
                              sprayWallResp: controller.displayedWalls[index],
                              sprayWallId:
                                  controller.actualSprayWallResp.value!.id!,
                              onPressed: () => (Get.toNamed(
                                      AppRoutesVT.sprayWallScreen,
                                      parameters: {
                                        'WallId': controller
                                            .displayedWalls[index].id!,
                                        'SprayWallId': controller
                                            .actualSprayWallResp.value!.id!,
                                        'ClimbingId': controller
                                            .actualSprayWallResp
                                            .value!
                                            .climbingLocation_id!,
                                      },
                                      arguments: {
                                        'sprayWallResp': controller
                                            .actualSprayWallResp.value!,
                                        'isProject': false
                                      })));
                        })))));
  }

  Widget _FilterFontGradeSection() {
    return LimitedBox(
      maxHeight: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (controller.selectedCotation
                  .contains(controller.cotationList[index])) {
                controller.selectedCotation.removeWhere(
                    (element) => element == controller.cotationList[index]);
              } else {
                controller.selectedCotation.add(controller.cotationList[index]);
              }
              controller.filterWall({});
            },
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                  color: controller.selectedCotation
                          .contains(controller.cotationList[index])
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  controller.cotationList[index],
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, _) => SizedBox(
          width: 5,
        ),
        itemCount: controller.cotationList.length,
      ),
    );
  }
}
