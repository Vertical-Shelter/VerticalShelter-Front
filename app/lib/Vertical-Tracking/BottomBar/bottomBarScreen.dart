import 'package:app/Vertical-Tracking/Gyms/gymsController.dart';
import 'package:app/widgets/bottomBar/bottomBarIcons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app/core/app_export.dart';

import 'bottomBarController.dart';

class VTBottomBarScreen extends GetWidget<VTBottomBarController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
            body: Stack(alignment: Alignment.bottomCenter, children: [
              controller.pages[controller.currentIndex.value],
            ]),
            bottomNavigationBar: Obx(() => BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.black,
                  fixedColor: Colors.black,
                  currentIndex: controller.currentIndex.value,
                  onTap: (index) {
                    controller.changeIndex(index);
                  },
                  iconSize: 30,
                  selectedFontSize: 0,
                  items: [
                    BottomBarItem(
                      title: AppLocalizations.of(context)!.classement,
                      iconName: BlackIconConstant.ranking,
                      activeIconName: BlackIconConstant.ranking,
                    ),
                    BottomBarItem(
                      title: AppLocalizations.of(context)!.stats,
                      iconName: BlackIconConstant.stat,
                      activeIconName: BlackIconConstant.stat,
                    ),
                    BottomBarItem(
                        title: AppLocalizations.of(context)!.salles,
                        iconName: BlackIconConstant.bloc,
                        activeIconName: BlackIconConstant.bloc,
                        hasNotif: Get.find<VTGymController>().hasNotif.value),
                    BottomBarItem(
                      title: AppLocalizations.of(context)!.social,
                      iconName: BlackIconConstant.social,
                      activeIconName: BlackIconConstant.social,
                    ),
                    BottomBarItem(
                      title: AppLocalizations.of(context)!.profil,
                      iconName: BlackIconConstant.profil,
                      activeIconName: BlackIconConstant.profil,
                    ),
                  ],
                ))),
      ),
    );
  }
}
