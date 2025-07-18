import 'package:app/core/app_export.dart';
import 'package:app/data/models/Annotation/Annotation.dart';
import 'package:app/data/models/SprayWall/hold.dart';
import 'package:app/data/models/SprayWall/sprayWall_svg.dart';
import 'package:app/widgets/CustomPaintHolds.dart';
import 'dart:ui' as ui;

class Spraywallimage extends StatelessWidget {
  final ui.Image image;
  final List<HoldResp> points;
  double width;
  double height;
  List<Annotation> annotations;
  
  Spraywallimage({
    Key? key,
    required this.image,
    required this.points,
    required this.width,
    required this.height,
    required this.annotations,
  }) : super(key: key){
    
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20.0),
        minScale: 0.1,
        maxScale: 4.0,
        child: CustomPaint(
            size: Size(width, height),
            painter: PolygonPainter(
              image,
              annotations,
              //controller.CurrentWall.value!.annotations!,
              points,
              width / image.width, //width / curent.width,
              height / image.height,
//(width / (curent.width / curent.height)) / curent.height,
              null,
            )));
  }

  Widget _getClippedImage({
    required CustomClipper<Path> clipper,
    required SprayWallSVG secteurSvg,
    required Color? color,
    final Function(Map<String, dynamic>)? onShapeSelected,
  }) {
    return ClipPath(
      clipper: clipper,
      child: Container(
        color: color,
      ),
    );
  }

  double calculateScale(double imageWidth, double imageHeight, double boxWidth,
      double boxHeight) {
    // Échelle basée sur le plus petit rapport pour conserver les proportions
    return (boxWidth / imageWidth).clamp(0.0, boxHeight / imageHeight);
  }
}
