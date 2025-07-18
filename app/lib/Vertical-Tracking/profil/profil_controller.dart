import 'dart:io';
import 'dart:ui' as ui;

import 'package:app/core/app_export.dart';
import 'package:app/core/constants/colorConstant.dart';
import 'package:app/data/models/SeasonPass/QuestResp.dart';
import 'package:app/data/models/SeasonPass/UserQuestResp.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/projet/api.dart';
import 'package:app/data/models/User/projet/projetResp.dart';
import 'package:app/data/models/User/skills_resp.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/data/models/gamingObject/baniereResp.dart';
import 'package:app/data/models/gamingObject/gamingObjectApi.dart';
import 'package:app/data/models/video/api.dart';
import 'package:app/data/models/video/videoResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/utils/languageCode.dart';
import 'package:app/utils/projectController.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/disconnectDialog.dart';
import 'package:app/widgets/profil/profilMiniAccount.dart';
import 'package:app/widgets/settingmenu.dart';
import 'package:app/widgets/supprimerCompte.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class VTProfilController extends GetxController {
  RxBool is_loading_top = true.obs;
  RxBool isInit = false.obs;

  Rxn<UserResp> userResp = Rxn<UserResp>();
  // RxList<SkillResp> skillList = <SkillResp>[].obs;
  RxList<BaniereResp> baniereList = <BaniereResp>[].obs;

  CacheManager cacheManager = DefaultCacheManager();
  final RefreshController refreshController = RefreshController(
      initialRefresh: false, initialLoadStatus: LoadStatus.idle);
  RxList<VideoResp> videoList = <VideoResp>[].obs;

  ProjetController projectController = Get.find<ProjetController>();

  @override
  void onReady() async {
    // await get_userprofile();

    super.onReady();
  }

  Future<void> onTapQrCode(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: ColorsConstantLightTheme.background,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage("assets/images/VS-Outside-Black.png"),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              ColorsConstantLightTheme.background
                                  .withOpacity(0.85),
                              BlendMode.lighten))),
                  height: 300,
                  width: 300,
                  child: Column(children: [
                    Expanded(
                        child: SvgPicture.network(
                      userResp.value!.qrCodeUrl!,
                      height: 250,
                    )),
                    Container(
                        margin: EdgeInsets.all(10),
                        child: ButtonWidget(
                            onPressed: () => scanQR(),
                            child: Text(
                              AppLocalizations.of(Get.context!)!.scan_qr_code,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                            )))
                  ])));
        });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      String quest = await scanQRCode(barcodeScanRes);
      if (quest == "QR CODE INVALIDE") {
        Get.snackbar(AppLocalizations.of(Get.context!)!.qr_code_invalide,
            AppLocalizations.of(Get.context!)!.qr_code_deja_scanner);
        return;
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
  }

  void onTapTrophy(BuildContext context) {
    Get.toNamed(AppRoutesVT.badgeScreen);
  }

  void onTapBaniere(BuildContext context) {
    Get.toNamed(AppRoutesVT.baniereScreenRoute);
  }

  void onTapAvatar(BuildContext context) {
    Get.toNamed(AppRoutesVT.avatarScreenRoute);
  }

  Future<void> get_userprofile() async {
    try {
      userResp.value = await user_me();
      userResp.refresh();
      videoList.value = await get_my_videos();
      videoList.refresh();
      is_loading_top.value = false;
      is_loading_top.refresh();
      // get_gyms();
    } catch (e) {
      rethrow;
    }
  }

  void getMyBanieres() async {
    baniereList.value = await getMyBanieresAPI();
    baniereList.refresh();
  }

  OnTapMenuButton(BuildContext context) {
    List<SettingMenuElement> settingMenu = [
      SettingMenuElement(
          icon: const Icon(Icons.language),
          text: AppLocalizations.of(Get.context!)!.language, //Changer de langue
          onPressed: OnChangeLanguageTap),
      SettingMenuElement(
          icon: Icon(Icons.card_membership),
          text: AppLocalizations.of(Get.context!)!.contactez_nous,
          onPressed: onContacUsTap),
      SettingMenuElement(
          icon: Icon(Icons.edit),
          text: AppLocalizations.of(Get.context!)!.modifier_profil,
          onPressed: onUpdateProfilTap),
      SettingMenuElement(
          icon: Icon(Icons.change_circle),
          text: AppLocalizations.of(Get.context!)!.changer_de_compte,
          onPressed: OnChangeAccountTap),
      SettingMenuElement(
          icon: Icon(Icons.logout),
          text: AppLocalizations.of(Get.context!)!.deconnexion,
          onPressed: onDisconnectTap),
      SettingMenuElement(
          icon: Icon(Icons.delete),
          text: AppLocalizations.of(Get.context!)!.supprimer_compte,
          onPressed: onDeleteAccountTap),
    ];
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => SettingMenuWidget(elements: settingMenu));
  }
}

//SETTING MENU
// OnMemberShipTap(BuildContext context) {
//   if (Platform.isAndroid) {
//     launchUrl(Uri.parse('https://play.google.com/store/account/subscriptions'));
//   } else if (Platform.isIOS) {
//     launchUrl(Uri.parse('https://apps.apple.com/account/subscriptions'));
//   }
// }

onContacUsTap(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) => Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Theme.of(context).colorScheme.surface,
          ),
          padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
          child: Scaffold(
              primary: false,
              backgroundColor: Colors.transparent,
              body: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: 8,
                  width: width * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                SizedBox(height: 10),
                Text(AppLocalizations.of(context)!.contactez_nous,
                    style: Theme.of(context).textTheme.bodyMedium!),
                SizedBox(height: 20),
                Row(children: [
                  IconButton(
                      icon: Icon(
                        Icons.mail,
                        size: 20,
                      ),
                      onPressed: () {
                        final Uri mailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'contact@verticalshelter.fr');
                        launchUrl(mailLaunchUri);
                      }),
                  TextButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 0))),
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(
                            text: 'contact@verticalshelter.fr'));
                        HapticFeedback.vibrate();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 1),
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            margin: EdgeInsets.only(
                                bottom: 20, left: 20, right: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            behavior: SnackBarBehavior.floating,
                            content: Text(AppLocalizations.of(context)!
                                .adresse_copie_dans_le_presse_papier)));
                      },
                      onPressed: () {
                        final Uri mailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'contact@verticalshelter.fr');
                        launchUrl(mailLaunchUri);
                      },
                      child: Text('contact@verticalshelter.fr',
                          style: Theme.of(context).textTheme.bodyMedium!)),
                  //Button to copy adress
                ]),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  IconButton(
                      icon: Icon(FontAwesomeIcons.whatsapp, size: 20),
                      onPressed: () async {
                        var contact = "+XXXXX";
                        var androidUrl = "whatsapp://send?phone=$contact&text=";
                        var iosUrl = "https://wa.me/$contact?text=";

                        try {
                          if (Platform.isIOS) {
                            await launchUrl(Uri.parse(iosUrl));
                          } else {
                            await launchUrl(Uri.parse(androidUrl));
                          }
                        } on Exception {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              margin: EdgeInsets.only(
                                  bottom: 20, left: 20, right: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              behavior: SnackBarBehavior.floating,
                              content: Text(AppLocalizations.of(context)!
                                  .whatsapp_non_disponible)));
                        }
                      }),
                  TextButton(
                    style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 0))),
                    child: Text('+33 6 51 96 02 56',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium!),
                    onLongPress: () {
                      print('long press');
                      Clipboard.setData(
                          ClipboardData(text: '+33 6 51 96 02 56'));
                      HapticFeedback.vibrate();
                      SystemSound.play(SystemSoundType.click);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          margin:
                              EdgeInsets.only(bottom: 20, left: 20, right: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          behavior: SnackBarBehavior.floating,
                          content: Text(AppLocalizations.of(context)!
                              .numero_copie_dans_le_presse_papier)));
                    },
                    onPressed: () async {
                      var contact = "+33651960256";
                      var androidUrl = "whatsapp://send?phone=$contact&text=";
                      var iosUrl = "https://wa.me/$contact?text=";

                      try {
                        if (Platform.isIOS) {
                          await launchUrl(Uri.parse(iosUrl));
                        } else {
                          await launchUrl(Uri.parse(androidUrl));
                        }
                      } on Exception {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 1),
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            margin: EdgeInsets.only(
                                bottom: 20, left: 20, right: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            behavior: SnackBarBehavior.floating,
                            content: Text(AppLocalizations.of(context)!
                                .whatsapp_non_disponible)));
                      }
                    },
                  ),
                  //Button to copy phone number
                ]),
                SizedBox(height: 10),
                Row(children: [
                  //Button to copy phone number
                  IconButton(
                      icon: Icon(FontAwesomeIcons.instagram, size: 20),
                      onPressed: () async {
                        var nativeUrl =
                            "instagram://user?username=verticalshelter";
                        var webUrl =
                            "https://www.instagram.com/verticalshelter";

                        try {
                          await launchUrlString(nativeUrl,
                              mode: LaunchMode.externalApplication);
                        } catch (e) {
                          print(e);
                          await launchUrlString(webUrl,
                              mode: LaunchMode.platformDefault);
                        }
                      }),
                  TextButton(
                    style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 0))),
                    child: Text(
                        AppLocalizations.of(context)!
                            .rejoingez_la_team_VS_sur_instagram,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium!),
                    onPressed: () async {
                      var nativeUrl =
                          "instagram://user?username=verticalshelter";
                      var webUrl = "https://www.instagram.com/verticalshelter";

                      try {
                        await launchUrlString(nativeUrl,
                            mode: LaunchMode.externalApplication);
                      } catch (e) {
                        print(e);
                        await launchUrlString(webUrl,
                            mode: LaunchMode.platformDefault);
                      }
                    },
                  ),
                ]),
                SizedBox(height: 10),
              ]))));
}

OnChangeAccountTap(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) => Container(
          padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
          child: Column(children: [
            Container(
              height: 8,
              width: width * 0.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.onSurface),
            ),
            SizedBox(height: 20),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                Account account =
                    Get.find<MultiAccountManagement>().accounts[index];

                if (account.id ==
                    Get.find<MultiAccountManagement>().actifAccount!.id) {
                  return Padding(
                      padding: EdgeInsets.only(bottom: height * 0.01),
                      child: ProfileMiniAccount(
                        isGym: account.isGym,
                        id: account.id,
                        name: account.name,
                        image: account.picture,
                        onTap: () => Get.back(),
                        trailing: Icon(
                          Icons.adjust_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ));
                }
                return Padding(
                    padding: EdgeInsets.only(bottom: height * 0.01),
                    child: ProfileMiniAccount(
                      id: account.id,
                      isGym: account.isGym,
                      name: account.name,
                      image: account.picture,
                      onTap: () {
                        Get.find<MultiAccountManagement>()
                            .setActifAccount(account.id);
                        if (account.isGym)
                          Get.offAllNamed(AppRoutesVS.MainPage);
                        else
                          Get.offAllNamed(AppRoutesVT.MainPage);
                      },
                      trailing: Icon(Icons.circle_outlined,
                          color: Theme.of(context).colorScheme.primary),
                    ));
              },
              itemCount: Get.find<MultiAccountManagement>().accounts.length,
            )),
            TextButton(
                onPressed: () {
                  Get.toNamed(GeneralAppRoutes.VTLogInScreenRoute);
                },
                child: Text(AppLocalizations.of(context)!.ajouter_un_compte,
                    style: Theme.of(context).textTheme.bodyMedium!))
          ])));
}

onfriendTap(BuildContext context) {
  Get.toNamed(AppRoutesVT.FriendListScreenRoute);
}

onParametreTap(BuildContext context) {
  Get.toNamed(AppRoutesVT.SettingScreenRoute);
}

onDeleteAccountTap(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteAccountDialog();
      });
}

onUpdateProfilTap(BuildContext context) {
  Get.toNamed(AppRoutesVT.EditProfileScreenRoute,
      arguments: {'userResp': Get.find<VTProfilController>().userResp});
}

onDisconnectTap(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return DisconnectDialog();
      });
}
