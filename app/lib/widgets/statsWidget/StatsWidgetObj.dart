import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:app/Vertical-Tracking/MyStats/stats/myStatsController.dart';
import 'package:app/core/app_export.dart';

class StatsWidgetObjectif extends StatelessWidget {
  late statsData pieData;

  StatsWidgetObjectif({
    Key? key,
    required this.pieData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(margin: EdgeInsets.all(5), annotations: [
      CircularChartAnnotation(
          horizontalAlignment: ChartAlignment.center,
          verticalAlignment: ChartAlignment.center,
          height: "180%",
          width: "180%",
          widget: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surface),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    pieData.icon!,
                    SizedBox(height: height * 0.01),
                    Text(
                      pieData.text!,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      pieData.value.toString(),
                      textAlign: TextAlign.center,
                    )
                  ]))),
    ], series: <RadialBarSeries<statsData, String>>[
      RadialBarSeries<statsData, String>(
          pointColorMapper: (datum, index) => datum.color!,
          dataSource: pieData.toList(),
          animationDuration: 0,
          radius: "100%",
          xValueMapper: (statsData data, _) => data.name,
          yValueMapper: (statsData data, _) => data.value,
          dataLabelSettings: DataLabelSettings(isVisible: false)),
    ]);
  }
}
