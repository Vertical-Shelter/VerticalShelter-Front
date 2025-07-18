import 'package:app/core/app_export.dart';
import 'package:app/data/apiClient/api_client.dart';
import 'package:app/data/prefs/multi_account_management.dart';

class InitialBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync<PrefUtils>(() => PrefUtils().init(), permanent: true);
    await Get.putAsync<MultiAccountManagement>(
        () => MultiAccountManagement().init(),
        permanent: true);

    Get.put(ApiClient());
    Connectivity connectivity = Connectivity();
    Get.put(NetworkInfo(connectivity));
  }
}
