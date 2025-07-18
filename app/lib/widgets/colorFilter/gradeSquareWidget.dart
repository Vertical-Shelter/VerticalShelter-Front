import 'dart:math';

import 'package:app/core/app_export.dart';
import '../../data/models/grade/gradeResp.dart';

class GradeSquareWidget extends StatelessWidget {
  Color? color;
  String? text;
  Gradient? gradient;

  GradeSquareWidget({this.color});

  GradeSquareWidget.fromGrade(GradeResp grade) {
    if (grade.ref1.length > 6) {
      gradient = LinearGradient(colors: [
        ColorsConstant.fromHex(grade.ref1.split(",")[0]),
        ColorsConstant.fromHex(grade.ref1.split(",")[0]),
        ColorsConstant.fromHex(grade.ref1.split(",")[1]),
        ColorsConstant.fromHex(grade.ref1.split(",")[1])
      ], stops: [
        0,
        0.5,
        0.5,
        1
      ], begin: Alignment.bottomLeft, end: Alignment.topRight);
    } else if (grade.ref1.length > 3) {
      color = ColorsConstant.fromHex(grade.ref1);
      text = grade.ref2;
    } else {
      color = null;
      text = grade.ref1;
    }
  }

  @override
  Widget build(BuildContext context) {
    color = color ?? Theme.of(context).colorScheme.onSurface;
    // TODO: implement build
    return Container(
      height: 30,
      width: 30,
      decoration: gradient != null
          ? BoxDecoration(
              gradient: gradient, borderRadius: BorderRadius.circular(8))
          : BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Center(
          child: Text(text ?? '',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: color!.computeLuminance() > sqrt(1.05 * 0.05) - 0.05
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.onSurface,
                  ))),
    );
  }
}
