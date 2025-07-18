import 'package:app/Vertical-Tracking/Ranking/RankingController.dart';
import 'package:app/core/app_export.dart';

class RankingScreen extends GetWidget<RankingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(context),
        body: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [navBar(context), FocusBody(controller.index.value)])));
  }

  PreferredSizeWidget appBarWidget(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: height * 0.1,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Text(AppLocalizations.of(context)!.classement,
            style: Theme.of(context).textTheme.labelLarge!));
  }

  Widget FocusBody(int? index) {
    return Expanded(
        child: Padding(
            padding: getPadding(top: 0.029 * height, left: 5, right: 5),
            child: controller.pages[index!]));
  }

  Widget navBar(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.transparent,
      selectedIndex: controller.index.value,
      indicatorColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      height: height * 0.08,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: destination(context),
      onDestinationSelected: (value) => controller.ChangeColumn(value),
    );
  }

  List<Widget> destination(BuildContext context) {
    List<Widget> list_destination = [
      NavigationDestination(
          icon: Text("VSL",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.5))),
          selectedIcon:
              Text("VSL", style: Theme.of(context).textTheme.bodyMedium!),
          label: AppLocalizations.of(context)!.global),
      NavigationDestination(
          icon: Text(AppLocalizations.of(context)!.global,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.5))),
          selectedIcon: Text(AppLocalizations.of(context)!.global,
              style: Theme.of(context).textTheme.bodyMedium!),
          label: AppLocalizations.of(context)!.global),
      NavigationDestination(
          icon: Text(AppLocalizations.of(context)!.par_salles,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.5))),
          selectedIcon: Text(AppLocalizations.of(context)!.par_salles,
              style: Theme.of(context).textTheme.bodyMedium!),
          label: AppLocalizations.of(context)!.par_salles),
      NavigationDestination(
          icon: Text(AppLocalizations.of(context)!.entre_amis,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.5))),
          selectedIcon: Text(AppLocalizations.of(context)!.entre_amis,
              style: Theme.of(context).textTheme.bodyMedium!),
          label: AppLocalizations.of(context)!.amis),
    ];

    if (controller.vsl.is_sign_in.value) {
      list_destination.insert(
          0,
          NavigationDestination(
              icon: Text("VSL",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5))),
              selectedIcon:
                  Text("VSL", style: Theme.of(context).textTheme.bodyMedium!),
              label: AppLocalizations.of(context)!.global));
    }

    return list_destination;
  }
}
