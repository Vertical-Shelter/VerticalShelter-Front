import 'package:app/Vertical-Setting/createWall/createWallController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/gymMap.dart';
import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/snappingSheet/snapping_sheet.dart';

// ignore: must_be_immutable
class VSCreateWallScreen extends GetWidget<VSCreateWallController> {
  SnappingSheetController _snappingSheetController = SnappingSheetController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              toolbarHeight: 80,
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
                      AppLocalizations.of(context)!.creer_votre_secteur,
                      style: Theme.of(context).textTheme.labelLarge,
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
                            _snappingSheetController.snappingPositions.first) {
                          controller.isSheetOpen.value = false;
                        } else {
                          controller.isSheetOpen.value = true;
                        }
                      },
                      controller: _snappingSheetController,
                      grabbingHeight: 130,
                      grabbing: _grabbing(context),
                      // TODO: Add your grabbing widget here,
                      sheetBelow: SnappingSheetContent(
                          childScrollController: controller.scrollController,
                          draggable: true,
                          // TODO: Add your sheet content here
                          child: _child(context)),
                      child: GymMap(
                          secteurSvgList: controller.secteurSvgList,
                          selectedSecteur:
                              controller.selectedSecteur.value == null
                                  ? null
                                  : [controller.selectedSecteur.value!],
                          onShapeSelected: controller.filterWall,
                          snappingSheetController: _snappingSheetController,
                          labelNextSecteur: controller.labelNextSecteur.value,
                          labelSecteurRecent:
                              controller.labelSecteurRecent.value)),
            )));
  }

  Widget _child(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Container(
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.only(left: 10, right: 10),
            width: width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: ListView(
              physics: BouncingScrollPhysics(),
              controller: controller.scrollController,
              children: [
                Obx(() => ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                    itemCount: controller.createWallModules.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return controller.createWallModules[index];
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
                            AppLocalizations.of(context)!.ajouter_un_bloc,
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
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 24, right: 24, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.primary,
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
                            onTap: () => controller.createWall(context),
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
                const SizedBox(
                  height: 20,
                ),
              ],
            )));
  }

  Widget _grabbing(BuildContext context) {
    return Column(children: [
      Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 80,
          child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(width: 10),
              scrollDirection: Axis.horizontal,
              itemCount: controller.image.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.image.length) {
                  return InkWell(
                      onLongPress: () => controller.modifyImages(context),
                      onTap: () => controller.modifyImages(context),
                      child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface,
                              borderRadius: BorderRadius.circular(8)),
                          width: 80,
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Theme.of(context).colorScheme.surface,
                                size: 30,
                              ),
                              onPressed: () {
                                controller.getImages();
                              },
                            ),
                          )));
                }
                return InkWell(
                    onLongPress: () => controller.modifyImages(context),
                    onTap: () => controller.modifyImages(context),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(controller.image[index]),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(8)),
                      width: 80,
                    ));
              })),
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
                            color: Theme.of(context).colorScheme.onSurface)),
                    SizedBox(height: 10),
                    if (controller.selectedSecteur.value != null)
                      Text(
                        controller.selectedSecteur.value!.secteurName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              )))
    ]);
  }
}
