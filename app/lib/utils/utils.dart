
  import 'dart:async';
import 'dart:ui' as ui;

import 'package:app/core/app_export.dart';
  
  
  
  Future<ui.Image> loadNetworkImage(String url) async {
    final completer = Completer<ui.Image>();
    final networkImage = NetworkImage(url);

    networkImage.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );

    return completer.future;
  }