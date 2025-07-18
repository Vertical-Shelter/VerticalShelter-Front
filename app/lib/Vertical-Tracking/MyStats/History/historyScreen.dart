import 'package:app/widgets/colorFilter/colorsFilterWidget.dart';
import 'package:app/widgets/statsWidget/statsWidgetGym.dart';
import 'package:app/widgets/walls/wallHistoryWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:app/Vertical-Tracking/MyStats/History/historyController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/reloadButton.dart';

class VTHistoryScreen extends GetWidget<VTHistoryController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
          Container(
              margin: EdgeInsets.only(top: 10),
              height: height * 0.08,
              alignment: Alignment.topLeft,
              child: Obx(() => ListView.separated(
                  itemCount: controller.gymLists.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
                      ),
                  itemBuilder: (context, index) {
                    String tapedGym = controller.gymLists[index].id;

                    return Obx(() => tapedGym == controller.currentGymId.value
                        ? StatsWidgetGym(
                            onTap: () {
                              controller.currentGymId.value = "";
                              controller.getHistory(null);
                              controller.colorFilterController.value = null;
                              controller.colorFilterController.refresh();
                            },
                            climbingLocationMinimalResp:
                                controller.gymLists[index],
                            isActive: true)
                        : StatsWidgetGym(
                            onTap: () {
                              controller.changeCurrentGym(tapedGym);
                            },
                            climbingLocationMinimalResp:
                                controller.gymLists[index]));
                  }))),
          Obx(() => controller.colorFilterController.value == null
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: ColorFilterWidget(
                      controller.colorFilterController.value!))),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Body(controller, context)))
        ]));
  }
}

Widget Body(VTHistoryController controller, BuildContext context) {
  return Obx(() => controller.isLoading.value == true
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : controller.hasError.value == true
          ? Center(child: ReloadButtonWidget(
              onPressed: () {
                controller.getHistory(null);
              },
            ))
          : controller.stats.obj!.keys.length > 0
              ? SmartRefresher(
                  onLoading: () async {
                    if (controller.currentGymId.value == "") {
                      if (controller.offsetMap["global"] == null) {
                        controller.offsetMap["global"] = 0;
                      } else {
                        controller.offsetMap["global"] =
                            controller.offsetMap["global"]! + 10;
                      }
                      await controller.getHistory(null);
                    } else {
                      if (controller.offsetMap[controller.currentGymId.value] ==
                          null) {
                        controller.offsetMap[controller.currentGymId.value] = 0;
                      } else {
                        controller.offsetMap[controller.currentGymId.value] =
                            controller
                                    .offsetMap[controller.currentGymId.value]! +
                                10;
                      }
                      await controller
                          .getHistory(controller.currentGymId.value);
                    }

                    controller.refreshController.loadComplete();
                  },
                  enablePullDown: false,
                  footer: const ClassicFooter(
                    loadStyle: LoadStyle.ShowWhenLoading,
                    completeDuration: Duration(milliseconds: 500),
                  ),
                  enablePullUp: true,
                  physics: const BouncingScrollPhysics(),
                  controller: controller.refreshController,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: height * 0.01,
                    ),
                    itemCount: controller.stats.obj!.keys.length,
                    itemBuilder: (context, index) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.stats.obj!.keys.elementAt(index),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Flexible(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller.stats.obj!.values
                                        .elementAt(index)
                                        .length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                    itemBuilder: (context, index2) {
                                      return WallHistoryWidget(
                                        controller.stats.obj!.values
                                            .elementAt(index)[index2]
                                            .wall!,
                                      );
                                    }))
                          ]);
                    },
                  ),
                )
              : Center(
                  child: Text(
                  AppLocalizations.of(context)!.vous_n_avez_pas_encore_valide_de_bloc,
                  style: AppTextStyle.rr14,
                  textAlign: TextAlign.center,
                )));
}
