import 'dart:ui';
import 'dart:ui' as ui;

import 'package:app/Vertical-Tracking/CreateBlocSprayWall/CreateBlocController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/Annotation/Annotation.dart';
import 'package:app/data/models/SprayWall/sprayWallBoulderReq.dart';
import 'package:app/widgets/CustomPaintHolds.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/colorFilter/colorsFilterWidget.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class SelectHoldsScreen extends GetWidget<CreateBlocController> {
  ScrollController _scrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.creer_boulder),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: BackButton(
            onPressed: () => {
              Get.back(),
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          onPressed: () {
            if (controller.isFirstStep.value) {
              controller.isFirstStep.value = false;
              _scrollController.animateTo(height,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            } else {
              controller.isFirstStep.value = true;
              _scrollController.animateTo(0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            }
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Obx(() => controller.isFirstStep.value
              ? Icon(Icons.check)
              : Icon(Icons.arrow_upward)),
        ),
        resizeToAvoidBottomInset: true,
        body: ListView(
          controller: _scrollController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            firstStep(context),
            SizedBox(height: height, child: secondStep(context)),
          ],
        ));
  }

  Widget firstStep(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SprayWallMap(context, BoxConstraints(maxWidth: width)),
            CustomText(context, Theme.of(context).colorScheme.tertiary,
                "1 ${AppLocalizations.of(context)!.clique} : ${AppLocalizations.of(context)!.prise_de_main}"),
            CustomText(context, Theme.of(context).colorScheme.secondary,
                "2 ${AppLocalizations.of(context)!.clique} : ${AppLocalizations.of(context)!.prise_de_pied}"),
            CustomText(context, Theme.of(context).colorScheme.primary,
                "3 ${AppLocalizations.of(context)!.clique} : ${AppLocalizations.of(context)!.prise_de_start_fin}"),
          ],
        ));
  }

  Widget SprayWallMap(BuildContext context, BoxConstraints constraints) {
    return Obx(() => SizedBox(
          width: width,
          height: 500,
          child: controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : Stack(alignment: Alignment.bottomRight, children: [
                  InteractiveViewer(
                    boundaryMargin: EdgeInsets.all(20),
                    minScale: 1.0,
                    maxScale: 6.0,
                    child: SizedBox(
                        width: constraints.maxWidth,
                        height: 500,
                        child: MyPolygonWidget()),
                  ),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: Icon(
                        Icons.pinch_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      )),
                ]),
        ));
  }

  Widget CustomText(BuildContext context, Color color, String text) {
    return Row(
      children: [
        Container(
          width: 15.0,
          height: 15.0,
          margin: EdgeInsets.all(5),
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.5)),
        ),
        Text(text),
      ],
    );
  }

  Widget _FilterSection() {
    return ColorFilterWidget(
      controller.colorFilterController!,
      onPressed: () {
        if (controller.colorFilterController!.is_SubGrade &&
            controller.colorFilterController!.index.value != -1) {
          controller.grabbingHeigh.value = 165;
        } else {
          controller.grabbingHeigh.value = 150;
        }
      },
    );
  }

  Widget secondStep(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Obx(
                    () => !controller.errorName.value
                        ? Text(
                            AppLocalizations.of(context)!.nom_mur + " *",
                          )
                        : Text(
                            AppLocalizations.of(context)!.nom_mur + " *",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontStyle: FontStyle.italic),
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorsConstantDarkTheme.neutral_grey,
                              width: 1.0),
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Obx(
                () => !controller.errorGrade.value
                    ? Text(
                        AppLocalizations.of(context)!.cotation + " *",
                      )
                    : Text(
                        AppLocalizations.of(context)!.cotation + " *",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontStyle: FontStyle.italic),
                      ),
              )),
          Padding(padding: const EdgeInsets.all(10.0), child: _FilterSection()),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Obx(
                () => !controller.errorEquivalentExte.value
                    ? Text(
                        AppLocalizations.of(context)!.cotation +
                            " Fontainebleau *",
                      )
                    : Text(
                        AppLocalizations.of(context)!.cotation +
                            " Fontainebleau *",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontStyle: FontStyle.italic),
                      ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LimitedBox(
                maxHeight: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Obx(() => ButtonWidget(
                          borderRadius: 8,
                          isSelected: controller.selectedCotation.value ==
                              cotationList[index],
                          onPressed: () {
                            controller.selectedCotation.value =
                                cotationList[index];
                          },
                          child: Text(
                            cotationList[index],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                          ),
                        ));
                  },
                  separatorBuilder: (context, _) => SizedBox(
                    width: 5,
                  ),
                  itemCount: cotationList.length,
                )),
          ),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Obx(
                () => !controller.errorAttribute.value
                    ? Text(
                        AppLocalizations.of(context)!.type_de_bloc + " *",
                      )
                    : Text(
                        AppLocalizations.of(context)!.type_de_bloc + " *",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontStyle: FontStyle.italic),
                      ),
              )),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: LimitedBox(
                  maxHeight: 40,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Obx(() => ButtonWidget(
                            borderRadius: 8,
                            isSelected:
                                controller.attributesSelectedList.isEmpty ||
                                    controller.attributesSelectedList.contains(
                                        controller
                                            .climbingLocationController
                                            .climbingLocationResp!
                                            .attributes[index]),
                            onPressed: () {
                              if (controller.attributesSelectedList.contains(
                                  controller
                                      .climbingLocationController
                                      .climbingLocationResp!
                                      .attributes[index])) {
                                controller.attributesSelectedList.remove(
                                    controller
                                        .climbingLocationController
                                        .climbingLocationResp!
                                        .attributes[index]);
                              } else if (controller
                                      .attributesSelectedList.length >=
                                  3) {
                                print(
                                    "Vous ne pouvez pas ajouter plus de types");

                                ;
                              } else {
                                controller.attributesSelectedList.add(controller
                                    .climbingLocationController
                                    .climbingLocationResp!
                                    .attributes[index]);
                              }
                            },
                            child: Text(
                              controller.climbingLocationController
                                  .climbingLocationResp!.attributes[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background),
                            )));
                      },
                      separatorBuilder: (context, _) => SizedBox(
                            width: 5,
                          ),
                      itemCount: controller.climbingLocationController
                          .climbingLocationResp!.attributes.length))),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text("Description"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller.descriptionController,
                      onTap: () => {
                        controller.isFirstStep.value = false,
                        _scrollController.animateTo(height + height * 0.21,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.easeInOut)
                      },
                      onSubmitted: (value) => {
                        controller.isFirstStep.value = false,
                        _scrollController.animateTo(height,
                            duration: Duration(milliseconds: 250),
                            curve: Curves.easeInOut)
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ColorsConstantDarkTheme.neutral_grey,
                              width: 1.0),
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                AppLocalizations.of(context)!.beta,
              )),
          Container(
            alignment: Alignment.center,
            height: height * 0.21,
            child: controller.videoCapture,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    controller.CreateBlocPost();
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 24, right: 24, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    alignment: Alignment.center,
                    child: Text(AppLocalizations.of(context)!.ajouter,
                        style: Theme.of(context).textTheme.bodyMedium!),
                  )))
        ]);
  }
}

class MyPolygonWidget extends StatelessWidget {
  final PolygonPainterController painterController = PolygonPainterController();
  @override
  Widget build(BuildContext context) {
    final CreateBlocController controller = Get.find();
    double scaleX = width / controller.imageWidth.value;
    double scaleY = 500 / controller.imageHeight.value;

    return GestureDetector(onTapUp: (details) {
      final tapPosition = details.localPosition;

      List<Annotation> possiblePolygons = [];

      for (Annotation hold in controller
          .sprayWallController.actualSprayWallResp.value!.annotations) {
        var annotations = controller.convertAnnotation(scaleX, scaleY, hold);
        final path = Path()..moveTo(annotations[0].dx, annotations[0].dy);
        for (int i = 1; i < annotations.length; i++) {
          path.lineTo(annotations[i].dx, annotations[i].dy);
        }
        path.close();

        if (path.contains(tapPosition)) {
          possiblePolygons.add(hold);
          //controller.selectPolygon(painterController, hold.id);
          //break;
        }
      }
      if (possiblePolygons.isNotEmpty) {
        // Trouver le polygone avec le plus petit périmètre
        //(peut-être changer pour un calcul de surface si prise complexe)
        Annotation smallestPolygon = possiblePolygons.first;
        double smallestPerimeter = controller.calculatePolygonPerimeter(
          controller.convertAnnotation(scaleX, scaleY, smallestPolygon),
        );
        for (Annotation hold in possiblePolygons) {
          double currentPerimeter = controller.calculatePolygonPerimeter(
            controller.convertAnnotation(scaleX, scaleY, hold),
          );
          if (currentPerimeter < smallestPerimeter) {
            smallestPolygon = hold;
            smallestPerimeter = currentPerimeter;
          }
        }
        controller.selectPolygon(painterController, smallestPolygon.id);
      }
    }, child: Obx(() {
      if (controller.sprayWallController.actualSprayWallResp.value != null) {
        return CustomPaint(
            size: Size(width, controller.imageHeight.value),
            painter: PolygonPainter(
              controller.sprayWallController.image.value!,
              controller
                  .sprayWallController.actualSprayWallResp.value!.annotations,
              controller.selectedPolygons,
              scaleX,
              500 / controller.imageHeight.value,
              painterController,
            ));
      } else {
        return SizedBox();
      }
    }));
  }
}

class PolygonPainterController extends ChangeNotifier {
  void redraw() {
    notifyListeners();
  }
}
