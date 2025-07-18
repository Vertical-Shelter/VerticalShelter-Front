import 'package:app/Vertical-Setting/GymNews/gymNewsController.dart';
import 'package:app/Vertical-Tracking/news/UserNews/userNewsController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/news/climbingLocationNewSect.dart';
import 'package:app/widgets/news/climbingLocationSoonSect.dart';
import 'package:app/widgets/news/friendAccepted.dart';
import 'package:app/widgets/news/newsComment.dart';
import 'package:app/widgets/news/newsFriend.dart';
import 'package:app/widgets/news/newsTag.dart';
import 'package:app/widgets/news/newsVideo.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClimbingLocationNewsScreen
    extends GetWidget<ClimbingLocationNewsController> {
  @override
  Widget build(BuildContext context) {
    controller.updateLastDate();
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Row(children: [
              BackButtonWidget(
                onPressed: () => Get.back(),
              ),
              Spacer(),
              Text(
                AppLocalizations.of(context)!.actualite_de_vos_grimpeurs,
              ),
              Spacer(),
            ])),
        body: Obx(() => Padding(
            padding: EdgeInsets.all(10),
            child: SmartRefresher(
                onLoading: () async {
                  controller.offset.value += 10;
                  await controller.fetchUserNews();
                  controller.refreshController.loadComplete();
                },
                onRefresh: () async {
                  controller.offset.value = 0;
                  await controller.fetchUserNews();
                  controller.refreshController.refreshCompleted();
                },
                enablePullDown: true,
                footer: const ClassicFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  completeDuration: Duration(milliseconds: 500),
                ),
                enablePullUp: true,
                physics: const BouncingScrollPhysics(),
                controller: controller.refreshController,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String element = controller.dateMap.keys.elementAt(index);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          element,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index2) {
                                if (controller.dateMap[element]![index2]
                                        .climbingLocation_type ==
                                    "COMMENT") {
                                  return NewsComment(
                                      controller.dateMap[element]![index2]);
                                }
                                if (controller.dateMap[element]![index2]
                                        .climbingLocation_type ==
                                    "VIDEO") {
                                  return NewsVideo(
                                      controller.dateMap[element]![index2]);
                                }
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 10,
                                  ),
                              itemCount: controller.dateMap[element]!.length),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: controller.dateMap.keys.length,
                )))));
  }
}
