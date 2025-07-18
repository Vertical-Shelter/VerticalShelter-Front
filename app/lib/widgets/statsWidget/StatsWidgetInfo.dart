import 'package:app/Vertical-Tracking/MyStats/stats/myStatsController.dart';
import 'package:app/widgets/colorFilter/gradeSquareWidget.dart';
import 'package:app/core/app_export.dart';

class StatsWidgetInfo extends StatelessWidget {
  final statsData pieData;

  StatsWidgetInfo({
    Key? key,
    required this.pieData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: pieData.color!,
            width: 8,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              pieData.text!,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.01),
            GradeSquareWidget.fromGrade(
              pieData.grade!,
            )
          ],
        ));
  }
}
