import 'package:app/data/prefs/multi_account_management.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Map<String, String> MyAuthToken() {
  Account? account = Get.find<MultiAccountManagement>().actifAccount;
  String token = account!.Token;
  return {'Authorization': 'Bearer ${token}'};
}
