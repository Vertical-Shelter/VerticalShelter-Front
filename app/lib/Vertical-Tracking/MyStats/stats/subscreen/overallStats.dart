import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:app/Vertical-Tracking/MyStats/stats/myStatsController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/statsWidget/StatsWidgetInfo.dart';
import 'package:app/widgets/statsWidget/StatsWidgetObj.dart';
import 'package:app/widgets/statsWidget/statsWidgetDiagram.dart';

class VTOverallStatsScreen extends GetWidget<VTMyStatsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.value == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => StaggeredGrid.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          children: [
                            for (var index = 0;
                                index <
                                    controller.overallStats.statsGrid.length;
                                index++)
                              if (controller.overallStats.statsGrid[index].a ==
                                  statsStyle.objectif)
                                Obx(() => StaggeredGridTile.count(
                                    mainAxisCellCount: 2.1,
                                    crossAxisCellCount: 2,
                                    child: StatsWidgetObjectif(
                                      pieData: controller
                                          .overallStats.statsGrid[index].b,
                                    )))
                              else if (controller
                                          .overallStats.statsGrid[index].a ==
                                      statsStyle.barChart &&
                                  controller.overallStats.statsGrid[index].b
                                          .length >
                                      0)
                                Obx(() => StaggeredGridTile.count(
                                    crossAxisCellCount: 4,
                                    mainAxisCellCount: 4,
                                    child: StatsWidgetDiagram(
                                      pieData: controller
                                          .overallStats.statsGrid[index].b,
                                      theMostDone: controller.TheMostDone(
                                          controller
                                              .overallStats.statsGrid[index].b),
                                    )))
                              // else if (controller.overallStats.statsGrid[index].a ==
                              //     statsStyle.lineChart)
                              //   Obx(() => StaggeredGridTile.count(
                              //       crossAxisCellCount: 4,
                              //       mainAxisCellCount: 3,
                              //       child: StatsWidgetLineChart(
                              //         pieData: controller
                              //             .overallStats.statsGrid[index].b,
                              //       )))
                              else if (controller
                                      .overallStats.statsGrid[index].a ==
                                  statsStyle.info)
                                Obx(() => StaggeredGridTile.count(
                                    crossAxisCellCount: 2,
                                    mainAxisCellCount: 2,
                                    child: StatsWidgetInfo(
                                      pieData: controller
                                          .overallStats.statsGrid[index].b,
                                    )))
                              else
                                Container()
                          ])),
                  SizedBox(height: height * 0.2),
                ])));
  }

  Widget RowInfo(String text, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [],
    );
  }
}
