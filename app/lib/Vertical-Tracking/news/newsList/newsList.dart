import 'package:app/Vertical-Tracking/news/newsList/newsController.dart';
import 'package:app/core/app_export.dart';

class NewsListScreen extends GetWidget<NewsListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(AppLocalizations.of(Get.context!)!.les_actualites,
              style: Theme.of(context).textTheme.bodyMedium),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(children: [
          Obx((() => navBar(context))),
          Obx(
            () => FocusBody(controller.index.value),
          )
        ]));
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
      destinations: [
        NavigationDestination(
            icon: Text(AppLocalizations.of(context)!.par_salles,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5))),
            selectedIcon: Text(AppLocalizations.of(context)!.par_salles,
                style: Theme.of(context).textTheme.bodyMedium!),
            label: AppLocalizations.of(Get.context!)!.salles),
        NavigationDestination(
            icon: Text("Vertical Shelter",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5))),
            selectedIcon: Text("Vertical Shelter",
                style: Theme.of(context).textTheme.bodyMedium!),
            label: "VS"),
      ],
      onDestinationSelected: (value) => controller.changeColumn(value),
    );
  }
}
