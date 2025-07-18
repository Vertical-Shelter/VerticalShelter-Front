import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class VideoDownloader {
  var dio = Dio();

  Future<String> downloadAndSaveVideo(String url) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = appDocDir.path + '/video.mp4';
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + "%");
          }
        },
      );
      return savePath;
    } catch (e) {
      print(e);
      return "Error";
    }
  }
}
