import 'dart:io';

import 'package:app/Vertical-Tracking/BottomBar/bottomBarController.dart';
import 'package:app/Vertical-Tracking/Ranking/rankingFriend/rankingFriendScreen.dart';
import 'package:app/Vertical-Tracking/Ranking/rankingGlobalScreen/rankingGlobalScreen.dart';
import 'package:app/Vertical-Tracking/Ranking/rankingGym/rankingGym.dart';
import 'package:app/Vertical-Tracking/Ranking/rankingVSL/rankingVSLScreen.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/userApi.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/friendrequest/friendrequest_resp.dart';
import 'package:app/utils/VSLController.dart';
import 'package:app/widgets/profil/profilMinivertical.dart';

class RankingController extends GetxController {
  Vslcontroller vsl = Get.find<Vslcontroller>();

  RxInt index = 0.obs;
  List<Widget> pages = [
    RankingVSLScreen(),
    RankingGlobalScreen(),
    RankingGymScreen(),
    RankingFriendScreen()
  ];

  @override
  void onInit() async {
    super.onInit();
  }

  void ChangeColumn(int value) async {
    index.value = value;
    index.refresh();
  }

  // void onTapNotif(BuildContext context) async {
  //   Get.find<VTBottomBarController>().has_social_notif.value = false;
  //   Get.find<VTBottomBarController>().has_social_notif.refresh();
  //   showModalBottomSheet(
  //       context: context,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //       builder: (context) => StatefulBuilder(
  //           builder: (context, setState) => Container(
  //               height: context.height * 0.5,
  //               padding: EdgeInsets.only(left: 25, right: 25),
  //               decoration: BoxDecoration(
  //                 borderRadius: const BorderRadius.only(
  //                     topLeft: Radius.circular(20),
  //                     topRight: Radius.circular(20)),
  //               ),
  //               child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Center(
  //                         child: Container(
  //                       height: height * 0.01,
  //                       width: context.width * 0.17,
  //                       margin: EdgeInsets.only(bottom: 10),
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(20),
  //                           color: Theme.of(context).colorScheme.onSurface),
  //                     )),
  //                     Obx(
  //                       () => Expanded(
  //                           child: pending_friends.isNotEmpty
  //                               ? ListView.separated(
  //                                   itemCount: pending_friends.length,
  //                                   itemBuilder: (context, index) {
  //                                     UserMinimalResp user =
  //                                         pending_friends[index];
  //                                     return Row(
  //                                       children: [
  //                                         ProfileMini(
  //                                             id: user.id,
  //                                             name: user.username,
  //                                             image: user.image),
  //                                         Spacer(),
  //                                         iconFriendShip(user)
  //                                       ],
  //                                     );
  //                                   },
  //                                   separatorBuilder:
  //                                       (BuildContext context, int index) {
  //                                     return SizedBox(height: height * 0.02);
  //                                   },
  //                                 )
  //                               : Center(
  //                                   child: Text(
  //                                   'Vous n\'avez pas de demande d\'ami',
  //                                   style:
  //                                       Theme.of(context).textTheme.bodyMedium,
  //                                 ))),
  //                     )
  //                   ]))));

  //   if (pending_friends.isEmpty) {
  //     VTBottomBarController bottomBarController =
  //         Get.find<VTBottomBarController>();
  //     bottomBarController.has_social_notif.value = false;
  //     bottomBarController.has_social_notif.refresh();
  //   }
  // }
}
