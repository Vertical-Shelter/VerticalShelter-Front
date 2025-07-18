import 'dart:math';

import 'package:app/data/models/grade/gradeResp.dart';
import 'package:app/widgets/GenericButton.dart';
import 'package:app/widgets/colorFilter/colorFilterController.dart';
import 'package:app/core/app_export.dart';

class ColorFilterStatsWidget extends StatelessWidget {
  ColorFilterController controller;
  static double gradeSizeRatio = 0.05;
  static late double gradeSize;

  ColorFilterStatsWidget(this.controller) {
    gradeSize = gradeSizeRatio * Get.height;
  }

  Widget gradeTreeToWidget(
      GradeTree gradeTree, int index, BuildContext context) {
    String ref1 = controller.gradesTree[index].ref1;
    return Obx(() => InkWell(
          onTap: () {
            controller.subindex.value = -1;
            if (index == controller.index.value) {
              controller.index.value = -1;
              controller.selectedGrade.value = null;
            } else {
              controller.index.value = index;
              if (!controller.is_SubGrade) {
                controller.selectedGrade.value =
                    controller.gradesTree[index].grade;
              }
            }
            if (controller.refresh != null) controller.refresh!();
          },
          child: Row(children: [
            ref1.length >= 4
                ? Container(
                    height: gradeSize,
                    width: gradeSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: controller.index == -1 ||
                                controller.index == index
                            ? ColorsConstant.fromHex(ref1)
                            : ColorsConstant.fromHex(ref1).withOpacity(0.5)),
                  )
                : Container(
                    height: gradeSize,
                    width: gradeSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color:
                            controller.index == -1 || controller.index == index
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.5)),
                    child: Text(
                      ref1,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: controller.index == -1 ||
                                    controller.index == index
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(context).colorScheme.surface,
                          ),
                    ),
                  ),
          ]),
        ));
  }

  Widget subGradeToList(GradeResp grade, int index, BuildContext context) {
    String ref1 = controller.gradesTree[controller.index.value].ref1;
    String ref2 =
        controller.gradesTree[controller.index.value].subgrades![index].ref2!;
    return Obx(() => GenericButtonWidget(
        onPressed: () {
          if (index == controller.subindex.value) {
            controller.subindex.value = -1;
            controller.selectedGrade.value = null;
            controller.ref2 = null;
          } else {
            controller.subindex.value = index;
            controller.ref2 = ref2;
            controller.selectedGrade.value =
                controller.gradesTree[controller.index.value].subgrades![index];
          }
          if (controller.refresh != null) controller.refresh!();
        },
        button: Container(
          padding: EdgeInsets.only(
              left: width * 0.02,
              right: width * 0.02,
              top: height * 0.01,
              bottom: height * 0.01),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            border: Border.all(
              width: 2,
              color: ColorsConstant.greyText,
            ),
            color: ColorsConstantDarkTheme.neutral_white,
          ),
          child: Row(children: [
            Container(
                height: gradeSize,
                width: gradeSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: controller.subindex == -1 || controller.ref2 == ref2
                        ? ColorsConstant.fromHex(ref1)
                        : ColorsConstant.fromHex(ref1).withOpacity(0.5)),
                child: Text(
                  ref2,
                  style: AppTextStyle.rmResizable(15).copyWith(
                      color: ColorsConstant.fromHex(ref1).computeLuminance() >
                              sqrt(1.05 * 0.05) - 0.05
                          ? Colors.black
                          : ColorsConstantDarkTheme.neutral_white),
                )),
            SizedBox(
              width: width * 0.02,
            ),
            Text(
              controller.numberOfWall![ref1][ref2].toString(),
              style: AppTextStyle.rmResizable(15).copyWith(color: Colors.black),
            ),
          ]),
        )));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> row = controller.gradesTree
        .asMap()
        .map((key, value) =>
            MapEntry(key, gradeTreeToWidget(value, key, context)))
        .values
        .toList();
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                // width: contesxt.width,
                child: Row(
              children: row,
            )),
            Obx(
              () => controller.index.value != -1 && controller.is_SubGrade
                  ? Container(
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                                SizedBox(
                                    width: (controller.index.value < 1 ||
                                                controller.index.value >=
                                                    controller
                                                            .gradesTree.length -
                                                        2
                                            ? (controller.index.value < 1
                                                ? 0
                                                : controller.gradesTree.length -
                                                    3)
                                            : controller.index.value - 1) *
                                        (gradeSize +
                                            width *
                                                0.11)), // for the first element
                              ] +
                              controller
                                  .gradesTree[controller.index.value].subgrades!
                                  .asMap()
                                  .map((key, value) => MapEntry(
                                      key, subGradeToList(value, key, context)))
                                  .values
                                  .toList()))
                  : Container(),
            ),
          ],
        ));
  }
}
