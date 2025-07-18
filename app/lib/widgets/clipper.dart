import 'dart:ui';

import 'package:app/core/app_export.dart';
import 'package:path_drawing/path_drawing.dart';

class Clipper extends CustomClipper<Path> {
  Offset shift;
  double width;
  double height;
  Clipper({
    required this.height,
    required this.width,
    required this.svgPath,
    this.shift = const Offset(0, 0),
  });

  String svgPath;

  @override
  Path getClip(Size size) {
    var path = parseSvgPathData(svgPath);
    double scaleX = size.width / width;
    double scaleY = size.height / height;
    final Matrix4 matrix4 = Matrix4.identity();
    //add text in middle

    matrix4.scale(scaleX, scaleX);
    return path.transform(matrix4.storage);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class Clipper2 extends CustomClipper<Path> {
  Offset shift;
  Clipper2({
    required this.svgPath,
    this.shift = const Offset(0, 0),
  });

  String svgPath;

  @override
  Path getClip(Size size) {
    var path = parseSvgPathData(svgPath);
    Matrix4 matrix4 = Matrix4.identity();
    double scaleX = size.width / 247;
    double scaleY = size.height / 241;

    // Create a transformation matrix to scale the path
    Matrix4 matrix = Matrix4.identity();
    matrix.scale(scaleX, scaleY);

    path = path.transform(matrix.storage);

    matrix4 = Matrix4.identity();
    //add oval in middle
    Rect oval = Rect.fromCircle(
        center: Offset(path.getBounds().center.dx, path.getBounds().center.dy),
        radius: 10.0);
    //change color of oval

    Path path2 = Path();
    path2.addOval(oval);
    return path2.transform(matrix4.storage).shift(shift);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
