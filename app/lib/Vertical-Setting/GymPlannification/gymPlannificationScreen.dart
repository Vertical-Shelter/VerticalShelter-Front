import 'package:app/Vertical-Setting/GymPlannification/gymPlannificationController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/secteur/secteurWidgetVS.dart';

class GymPlannificationScreen extends GetWidget<GymPlannificationController> {
  RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(AppLocalizations.of(Get.context!)!.roulement,
            style: Theme.of(context).textTheme.labelLarge),
      ),
      body: blocsContaier(),
    );
  }

  Widget blocsContaier() {
    return Obx(() => controller.dateSecteurList.isEmpty
        ? Center(
            child: Text(
            AppLocalizations.of(Get.context!)!.aucun_mur_trouve_pour_ce_secteur,
            style: AppTextStyle.rb30,
            textAlign: TextAlign.center,
          ))
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.separated(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                itemCount: controller.dates.length + 1,
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 20),
                itemBuilder: (context, index) {
                  if (index == controller.dates.length) {
                    return const SizedBox(height: 200);
                  }
                  DateTime? date = controller.dates[index];
                  return SecteurDateCard(
                      secteurList: controller.dateSecteurList[date]!,
                      date: date);
                })));
  }
}
