import 'package:app/Vertical-Tracking/Ranking/rankingFriend/rankingFriendController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/widgets/profil/profilMinivertical.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankingFriendScreen extends GetWidget<RankingFriendController> {
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Stack(children: [
              SmartRefresher(
                  onLoading: () async {
                    await controller.rankingFriend();
                    controller.refreshController.loadComplete();
                  },
                  onRefresh: () async {
                    controller.offset = 0;
                    await controller.rankingFriend();
                    controller.refreshController.refreshCompleted();
                  },
                  footer: const ClassicFooter(
                    loadStyle: LoadStyle.ShowWhenLoading,
                    completeDuration: Duration(milliseconds: 500),
                  ),
                  enablePullUp: true,
                  physics: const BouncingScrollPhysics(),
                  controller: controller.refreshController,
                  child: controller.rankingList.isEmpty
                      ? bodyDontHaveFriend(context)
                      : bodyHaveFriend(context)),
              Positioned(
                bottom: 10,
                child: Container(
                    width: width * 0.89,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Obx(() =>
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          SizedBox(width: 10),
                          Text(controller.me.value.rank.toString() + ". "),
                          SizedBox(width: 10),
                          Expanded(
                              child: ProfileMiniVertical(
                                  id: controller.me.value.id,
                                  baniereImage: controller.me.value.baniereResp,
                                  name: controller.me.value.name,
                                  image: controller.me.value.image)),
                          Text(controller.me.value.score.round().toString()),
                          SizedBox(width: 10)
                        ]))),
              ),
            ]),
    );
  }

  Widget bodyDontHaveFriend(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(Get.context!)!
                .vous_n_avez_pas_d_amis_pour_le_moment,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 10),
          Text(
            AppLocalizations.of(Get.context!)!
                .ajouer_des_amis_pour_pour_montrer_que_vous_etes_le_meilleur,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ]);
  }

  Widget bodyHaveFriend(BuildContext context) {
    return Obx(() => ListView.builder(
        itemCount: controller.rankingList.length,
        itemBuilder: (context, index) {
          UserMinimalResp user = controller.rankingList[index];
          return Padding(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Row(children: [
                Text((index + 1).toString() + ". "),
                const SizedBox(width: 10),
                Expanded(
                    child: InkWell(
                        onTap: () => Get.toNamed(
                            AppRoutesVT.UserProfileScreenRoute,
                            parameters: {"id": user.id}),
                        child: ProfileMiniVertical(
                            baniereImage: user.baniere,
                            id: user.id,
                            name: user.username,
                            image: user.image))),
                Text(controller.rankingList[index].point!.round().toString())
              ]));
        }));
  }
}
