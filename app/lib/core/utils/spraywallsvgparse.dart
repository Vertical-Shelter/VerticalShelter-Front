import 'dart:io';

import 'package:app/data/models/Secteur/secteur_svg.dart';
import 'package:app/data/models/SprayWall/sprayWall_svg.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:xml/xml.dart' as xml;

Future<List<SprayWallSVG>> loadSvgSprayWall({required String svgImage}) async {
  List<SprayWallSVG> maps = [];

  File svgMap = await DefaultCacheManager().getSingleFile(svgImage);

  final svg = await svgMap.readAsString();

  final document = xml.XmlDocument.parse(svg.toString());

  double width = double.parse(document.rootElement.getAttribute('width')!);
  double height = double.parse(document.rootElement.getAttribute('height')!);

  var g_ids = document.findAllElements('path');
  g_ids.skip(1);
  for (var g in g_ids) {
    final paths = g.getAttribute('d');
    var id = g.getAttribute('id');

    maps.add(SprayWallSVG(
      svgPath: paths!,
      id: id!,
      width: width,
      height: height,
    ));
  }

  return maps;
}
