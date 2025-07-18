import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:app/Vertical-Tracking/MyStats/stats/myStatsController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/statsWidget/StatsWidgetInfo.dart';
import 'package:app/widgets/statsWidget/StatsWidgetObj.dart';
import 'package:app/widgets/statsWidget/statsWidgetDiagram.dart';
import 'package:app/widgets/statsWidget/statsWidgetGym.dart';

class VTGymStatsScreen extends GetWidget<VTMyStatsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isGymLoading.value == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                LimitedBox(
                    maxHeight: height * 0.08,
                    child: Obx(() => ListView.separated(
                        itemCount: controller.gymStats.gymLists.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 10,
                            ),
                        itemBuilder: (context, index) {
                          String tapedGym =
                              controller.gymStats.gymLists[index].id;

                          return Obx(() =>
                              tapedGym == controller.gymStats.currentGymId.value
                                  ? StatsWidgetGym(
                                      onTap: () {
                                        controller.gymStats
                                            .changeCurrentGym(tapedGym);
                                      },
                                      climbingLocationMinimalResp:
                                          controller.gymStats.gymLists[index],
                                      isActive: true)
                                  : StatsWidgetGym(
                                      onTap: () {
                                        controller.gymStats
                                            .changeCurrentGym(tapedGym);
                                      },
                                      climbingLocationMinimalResp:
                                          controller.gymStats.gymLists[index]));
                        }))),
                SizedBox(
                  height: context.height * 0.01,
                ),
                Obx(() => StaggeredGrid.count(
                        crossAxisCount: 6,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        children: [
                          for (var index = 0;
                              index < controller.gymStats.statsGrid.length;
                              index++)
                            if (controller.gymStats.statsGrid[index].a ==
                                statsStyle.objectif)
                              Obx(() => StaggeredGridTile.count(
                                  mainAxisCellCount: 3,
                                  crossAxisCellCount: 3,
                                  child: StatsWidgetObjectif(
                                    pieData:
                                        controller.gymStats.statsGrid[index].b,
                                  )))
                            else if (controller.gymStats.statsGrid[index].a ==
                                statsStyle.barChart)
                              Obx(() => StaggeredGridTile.count(
                                  crossAxisCellCount: 6,
                                  mainAxisCellCount: 5,
                                  child: StatsWidgetDiagram(
                                    pieData:
                                        controller.gymStats.statsGrid[index].b,
                                    theMostDone: controller.TheMostDone(
                                        controller.gymStats.statsGrid[index].b),
                                  )))
                            else if (controller.gymStats.statsGrid[index].a ==
                                statsStyle.info)
                              Obx(() => StaggeredGridTile.count(
                                  crossAxisCellCount: 3,
                                  mainAxisCellCount: 3,
                                  child: StatsWidgetInfo(
                                    pieData:
                                        controller.gymStats.statsGrid[index].b,
                                  )))
                        ])),
                SizedBox(height: height * 0.2),
              ]));
  }
}
