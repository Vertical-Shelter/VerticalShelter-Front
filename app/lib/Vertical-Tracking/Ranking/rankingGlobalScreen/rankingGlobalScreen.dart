import 'package:app/Vertical-Tracking/Ranking/rankingGlobalScreen/rankingGlobalController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/widgets/profil/profilMinivertical.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankingGlobalScreen extends GetWidget<RankingGlobalController> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SmartRefresher(
              onLoading: () async {
                controller.offset += 100;
                await controller.rankingGlobal();
                controller.refreshController.loadComplete();
              },
              onRefresh: () async {
                await controller.refresh();
                controller.refreshController.refreshCompleted();
              },
              footer: const ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                completeDuration: Duration(milliseconds: 500),
              ),
              enablePullUp: true,
              physics: const BouncingScrollPhysics(),
              controller: controller.refreshController,
              child: ListView.builder(
                  itemCount: controller.rankingList.length,
                  itemBuilder: (context, index) {
                    UserMinimalResp user = controller.rankingList[index];
                    return Padding(
                        padding:
                            const EdgeInsets.only(top: 10, right: 10, left: 10),
                        child: Row(children: [
                          Text((index + 1).toString() + ". "),
                          Expanded(
                              child: InkWell(
                                  onTap: () => Get.toNamed(
                                      AppRoutesVT.UserProfileScreenRoute,
                                      parameters: {"id": user.id}),
                                  child: ProfileMiniVertical(
                                      id: user.id,
                                      baniereImage: user.baniere,
                                      name: user.username,
                                      image: user.image))),
                          Text(controller.rankingList[index].point!
                              .round()
                              .toString())
                        ]));
                  }))),
      Positioned(
        bottom: 10,
        child: Container(
            width: width * 0.89,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Obx(() => Row(mainAxisSize: MainAxisSize.min, children: [
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
      // Obx(() => controller.hasMembership.value == false
      //     ? Positioned(
      //         top: 0,
      //         left: 0,
      //         child: ClipRRect(
      //             borderRadius: BorderRadius.only(
      //                 bottomLeft: Radius.circular(30),
      //                 bottomRight: Radius.circular(30)),
      //             child: BackdropFilter(
      //               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      //               child: Container(
      //                 height: context.height,
      //                 width: context.width,
      //                 color: ColorsConstantDarkTheme.neutral_white.withOpacity(0.2),
      //               ),
      //             )))
      //     : SizedBox(height: 0, width: 0)),
      // Obx(() => controller.hasMembership.value == false
      //     ? Positioned(
      //         top: context.height * 0.05,
      //         child: Container(
      //           decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(20),
      //               color: ColorsConstantDarkTheme.neutral_white,
      //               boxShadow: [
      //                 BoxShadow(
      //                     color: Colors.black.withOpacity(0.2),
      //                     offset: const Offset(0, 2),
      //                     blurRadius: 10)
      //               ]),
      //           height: context.height * 0.3,
      //           width: context.width * 0.9,
      //           child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Text("Classement global",
      //                     style: AppTextStyle.rmResizable(20)),
      //                 const SizedBox(height: 20),
      //                 Text(
      //                   "Pour débloquer le classement global, passez à la version ++",
      //                   style: AppTextStyle.rrResizable(14),
      //                   textAlign: TextAlign.center,
      //                 ),
      //                 const SizedBox(height: 20),
      //                 InkWell(
      //                     onTap: () => {controller.onTapPayement(context)},
      //                     child: Container(
      //                         padding: const EdgeInsets.all(10),
      //                         decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(20),
      //                             color: ColorsConstant.redAction),
      //                         child: Text("Passer à la version ++",
      //                             style: AppTextStyle.rmResizable(14))))
      //               ]),
      //         ),
      //       )
      //     : SizedBox(height: 0, width: 0))
    ]);
  }
}
