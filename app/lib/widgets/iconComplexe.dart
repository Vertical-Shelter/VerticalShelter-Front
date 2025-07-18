import 'package:app/core/app_export.dart';
import 'package:app/data/models/Secteur/secteur_svg.dart';
import 'package:app/widgets/clipper.dart';
import 'package:app/widgets/snappingSheet/snapping_sheet.dart';
import 'package:flutter/services.dart';

class iconComplexe extends StatefulWidget {
  String svgAssetPath;
  iconComplexe({
    required this.svgAssetPath,
  });
  @override
  _iconComplexeState createState() => _iconComplexeState();
}

class _iconComplexeState extends State<iconComplexe> {
  String rawSvg = '';

  @override
  void initState() {
    super.initState();
    _loadSvg();
  }

  void _loadSvg() async {
    final rawSvg = await rootBundle.loadString(widget.svgAssetPath);
    setState(() {
      this.rawSvg = rawSvg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _getClippedImage(
        clipper: Clipper(
      height: 50,
      width: 50,
      svgPath: rawSvg,
    ));
  }

  Widget _getClippedImage({
    required CustomClipper<Path> clipper,
  }) {
    return ClipPath(
      clipper: clipper,
    );
  }
}
