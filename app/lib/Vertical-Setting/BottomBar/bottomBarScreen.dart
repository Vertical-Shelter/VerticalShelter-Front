import 'package:app/core/app_export.dart';
import 'package:app/widgets/bottomBar/bottomBarIcons.dart';
import 'bottomBarController.dart';

class VSBottomBarScreen extends GetWidget<VSBottomBarController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
            child: Scaffold(
          body: controller.pages[controller.currentIndex.value],
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Obx(() => BottomNavigationBar(
                iconSize: 50,
                elevation: 0,
                backgroundColor: Colors.black,
                fixedColor: Colors.black,
                selectedFontSize: 0,
                currentIndex: controller.currentIndex.value,
                onTap: (index) {
                  controller.changeIndex(index);
                },
                items: [
                  BottomBarItem(
                      title: AppLocalizations.of(context)!.roulement,
                      iconName: BlackIconConstant.historique,
                      activeIconName: BlackIconConstant.historique),
                  BottomBarItem(
                      title: AppLocalizations.of(context)!.home,
                      activeIconName: BlackIconConstant.stat,
                      iconName: BlackIconConstant.stat),
                  BottomBarItem(
                      title: "contest",
                      activeIconName: BlackIconConstant.contest,
                      iconName: BlackIconConstant.contest),
                ],
              )),
        )));
  }
}
