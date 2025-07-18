import 'dart:io';

import 'package:app/data/models/Secteur/secteur_svg.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:xml/xml.dart' as xml;

Future<List<SecteurSvg>> loadSvgImage({required String svgImage}) async {
  List<SecteurSvg> maps = [];

  File svgMap = await DefaultCacheManager().getSingleFile(svgImage);

  final svg = await svgMap.readAsString();

  final document = xml.XmlDocument.parse(svg.toString());

  double width = double.parse(document.rootElement.getAttribute('width')!);
  double height = double.parse(document.rootElement.getAttribute('height')!);

  var g_ids = document.findAllElements('g');
  g_ids = g_ids.skip(1);
  for (var g in g_ids) {
    final paths = g.findAllElements('path');
    var secteurName = g.getAttribute('id');
    var svgPath = null;
    var circlePath = null;
    var labelPath = null;
    for (var path in paths) {
      if (path.getAttribute('id')!.contains("Ellipse")) {
        circlePath = path.getAttribute('d');
      } else if (path.getAttribute('id')!.contains("Rect")) {
        svgPath = path.getAttribute('d');
      } else {
        labelPath = path.getAttribute('d');
      }
    }

    if (svgPath == null ||
        secteurName == null ||
        circlePath == null ||
        labelPath == null) {
      continue;
    }
    maps.add(SecteurSvg(
        svgPath: svgPath!,
        width: width,
        height: height,
        secteurName: secteurName,
        circlePath: circlePath!,
        labelPath: labelPath!));
  }

  return maps;
}
