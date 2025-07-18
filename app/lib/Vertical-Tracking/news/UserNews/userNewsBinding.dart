import 'package:app/Vertical-Tracking/news/UserNews/userNewsController.dart';
import 'package:app/core/app_export.dart';

class UserNewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserNewsController>(() => UserNewsController());
  }
}