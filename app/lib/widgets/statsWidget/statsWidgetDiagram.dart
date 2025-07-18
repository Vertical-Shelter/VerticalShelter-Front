import 'package:app/Vertical-Tracking/MyStats/stats/myStatsController.dart';
import 'package:app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsWidgetDiagram extends StatelessWidget {
  final List<statsData> pieData;

  final statsData theMostDone;

  StatsWidgetDiagram({
    Key? key,
    required this.pieData,
    required this.theMostDone,
  }) : super(key: key) {}

  BarChartGroupData generateGroupData(int x, double end_0,
      {Color? color, Gradient? gradient}) {
    if (gradient != null) {
      return BarChartGroupData(
        x: x,
        groupVertically: true,
        showingTooltipIndicators: [1],
        barRods: [
          BarChartRodData(
            fromY: 0,
            toY: end_0 / 2,
            borderRadius: BorderRadius.zero,
            color: gradient.colors.first,
            width: 15,
          ),
          BarChartRodData(
            fromY: end_0 / 2,
            toY: end_0,
            color: gradient.colors.last,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            width: 15,
          ),
        ],
      );
    }
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: [0],
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: end_0,
          color: color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          width: 15,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      SizedBox(height: 20),
      Text("${AppLocalizations.of(context)!.bloc_rentrer_par} ${theMostDone.text!}",
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.bodyMedium!),
      SizedBox(height: 10),
      Flexible(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width:
                    pieData.length * (pieData[0].text == AppLocalizations.of(context)!.cotation ? 50 : 100),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) => Text(
                              value.toInt() < pieData.length &&
                                      pieData[value.toInt()].showName
                                  ? pieData[value.toInt()].name!
                                  : "",
                              style: Theme.of(context).textTheme.bodyMedium!),
                          reservedSize: 20,
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                        enabled: false,
                        touchTooltipData: BarTouchTooltipData(
                            tooltipPadding: EdgeInsets.zero,
                            tooltipMargin: 8,
                            getTooltipItem: (
                              BarChartGroupData group,
                              int groupIndex,
                              BarChartRodData rod,
                              int rodIndex,
                            ) {
                              return BarTooltipItem(rod.toY.round().toString(),
                                  Theme.of(context).textTheme.bodyMedium!);
                            })),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    barGroups: [
                      for (var index = 0; index < pieData.length; index++)
                        generateGroupData(
                          index,
                          pieData[index].value.toDouble(),
                          color: pieData[index].color ??
                              Theme.of(context).colorScheme.tertiary,
                          gradient: pieData[index].gradient,
                        ),
                    ],
                    maxY: pieData
                            .map((e) => e.value)
                            .reduce((a, b) => a > b ? a : b) *
                        1.2,
                  ),
                  swapAnimationDuration: Duration.zero,
                ),
              )))
    ]);
  }
}
