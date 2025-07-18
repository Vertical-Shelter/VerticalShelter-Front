import 'dart:ui';
import 'package:app/Vertical-Tracking/Ranking/rankingVSL/rankingVSLController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/widgets/profil/profilMinivertical.dart';
import 'package:app/widgets/statsWidget/statsWidgetGym.dart';
import 'package:app/widgets/vsl/climbingLocationCard.dart';
import 'package:app/widgets/vsl/reglement.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankingVSLScreen extends GetWidget<RankingVSLController> {
  @override
  Widget build(BuildContext context) {
    // controller.refreshPaiementStatus();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ReglementVsl(),
        SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 70,
            child: Obx(() => ListView.separated(
                itemCount: controller.vsl.listClimbingLocation.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),
                itemBuilder: (context, index) {
                  return ClimbingLocationCard(
                      onTap: () {},
                      climbingLocationResp:
                          controller.vsl.listClimbingLocation[index],
                      isActive: true);
                }))),
        Spacer(),
        controller.vsl.timerInscription(context),
        Spacer(
          flex: 2,
        ),
      ],
    );
  }
}
