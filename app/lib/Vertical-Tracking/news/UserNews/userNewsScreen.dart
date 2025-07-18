import 'package:app/Vertical-Tracking/news/UserNews/userNewsController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/news/climbingLocationNewSect.dart';
import 'package:app/widgets/news/climbingLocationSoonSect.dart';
import 'package:app/widgets/news/friendAccepted.dart';
import 'package:app/widgets/news/newsContest.dart';
import 'package:app/widgets/news/newsFriend.dart';
import 'package:app/widgets/news/newsActualites.dart';
import 'package:app/widgets/news/newsTag.dart';
import 'package:app/widgets/newsCards.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserNewsScreen extends GetWidget<UserNewsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            BackButtonWidget(
              onPressed: () => Get.back(),
            ),
            Spacer(),
            Text(AppLocalizations.of(Get.context!)!.notifications),
            Spacer()
          ]),
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
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
                                if (controller
                                        .dateMap[element]![index2].newsType! ==
                                    "Friends") {
                                  if (controller.dateMap[element]![index2]
                                          .friendsType ==
                                      "NEW_FRIEND") {
                                    return NewsAskFriend(
                                        controller.dateMap[element]![index2]);
                                  } else if (controller
                                          .dateMap[element]![index2]
                                          .friendsType! ==
                                      "FRIEND_ACCEPTED") {
                                    return Container(
                                      child: FriendAcceptedWidget(
                                          controller.dateMap[element]![index2]),
                                    );
                                  } else if (controller
                                          .dateMap[element]![index2]
                                          .friendsType! ==
                                      "TAG") {
                                    return NewsTag(
                                        controller.dateMap[element]![index2]);
                                  }
                                }
                                if (controller
                                        .dateMap[element]![index2].newsType! ==
                                    "Gym") {
                                  if (controller.dateMap[element]![index2]
                                          .climbingLocation_type ==
                                      "SOON_SECT") {
                                    return ClimbingLocationSoonSect(controller
                                        .dateMap[element]![index2]
                                        .climbingLocation!);
                                  } else if (controller
                                          .dateMap[element]![index2]
                                          .climbingLocation_type ==
                                      "NEW_SECT")
                                    return ClimbingLocationNewSect(controller
                                        .dateMap[element]![index2]
                                        .climbingLocation!);
                                  else if (controller.dateMap[element]![index2]
                                              .climbingLocation_type ==
                                          "NEWS" &&
                                      controller.dateMap[element]![index2]
                                              .news_id !=
                                          null) {
                                    return NewsActualites(
                                        controller.dateMap[element]![index2]);
                                  } else if (controller
                                              .dateMap[element]![index2]
                                              .climbingLocation_type ==
                                          "CONTEST" &&
                                      controller.dateMap[element]![index2]
                                              .contest_id !=
                                          null) {
                                    return NewsContest(
                                        controller.dateMap[element]![index2]);
                                  }
                                }
                                return Container(
                                  child: Text('QW'),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 20,
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
