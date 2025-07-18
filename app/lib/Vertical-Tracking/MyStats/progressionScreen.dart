import 'package:app/Vertical-Tracking/MyStats/prgoressionController.dart';
import 'package:app/core/app_export.dart';

class ProgressionScreen extends GetWidget<ProgressionController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: appBarWidget(context),
            body: Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Column(children: [
                  navBarStatHisto(context),
                  body(controller.index.value)
                ])))));
  }

  Widget body(int? index) {
    return Flexible(
        child: Padding(
            padding: getPadding(top: 10, left: 5, right: 5),
            child: controller.pages[index!]));
  }

  Widget navBarStatHisto(BuildContext context) {
    return NavigationBar(
      height: height * 0.048,
      indicatorColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      selectedIndex: controller.index.value,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: [
        NavigationDestination(
            icon: Opacity(
                opacity: 0.5,
                child: Text(AppLocalizations.of(Get.context!)!.statistiques,
                    style: Theme.of(context).textTheme.bodyMedium!)),
            selectedIcon: Text(AppLocalizations.of(Get.context!)!.statistiques,
                style: Theme.of(context).textTheme.bodyMedium!),
            label: AppLocalizations.of(Get.context!)!.statistiques),
        NavigationDestination(
            icon: Opacity(
                opacity: 0.5,
                child: Text(AppLocalizations.of(Get.context!)!.historique,
                    style: Theme.of(context).textTheme.bodyMedium!)),
            selectedIcon: Text(AppLocalizations.of(Get.context!)!.historique,
                style: Theme.of(context).textTheme.bodyMedium!),
            label: AppLocalizations.of(Get.context!)!.historique),
      ],
      onDestinationSelected: (value) => controller.changeNavBar(value),
    );
  }

  PreferredSizeWidget appBarWidget(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: height * 0.1,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(AppLocalizations.of(Get.context!)!.ma_progression,
            style: Theme.of(context).textTheme.labelLarge!));
  }
}
