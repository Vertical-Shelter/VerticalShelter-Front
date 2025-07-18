import 'dart:io';

import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/APIrequest.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/VSL/Api.dart';
import 'package:app/data/models/VSL/GuildReq.dart';
import 'package:app/data/models/VSL/GuildResp.dart';
import 'package:app/data/models/VSL/UserVSLResp.dart';
import 'package:app/utils/VSLController.dart';
import 'package:app/widgets/climbingLocationMinimalist.dart';
import 'package:app/widgets/stripe.dart';
import 'package:app/widgets/textFieldShaker/textFieldShakerController.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

class CreateTeamcontroller extends GetxController {
  // Guild info
  TextEditingController guildName = TextEditingController();
  ShakeTextFieldController guildNameShake = ShakeTextFieldController();
  Rxn<File> image_guild = Rxn<File>();
  bool imageModified = false;
  RxList<ClimbingLocationResp> climbingGymList = <ClimbingLocationResp>[].obs;

  Rxn<ClimbingLocationResp> climbingLocationSelected =
      Rxn<ClimbingLocationResp>();

  //info perso
  TextEditingController lastname = TextEditingController();
  ShakeTextFieldController lastnameShake = ShakeTextFieldController();
  TextEditingController name = TextEditingController();
  ShakeTextFieldController nameShake = ShakeTextFieldController();
  RxnInt age = RxnInt();
  RxBool isMale = false.obs;

  //select role
  RxString selectedRole = "".obs;

  Vslcontroller vsl = Get.find<Vslcontroller>();
  RxInt index = 1.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    climbingGymList.value = vsl.listClimbingLocation;//await climbinglocation_list_by_name("");
    //  guildtext =  ShakeTextField(controller: guildName, hintText: "bou");
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: source, imageQuality: 50);

      if (pickedFile != null) {
        image_guild.value = File(pickedFile.path);
        imageModified = true;
        image_guild.refresh();
      }
    } catch (e) {
      if (e is PlatformException && e.code == 'photo_access_denied') {
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Permission Denied'),
              content: Text(
                  'Please allow access to the photo library in order to pick an image.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void changeState(bool isNext) async {
    if (isNext) {
      if (index.value < 4) {
        index.value++;
      } else {
        await createGuild();
        Get.back();
      }
    } else {
      if (index.value > 1) {
        index.value--;
      } else {
        Get.back();
      }
    }
    index.refresh();
  }

  Future<void> createGuild() async {

    Guildreq guild = Guildreq(
        name: guildName.text,
        climbingLocation_id: climbingLocationSelected.value!.id,
        image_url: image_guild.value!.path);
    try {
      createGuildPost(guild, vsl.vsl.value!.id!).then((value) {
        vsl.listGuild.add(value);
        joinGuildPost(guild_id: value.id!, vsl_id: vsl.vsl.value!.id!);
      });
    } catch (e) {
      print(e);
    }
  }

  bool checkTextfields() {
    bool hasError = false;
    if (index.value == 1) {
      if (guildName.text.isEmpty) {
        guildNameShake.shake();
        hasError = true;
      } else if (image_guild.value!.path ==
              'assets/images/image_not_found.png' ||
          climbingLocationSelected.value == null) {
        hasError = true;
      }
    } else if (index.value == 2) {
      if (name.text.isEmpty) {
        nameShake.shake();
        hasError = true;
      }
      if (lastname.text.isEmpty) {
        lastnameShake.shake();
        hasError = true;
      }
      if (age.value == null) {
        hasError = true;
      }
    } else if (index.value == 3) {
      if (selectedRole.value.isEmpty) {
        return false;
      }
    }
    if (hasError) {
      return false;
    }
    return true;
  }
}
