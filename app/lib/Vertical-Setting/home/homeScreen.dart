import 'dart:io';

import 'package:app/Vertical-Setting/home/homeController.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/Vertical-Tracking/Gyms/gymsController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/utils/languageCode.dart';
import 'package:app/widgets/climbingLocationMinimalist.dart';
import 'package:app/widgets/disconnectDialog.dart';
import 'package:app/widgets/floatingButtonWidget.dart';
import 'package:app/widgets/menuButton.dart';
import 'package:app/widgets/settingmenu.dart';
import 'package:app/widgets/tabBarWidget.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class VVSHomeScreen extends GetWidget<VSHomeController> {
  List<WallResp> selectedItem = [];
  bool isMultiSelectionEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.is_done_loading_CLoc.value == false
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Obx(() => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: _AppBarWidget(context),
              resizeToAvoidBottomInset: false,
              floatingActionButton: floatingButtonWidget(
                count: 0,
                creationImage: controller.creationImage,
                creationState: controller.creationState,
                children: [
                  SpeedDialChild(
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: AppLocalizations.of(context)!.nouveau_secteur,
                    onTap: controller.onTapCreate,
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.brush),
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: AppLocalizations.of(context)!.modifier_secteur,
                    onTap: controller.onTapEdit,
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.calendar_month),
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label:
                        AppLocalizations.of(context)!.mes_prochaines_ouvertures,
                    onTap: () => controller.showPopupGymMap(context),
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.add_box),
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: AppLocalizations.of(context)!.modifier +
                        AppLocalizations.of(context)!.les_spraywalls,
                    onTap: () => Get.toNamed(AppRoutesVS.createSprayWallScreen),
                  ),
                ],
              ),
              body: controller.header[Get.find<PrefUtils>().getLocal()]
                  [controller.actualTab.value],
            )));
  }

  PreferredSizeWidget? _AppBarWidget(BuildContext context) {
    List<SettingMenuElement> settingMenu = [
      SettingMenuElement(
          icon: const Icon(Icons.language),
          text: AppLocalizations.of(Get.context!)!.language, //Changer de langue
          onPressed: OnChangeLanguageTap),
      SettingMenuElement(
          icon: Icon(Icons.change_circle),
          text: AppLocalizations.of(Get.context!)!.changer_de_compte,
          onPressed: controller.OnChangeAccountTap),
      SettingMenuElement(
          icon: Icon(Icons.logout_rounded),
          text: AppLocalizations.of(Get.context!)!.deconnexion,
          onPressed: (value) {
            showDialog(
                context: value, builder: (context) => DisconnectDialog());
          }),
    ];
    return PreferredSize(
        // You can set the size here, but it's left to zeros in order to expand based on its child.
        preferredSize: Size(width, 100),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(children: [
              Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                        child: ClimbingLocationMinimalistWidget(
                      context,
                      controller
                          .climbingLocationController.climbingLocationResp!,
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Obx(() => Stack(alignment: Alignment.center, children: [
                          InkWell(
                            child:
                                Theme.of(context).brightness == Brightness.dark
                                    ? SvgPicture.asset(
                                        BlackIconConstant.notification,
                                        height: 25,
                                      )
                                    : SvgPicture.asset(
                                        BlackIconConstant.notification,
                                        height: 25,
                                      ),
                            onTap: () => controller.onTapNotif(),
                          ),
                          controller.hasNotif.value == true
                              ? Positioned(
                                  right: 10,
                                  top: 10,
                                  child: CircleAvatar(
                                    radius: 5,
                                    backgroundColor: Colors.red,
                                  ),
                                )
                              : Container()
                        ])),
                    MenuButtonWidget(
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) =>
                                SettingMenuWidget(elements: settingMenu));
                      },
                    )
                  ]),
              Obx(() => Flexible(
                      child: TabBarWidget(
                    index: controller.actualTab.value,
                    tabNames: controller
                        .header[Get.find<PrefUtils>().getLocal()].keys
                        .map((e) {
                      return {"name": e, "status": "inactive"};
                    }).toList(),
                    onTap: controller.onChandeColumnIndex,
                  )))
            ])));
    //  ])));
  }
}
