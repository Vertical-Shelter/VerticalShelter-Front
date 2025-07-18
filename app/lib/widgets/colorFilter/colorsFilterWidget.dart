import 'dart:math';

import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/data/models/grade/gradeResp.dart';
import 'package:app/widgets/colorFilter/colorFilterController.dart';
import 'package:flutter/material.dart';
import 'package:app/core/app_export.dart';

class ColorFilterWidget extends StatelessWidget {
  ColorFilterController controller;
  RxList<WallResp> displayedWalls = <WallResp>[].obs;
  static double gradeSizeRatio = 0.06;
  final void Function()? onPressed;

  ColorFilterWidget(this.controller, {this.onPressed}) {}

  Widget gradeTreeToWidget(
      GradeTree gradeTree, int index, BuildContext context) {
    String ref1 = controller.gradesTree[index].ref1;
    //print(ref1);
    // if no wall -> skip
    // if(ref1.contains("F0E50D")){
    //   return Obx(() => InkWell());
    // }
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
            if (onPressed != null) onPressed!();
            if (controller.refresh != null) controller.refresh!();
          },
          child: Row(children: [
            ref1.length >= 4
                ? Container(
                    width: 60,
                    alignment: Alignment.center,
                    decoration: ref1.length <= 6
                        ? BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: controller.index.value == -1 ||
                                    controller.index.value == index
                                ? ColorsConstant.fromHex(ref1)
                                : ColorsConstant.fromHex(ref1).withOpacity(0.3))
                        : BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            gradient: LinearGradient(
                                colors: controller.index.value == -1 ||
                                        controller.index.value == index
                                    ? [
                                        ColorsConstant.fromHex(
                                            ref1.split(",")[0]),
                                        ColorsConstant.fromHex(
                                            ref1.split(",")[0]),
                                        ColorsConstant.fromHex(
                                            ref1.split(",")[1]),
                                        ColorsConstant.fromHex(
                                            ref1.split(",")[1])
                                      ]
                                    : [
                                        ColorsConstant.fromHex(
                                                ref1.split(",")[0])
                                            .withOpacity(0.3),
                                        ColorsConstant.fromHex(
                                                ref1.split(",")[0])
                                            .withOpacity(0.3),
                                        ColorsConstant.fromHex(
                                                ref1.split(",")[1])
                                            .withOpacity(0.3),
                                        ColorsConstant.fromHex(
                                                ref1.split(",")[1])
                                            .withOpacity(0.3)
                                      ],
                                stops: [0.0, 0.3, 0.3, 1.0],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight)))
                : Container(
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: controller.index.value == -1 ||
                                controller.index.value == index
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.3)),
                    child: Text(
                      ref1,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: controller.index.value == -1 ||
                                    controller.index.value == index
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(context).colorScheme.surface,
                          ),
                    ),
                  ),
          ]),
        ));
  }

  Widget subGradeToList(GradeResp grade, int index) {
    String ref1 = controller.gradesTree[controller.index.value].ref1;
    String ref2 =
        controller.gradesTree[controller.index.value].subgrades![index].ref2!;
    return Obx(() => InkWell(
        onTap: () {
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
        child: Container(
          width: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: controller.subindex.value == -1 ||
                      controller.subindex.value == index
                  ? ColorsConstant.fromHex(ref1)
                  : ColorsConstant.fromHex(ref1).withOpacity(0.3)),
          child: Text(ref2,
              style: AppTextStyle.rmResizable(15).copyWith(
                  color: ColorsConstant.fromHex(ref1).computeLuminance() >
                          sqrt(1.05 * 0.05) - 0.05
                      ? ColorsConstantDarkTheme.purple
                      : ColorsConstantDarkTheme.neutral_white)),
        )));
  }

  @override
  Widget build(BuildContext context) {
    //  controller.gradeTreeFiltered();

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: 30,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.gradesTree.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(
                    width: 5,
                  ),
                  itemBuilder: (context, index) {
                    return gradeTreeToWidget(
                        controller.gradesTree[index], index, context);
                  },
                )),
            Obx(
              () => controller.index.value != -1 && controller.is_SubGrade
                  ? Container(
                      alignment: Alignment.centerLeft,
                      height: 30,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.gradesTree.length + 2,
                          itemBuilder: (context, index) {
                            var ind = -index +
                                controller.gradesTree[controller.index.value]
                                    .subgrades!.length +
                                controller.index.value -
                                1;
                            if (ind == 3) {
                              return Container();
                            }
                            if (ind >= 3 || ind < 0) {
                              return Container(
                                width: 65,
                              );
                            } else if (ind < 3 && ind >= 0) {
                              return Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: subGradeToList(
                                      controller
                                          .gradesTree[controller.index.value]
                                          .subgrades![2 - ind],
                                      2 - ind));
                            }
                          }))
                  : Container(),
            ),
          ],
        ));
  }
}
