import 'dart:io';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/core/app_export.dart';
import 'package:app/core/utils/max_utils.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/user_req.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/Vertical-Tracking/profil/profil_controller.dart';

class VTEditProfilController extends GetxController {
  Rxn<UserResp> userResp = Rxn<UserResp>();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String? usernameValidatorMessage = null;
  String? descriptionValidatorMessage = null;

  RxBool is_loading = false.obs;
  RxBool isTyping = false.obs;

  Rxn<File> profile_image = Rxn<File>();
  bool imageModified = false;

  RxString username = ''.obs;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  _init() async {
    userResp = Get.arguments['userResp'];
    if (userResp.value != null && userResp.value!.profileImage != null) {
      profile_image.value =
          await downloadFileTemporarily(userResp.value!.profileImage!);
    }
  }

  Future<bool> editProfile() async {
    VTProfilController profilController = Get.find<VTProfilController>();
    profilController.is_loading_top.value = true;
    try {
      UserReq profilReq = UserReq(
          username:
              usernameController.text != '' ? usernameController.text : null,
          description: descriptionController.text != ''
              ? descriptionController.text
              : null,
          profileImage: imageModified ? profile_image.value : null);
      if (profilReq.username == null &&
          profilReq.description == null &&
          !imageModified) {
        profilController.is_loading_top.value = false;
        return true;
      }
      Account user = Get.find<MultiAccountManagement>().actifAccount!;
      userResp.value = await user_put(profilReq);
      profilController.userResp.value = userResp.value;
      profilController.is_loading_top.value = false;
      // Get.find<PrefUtils>().setUser(userResp!);
      user.name = userResp.value!.username!;
      user.picture = userResp.value!.profileImage!;
      return true;
    } on UserResp catch (e) {
      debugPrint(e.toString());
      usernameValidatorMessage = e.error!['username'][0];
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> onPressedSave() async {
    is_loading.value = true;

    if (await editProfile()) Get.back();
    is_loading.value = false;
    return;
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      profile_image.value = File(pickedFile.path);
      imageModified = true;
      profile_image.refresh();
    }
  }

// Save the image to a temporary directory
  Future<File> downloadFileTemporarily(String url) async {
    final directory = await getTemporaryDirectory();
    final tempPath = directory.path;
    final fileName = 'temp_file';
    final tempFile = File('$tempPath/$fileName');

    final response = await http.get(Uri.parse(url));
    await tempFile.writeAsBytes(response.bodyBytes);

    return tempFile;
  }

  String? descriptionValidator(dynamic value) {
    if (descriptionController.text.length >= 150) return 'Too long';
    return null;
  }

  String? usernameValidator(dynamic value) {
    if (usernameController.text.length >= 20) return 'Too long';

    return usernameValidatorMessage != null
        ? autoLineFeed(usernameValidatorMessage, 35)
        : null;
  }

  onTapBackButton() {
    Get.back();
  }
}
