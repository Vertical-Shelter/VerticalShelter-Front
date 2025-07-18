import 'package:app/Vertical-Tracking/editSecteurAmbassadeur/editSecteurController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/gymMap.dart';
import 'package:app/widgets/snappingSheet/snapping_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditSecteurAmabassadeurScreen
    extends GetWidget<EditSecteurAmabassadeurController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              toolbarHeight: height * 0.07,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BackButtonWidget(
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    Spacer(),
                    Text(
                      AppLocalizations.of(Get.context!)!.modifier_secteur,
                    ),
                    Spacer(),
                  ]),
            ),
            body: Obx(
              () => controller.is_done_loading.value == false
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SnappingSheet(
                      // TODO: Add your content that is placed
                      // behind the sheet. (Can be left empty)
                      lockOverflowDrag: true,
                      onSnapStart: (positionData, snappingPosition) {
                        if (snappingPosition ==
                            controller.snappingSheetController.snappingPositions
                                .first) {
                          controller.isSheetOpen.value = false;
                          controller.filterWall({"area": null});
                        } else {
                          controller.isSheetOpen.value = true;
                        }
                      },
                      controller: controller.snappingSheetController,
                      grabbingHeight: 130,
                      grabbing: _grabbing(context),
                      // TODO: Add your grabbing widget here,
                      sheetBelow: SnappingSheetContent(
                          childScrollController: controller.scrollController,
                          draggable: true,
                          // TODO: Add your sheet content here
                          child: Container(
                              clipBehavior: Clip.hardEdge,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              width: width,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: _child(context))),
                      child: GymMap(
                          secteurSvgList: controller.secteurSvgList,
                          selectedSecteur:
                              controller.selectedSecteur.value == null
                                  ? null
                                  : [controller.selectedSecteur.value!],
                          onShapeSelected: controller.filterWall,
                          snappingSheetController:
                              controller.snappingSheetController,
                          labelNextSecteur: [],
                          labelSecteurRecent: [])),
            )));
  }

  Widget _grabbing(BuildContext context) {
    return Obx(() => Column(children: [
          controller.isSheetOpen.value &&
                  controller.selectedSecteur.value != null &&
                  controller.createWallList.isNotEmpty
              ? Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 80,
                  child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.imageList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == controller.imageList.length) {
                          return Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  borderRadius: BorderRadius.circular(8)),
                              width: 80,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    controller.getImages();
                                  },
                                ),
                              ));
                        }
                        if (controller.imageList[index] is CachedNetworkImage) {
                          return InkWell(
                              onLongPress: () =>
                                  controller.modifyImages(context),
                              onTap: () => controller.modifyImages(context),
                              child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  width: 80,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        controller.imageList[index].imageUrl!,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )));
                        }
                        return InkWell(
                            onTap: () => controller.modifyImages(context),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(
                                          controller.imageList[index]),
                                      fit: BoxFit.fill),
                                  borderRadius: BorderRadius.circular(8)),
                              width: 80,
                            ));
                      }))
              : Container(
                  height: 80,
                ),
          SizedBox(height: 10),
          Flexible(
              child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Theme.of(context).colorScheme.surface),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 5,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    Theme.of(context).colorScheme.onSurface)),
                        SizedBox(height: 10),
                        if (controller.selectedSecteur.value != null)
                          Text(
                            controller.selectedSecteur.value!.secteurName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                      ],
                    ),
                  ))),
        ]));
  }

  Widget _child(BuildContext context) {
    if (controller.selectedSecteur.value == null) {
      return SingleChildScrollView(
        controller: controller.scrollController,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Center(
          child: Text(
            AppLocalizations.of(Get.context!)!.veuillez_selectionner_un_secteur,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    if (controller.createWallList.isEmpty) {
      return SingleChildScrollView(
        controller: controller.scrollController,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Center(
          child: Text(
            AppLocalizations.of(Get.context!)!.aucun_mur_trouve_pour_ce_secteur,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: ListView(
          physics: BouncingScrollPhysics(),
          controller: controller.scrollController,
          children: [
            Obx(() => ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                itemCount: controller.createWallList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return controller.createWallList[index];
                })),
            SizedBox(height: height * 0.027),
            InkWell(
                onTap: controller.onTapPlus,
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.add,
                      ),
                      Text(
                        AppLocalizations.of(Get.context!)!.ajouter_un_bloc,
                      )
                    ],
                  ),
                )),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () {
                          controller.createWallList.clear();
                          controller.selectedSecteur.value = null;
                          controller.snappingSheetController.snapToPosition(
                              controller.snappingSheetController
                                  .snappingPositions.first);
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
                            AppLocalizations.of(Get.context!)!.annuler,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ))),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: InkWell(
                        onTap: () {
                          controller.EditWall(context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 24, right: 24, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.onSurface),
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(Get.context!)!.valider,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                          ),
                        )))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
