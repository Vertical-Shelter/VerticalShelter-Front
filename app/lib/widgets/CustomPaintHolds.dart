import 'dart:ui' as ui;
import 'package:app/Vertical-Tracking/CreateBlocSprayWall/SelectHolds.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/Annotation/Annotation.dart';
import 'package:app/data/models/SprayWall/hold.dart';
import 'package:app/data/models/SprayWall/sprayWallBoulderReq.dart';

class PolygonPainter extends CustomPainter {
  final ui.Image image;
  final List<Annotation> listAnnotation;
  final List<HoldResp> selectedPolygons;
  final double scaleX;
  final double scaleY;
  final PolygonPainterController? controller;

  PolygonPainter(this.image, this.listAnnotation, this.selectedPolygons,
      this.scaleX, this.scaleY, this.controller)
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final imagePaint = Paint();
    final imageRect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      imageRect,
      imagePaint,
    );

    final darkPaint = Paint()..color = Colors.black.withOpacity(0.5);
    canvas.drawRect(imageRect, darkPaint);

    for (Annotation hold in listAnnotation) {
      List<Offset> polygon = convertAnnotation(scaleX, scaleY, hold);
      Color paintcolor = Colors.transparent;
      if (selectedPolygons.any((x) => (x.id.compareTo(hold.id) == 0))) {
        HoldResp selectHold =
            selectedPolygons.firstWhere((x) => (x.id.compareTo(hold.id) == 0));
        if (selectHold.type == 0) {
          paintcolor = ColorsConstantDarkTheme.tertiary;
        } else if (selectHold.type == 1) {
          paintcolor = ColorsConstantDarkTheme.secondary;
        } else {
          paintcolor = ColorsConstantDarkTheme.primary;
        }
        final selectedPath = Path()..addPolygon(polygon, true);

        canvas.save();
        canvas.clipPath(selectedPath);

        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          imageRect,
          imagePaint,
        );

        canvas.restore();
      }
      paint.color = paintcolor;

      final path = Path()..moveTo(polygon[0].dx, polygon[0].dy);
      for (int i = 1; i < polygon.length; i++) {
        path.lineTo(polygon[i].dx, polygon[i].dy);
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PolygonPainter oldDelegate) {
    return oldDelegate.selectedPolygons != selectedPolygons;
  }
}

List<Offset> convertAnnotation(double scaleX, double scaleY, Annotation? hold) {
  if (hold == null) {
    return [];
  }
  List<Offset> segment = [];
  for (var i = 0; i < hold.segmentation.length - 1; i += 2) {
    segment.add(Offset(
        hold.segmentation[i] * scaleX, hold.segmentation[i + 1] * scaleY));
  }
  return segment;
}
