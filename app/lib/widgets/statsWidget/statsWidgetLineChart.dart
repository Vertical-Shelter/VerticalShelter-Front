import 'package:app/Vertical-Tracking/MyStats/stats/myStatsController.dart';
import 'package:intl/intl.dart';
import 'package:app/core/app_export.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatsWidgetLineChart extends StatefulWidget {
  final List<statsData> pieData;

  StatsWidgetLineChart({
    Key? key,
    required this.pieData,
  }) : super(key: key);

  @override
  _StatsWidgetLineChartState createState() =>
      _StatsWidgetLineChartState(pieData: pieData);
}

class _StatsWidgetLineChartState extends State<StatsWidgetLineChart> {
  late List<statsData> pieData;
  int minX = 0;
  int maxX = 6;
  _StatsWidgetLineChartState({
    Key? key,
    required this.pieData,
  });

  @override
  Widget build(BuildContext context) {
    double containerWidth = width * 0.9282;
    double containerHeight = height * 0.37;
    return Stack(alignment: Alignment.topCenter, children: [
      Positioned(
          bottom: 0,
          left: 0,
          child: Row(children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (minX > 0) {
                      minX -= 1;
                      maxX -= 1;
                    }
                  });
                },
                icon: Icon(Icons.arrow_left)),
          ])),
      Positioned(
          top: containerHeight * 0.2,
          left: containerWidth * 0.06,
          child: Column(children: [
            Text(AppLocalizations.of(context)!.courbe_de_progression,
                style: AppTextStyle.rr14.copyWith(color: ColorsConstant.blue)),
          ])),
      Positioned(
        top: containerHeight * 0.36,
        height: containerHeight * 0.6,
        width: containerWidth * 0.72,
        child: LineChartWidget(statData: pieData, minX: minX, maxX: maxX),
      ),
    ]);
  }
}

class LineChartWidget extends StatelessWidget {
  List<int> showingTooltipOnSpots = [];
  List<statsData> statData;
  int minX;
  int maxX;
  LineChartWidget({
    super.key,
    required this.statData,
    required this.minX,
    required this.maxX,
  });

  List<FlSpot> allSpotss() {
    List<FlSpot> spots = [];

    for (var index = minX; index <= maxX; index++) {
      spots.add(FlSpot(index.toDouble(), statData[index].value.toDouble()));
      showingTooltipOnSpots.add(index);
    }

    return spots;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(DateFormat('MMM d').format(statData[value.toInt()].name),
          style: AppTextStyle.rr14),
    );
  }

  List<double> generateEquallySpacedValues(int n) {
    if (n <= 1) {
      return [0.0];
    }

    final double step = 1.0 / (n - 1);
    return List.generate(n, (index) => index * step);
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpotss(),
        isCurved: true,
        barWidth: 4,
        dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                  radius: 8, color: statData[index].color!, strokeWidth: 0);
            }),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [for (var stats in statData) stats.color!.withOpacity(0.3)],
            stops: generateEquallySpacedValues(statData.length),
          ),
        ),
        gradient: LinearGradient(
          colors: [for (var stats in statData) stats.color!],
          stops: generateEquallySpacedValues(statData.length),
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return AspectRatio(
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return LineChart(LineChartData(
              showingTooltipIndicators: showingTooltipOnSpots.map((index) {
                return ShowingTooltipIndicators([
                  LineBarSpot(
                    tooltipsOnBar,
                    lineBarsData.indexOf(tooltipsOnBar),
                    tooltipsOnBar.spots[index],
                  ),
                ]);
              }).toList(),
              lineBarsData: lineBarsData,
              minY: 0,
              minX: 0,
              maxX: 6,
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                    return lineBarsSpot.map((lineBarSpot) {
                      final textStyle = TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      );
                      return LineTooltipItem(
                        '${lineBarSpot.y.toInt()}',
                        textStyle,
                      );
                    }).toList();
                  },
                ),
                touchCallback: (touchResponse, LineTouchResponse) {
                  if (LineTouchResponse == null) {
                    return;
                  } else {
                    maxX += 1;
                  }
                },
                handleBuiltInTouches: true,
              ),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return bottomTitleWidgets(
                        value,
                        meta,
                        constraints.maxWidth,
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: false,
                  checkToShowVerticalLine: (value) => value % 1 == 0,
                  getDrawingVerticalLine: (value) =>
                      FlLine(color: ColorsConstant.blue, strokeWidth: 2)),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: ColorsConstant.blue, width: 2),
                  right: BorderSide(color: ColorsConstant.blue, width: 2),
                ),
              )));
        }),
      ),
    );
  }
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s];
    final rightStop = stops[s + 1];
    final leftColor = colors[s];
    final rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
