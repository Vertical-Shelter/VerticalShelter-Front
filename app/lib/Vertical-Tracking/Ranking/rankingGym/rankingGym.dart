import 'dart:ui';

import 'package:app/Vertical-Tracking/Ranking/rankingGym/rankingGymController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/widgets/profil/profilMinivertical.dart';
import 'package:app/widgets/statsWidget/statsWidgetGym.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankingGymScreen extends GetWidget<RankingGymController> {
  @override
  Widget build(BuildContext context) {
    // controller.refreshPaiementStatus();
    return Obx(() => controller.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : Stack(alignment: Alignment.center, children: [
            Obx(() => controller.gymLists.isEmpty
                ? SmartRefresher(
                    onLoading: () async {
                      await controller.init();

                      controller.refreshController.loadComplete();
                    },
                    onRefresh: () async {
                      await controller.init();

                      controller.refreshController.refreshCompleted();
                    },
                    footer: const ClassicFooter(
                      loadStyle: LoadStyle.ShowWhenLoading,
                      completeDuration: Duration(milliseconds: 500),
                    ),
                    enablePullUp: true,
                    physics: const BouncingScrollPhysics(),
                    controller: controller.refreshController,
                    child: Center(
                        child: Text(
                      AppLocalizations.of(Get.context!)!
                              .valider_au_moins_un_blos_pour_acceder_au_classement +
                          " !",
                      style: AppTextStyle.rr14,
                      textAlign: TextAlign.center,
                    )))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        LimitedBox(
                            maxHeight: height * 0.08,
                            child: Obx(() => ListView.separated(
                                itemCount: controller.gymLists.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      width: 10,
                                    ),
                                itemBuilder: (context, index) {
                                  String tapedGym =
                                      controller.gymLists[index].id;

                                  return Obx(() =>
                                      tapedGym == controller.currentGymId.value
                                          ? StatsWidgetGym(
                                              onTap: () {
                                                controller
                                                    .changeCurrentGym(tapedGym);
                                              },
                                              climbingLocationMinimalResp:
                                                  controller.gymLists[index],
                                              isActive: true)
                                          : StatsWidgetGym(
                                              onTap: () {
                                                controller
                                                    .changeCurrentGym(tapedGym);
                                              },
                                              climbingLocationMinimalResp:
                                                  controller.gymLists[index]));
                                }))),
                        Expanded(
                            child: SmartRefresher(
                                onLoading: () async {
                                  controller.offset += 10;
                                  await controller.rankingGym(
                                      controller.currentGymId.value);

                                  controller.refreshController.loadComplete();
                                },
                                onRefresh: () async {
                                  controller.offset = 0;
                                  await controller.rankingGym(
                                      controller.currentGymId.value);
                                  controller.refreshController
                                      .refreshCompleted();
                                },
                                footer: const ClassicFooter(
                                  loadStyle: LoadStyle.ShowWhenLoading,
                                  completeDuration: Duration(milliseconds: 500),
                                ),
                                enablePullUp: true,
                                physics: const BouncingScrollPhysics(),
                                controller: controller.refreshController,
                                child: ListView.builder(
                                    itemCount: controller
                                        .rankingList[
                                            controller.currentGymId.value]!
                                        .length,
                                    itemBuilder: (context, index) {
                                      UserMinimalResp user =
                                          controller.rankingList[controller
                                              .currentGymId.value]![index];
                                      return Padding(
                                          padding: getPadding(
                                              top: 10, right: 10, left: 10),
                                          child: Row(children: [
                                            Text((index + 1).toString() + ". "),
                                            const SizedBox(width: 10),
                                            Expanded(
                                                child: InkWell(
                                                    onTap: () => Get.toNamed(
                                                            AppRoutesVT
                                                                .UserProfileScreenRoute,
                                                            parameters: {
                                                              "id": user.id
                                                            }),
                                                    child: ProfileMiniVertical(
                                                        baniereImage:
                                                            user.baniere,
                                                        id: user.id,
                                                        name: user.username,
                                                        image: user.image))),
                                            Text(controller
                                                .rankingList[controller
                                                    .currentGymId.value]![index]
                                                .point!
                                                .round()
                                                .toString())
                                          ]));
                                    }))),
                      ])),
            Positioned(
              bottom: 10,
              child: Container(
                  width: width * 0.89,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child:
                      Obx(() => Row(mainAxisSize: MainAxisSize.min, children: [
                            SizedBox(width: 10),
                            Text(controller.me.value.rank.toString() + ". "),
                            SizedBox(width: 10),
                            Expanded(
                                child: ProfileMiniVertical(
                                    baniereImage:
                                        controller.me.value.baniereResp,
                                    id: controller.me.value.id,
                                    name: controller.me.value.name,
                                    image: controller.me.value.image)),
                            Text(controller.me.value.score.round().toString()),
                            SizedBox(width: 10)
                          ]))),
            ),
          ]));
  }
}
