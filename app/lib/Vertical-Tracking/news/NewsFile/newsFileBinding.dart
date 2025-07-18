import 'package:app/Vertical-Tracking/news/NewsFile/newsFileController.dart';
import 'package:app/core/app_export.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class NewsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsDetailsController>(() => NewsDetailsController());
  }
}