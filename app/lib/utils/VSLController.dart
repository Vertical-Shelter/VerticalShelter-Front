import 'dart:io';

import 'package:app/Vertical-Setting/BottomBar/bottomBarController.dart';
import 'package:app/Vertical-Tracking/Ranking/RankingController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_req.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/VSL/Api.dart';
import 'package:app/data/models/VSL/GuildResp.dart';
import 'package:app/data/models/VSL/UserVSLResp.dart';
import 'package:app/data/models/VSL/VSLResp.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class Vslcontroller extends GetxController {
  Rxn<VSLresp> vsl = Rxn<VSLresp>();

  RxList<GuildResp> listGuild = <GuildResp>[].obs;
  RxList<ClimbingLocationResp> listClimbingLocation = <ClimbingLocationResp>[].obs;
  GuildResp? myGuild = null;
  
  Rxn<Duration> interval_preInscription = Rxn<Duration>();


  RxBool is_sign_in = false.obs;
  RxBool has_guild = false.obs;

  // TODO : s'inscrire
  // TODO : crée une guilde
  // TODO : sentWall
  // TODO : acceder au classement
  // TODO : voir notre profile/role
  // TODO : rejoindre une guilde
  // TODO : accepter un membre
  // TODO : envoyer une demande dans une guilde
  // TODO : voir les info de la guilde
  // TODO : changer de role/de guilde
  // TODO : classement des autres salles

  Future<void> onInit() async {
    super.onInit();
    initVSl();

    is_sign_in.value = false;

    }

  Future<void> initVSl() async {
    vsl.value = await getVSL();
    listGuild.value = await getListGuild(vsl.value!.id!);
    listClimbingLocation.value =
        await listVslClimbingLocations(vsl_id: vsl.value!.id!);
    interval_preInscription.value =
        vsl.value!.inscription_start_date!.difference(DateTime.now());
  }

  Future<void> initMyGuild() async {
    myGuild = null;
    has_guild.value = false;
  }

  Widget timerInscription(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Text("Formation des équipes dans"),

        SizedBox(height: 10),
        //timer
        Obx(() => interval_preInscription.value == null
            ? Container()
            : TimerCountdown(
                format: CountDownTimerFormat.daysHoursMinutesSeconds,
                daysDescription: AppLocalizations.of(Get.context!)!.days,
                hoursDescription: AppLocalizations.of(Get.context!)!.hours,
                minutesDescription: AppLocalizations.of(Get.context!)!.minutes,
                secondsDescription: AppLocalizations.of(Get.context!)!.seconds,
                endTime: DateTime.now().add(interval_preInscription.value!),
                onEnd: () {
                  print("Timer finished");
                },
              )),
        SizedBox(height: 10),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Prennez connaissance du règlement et ",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
              children: [
                TextSpan(
                  text: "pré-inscrivez-vous !",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            )),
      ],
    );
  }
}
