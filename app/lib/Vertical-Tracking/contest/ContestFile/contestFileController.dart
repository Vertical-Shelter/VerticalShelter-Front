import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Contest/contestApi.dart';
import 'package:app/data/models/Contest/contestResp.dart';
import 'package:app/data/models/Contest/userContestReq.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/blocCard.dart';
import 'package:app/widgets/contest/phaseCard.dart';
import 'package:app/widgets/profil/profilMinivertical.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ContestFileController extends GetxController {
  Rx<ContestResp> contestResp = ContestResp().obs;
  RxString dayOfWeek = "".obs;
  RxString dayMonth = "".obs;
  RxString hour = "".obs;
  ClimbingLocationMinimalResp? climbingLocationMinimalResp;
  RxBool isLoading = true.obs;
  RxList<BlocCard> blocCardList = <BlocCard>[].obs;
  RxInt phaseIndex = 0.obs;

  void onInit() {
    _getContest(
        Get.parameters['contestId']!,
        Get.parameters[
            "climbingLocationId"]!); // Get.parameters['contestid']! is the id of the contest
    super.onInit();

    //Set mapBlocsWithPeople as a map of blocs with the people who have climbed them
  }

  final RxInt tabIndex = 0.obs;

  void generateBlocCard() {
    var myIncsription = contestResp.value!.inscription.firstWhereOrNull(
        (element) =>
            element.user!.id ==
            Get.find<MultiAccountManagement>().actifAccount!.id);
    contestResp.value.blocs!.forEach((bloc) {
      List<bool> isSelected = [];
      if (myIncsription != null &&
          myIncsription.isBlocSucceed != null &&
          myIncsription.isBlocSucceed!.isNotEmpty) {
        var isDone = myIncsription.isBlocSucceed!
            .firstWhereOrNull((element) => element.blocId == bloc.id);
        if (isDone != null && isDone.isZoneSucceed != null) {
          isSelected = isDone.isZoneSucceed!;
          isSelected.add(isDone.isSucceed!);
        }
      }
      blocCardList.add(BlocCard(bloc: bloc, isSelected: isSelected));
    });
  }

  void refreshContestResp(ContestResp contestResp) {
    this.contestResp.value = contestResp;
  }

  void subscribe(BuildContext context) async {
    RxBool isMale = false.obs;
    RxBool isFemale = false.obs;
    TextEditingController nameController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    RxBool isMember = false.obs;

    RxBool is18YO = true.obs;
    await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => Container(
            width: context.width,
            height: context.height * 0.8,
            padding: const EdgeInsets.only(left: 25, right: 25),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Theme.of(context).colorScheme.surface),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                  height: 10,
                  width: width * 0.3,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //Button that select either man or women
              Obx(() => Container(
                      child: Row(
                    children: [
                      SizedBox(width: 20),
                      Text(AppLocalizations.of(context)!.homme,
                          style: Theme.of(context).textTheme.bodyMedium!),
                      Checkbox(
                        value: isMale.value,
                        onChanged: (value) {
                          if (value != null && value) {
                            isMale.value = true;
                            isFemale.value = false;
                          }
                        },
                      ),
                      Spacer(),
                      Text(AppLocalizations.of(context)!.femme,
                          style: Theme.of(context).textTheme.bodyMedium!),
                      Checkbox(
                        value: isFemale.value,
                        onChanged: (value) {
                          if (value != null && value) {
                            isFemale.value = true;
                            isMale.value = false;
                          }
                        },
                      ),
                      SizedBox(width: 20),
                    ],
                  ))),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.nom,
                    hintStyle: Theme.of(context).textTheme.bodyMedium),
              ),
              SizedBox(height: 10),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.prenom,
                    hintStyle: Theme.of(context).textTheme.bodyMedium),
              ),
              SizedBox(height: 10),
              //add a switch to inform if he is a member or not

              Text(AppLocalizations.of(context)!.abonne_a_la_salle,
                  style: Theme.of(context).textTheme.bodyMedium),
              Obx(() => Container(
                      child: Row(
                    children: [
                      SizedBox(width: 20),
                      Text(AppLocalizations.of(context)!.oui,
                          style: Theme.of(context).textTheme.bodyMedium!),
                      Checkbox(
                        value: isMember.value,
                        onChanged: (value) {
                          if (value != null && value) {
                            isMember.value = true;
                          }
                        },
                      ),
                      Spacer(),
                      Text(AppLocalizations.of(context)!.non,
                          style: Theme.of(context).textTheme.bodyMedium!),
                      Checkbox(
                        value: !isMember.value,
                        onChanged: (value) {
                          if (value != null && value) {
                            isMember.value = false;
                          }
                        },
                      ),
                      SizedBox(width: 20),
                    ],
                  ))),

              //add a switch to inform if he is a member or not

              Text(AppLocalizations.of(context)!.plus_de_18,
                  style: Theme.of(context).textTheme.bodyMedium),
              Obx(() => Container(
                      child: Row(children: [
                    SizedBox(width: 20),
                    Text(AppLocalizations.of(context)!.oui,
                        style: Theme.of(context).textTheme.bodyMedium!),
                    Checkbox(
                      value: is18YO.value,
                      onChanged: (value) {
                        if (value != null && value) {
                          is18YO.value = true;
                        }
                      },
                    ),
                    Spacer(),
                    Text(AppLocalizations.of(context)!.non,
                        style: Theme.of(context).textTheme.bodyMedium!),
                    Checkbox(
                      value: !is18YO.value,
                      onChanged: (value) {
                        if (value != null && value) {
                          is18YO.value = false;
                        }
                      },
                    ),
                  ]))),

              SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.phases_dinscription),
              SizedBox(height: 20),

              Flexible(
                  flex: 2,
                  child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                      itemCount: contestResp.value!.phases!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              phaseIndex.value = index;
                            },
                            child: Obx(() => PhaseCard(
                                isSelected: phaseIndex.value == index,
                                phaseResp: contestResp.value!.phases![index])));
                      })),
              SizedBox(height: 10),
              InkWell(
                  onTap: () {
                    if (nameController.text.isEmpty ||
                        firstNameController.text.isEmpty) {
                      Get.snackbar(AppLocalizations.of(context)!.erreur,
                          AppLocalizations.of(context)!.erreur_nom_prenom,
                          backgroundColor: Colors.red);
                      return;
                    }
                    if (isMale.value == false && isFemale.value == false) {
                      Get.snackbar(AppLocalizations.of(context)!.erreur,
                          AppLocalizations.of(context)!.erreur_genre,
                          backgroundColor: Colors.red);
                      return;
                    } else {
                      comfirmSubscribe(
                          isMale.value,
                          nameController.text,
                          firstNameController.text,
                          isMember.value,
                          is18YO.value);
                    }
                  },
                  child: Container(
                      width: width,
                      height: 50,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(180)),
                      child: Text(AppLocalizations.of(context)!.confirmer,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.surface),
                          textAlign: TextAlign.center))),
              SizedBox(height: 10)
            ])));
  }

  void onDone(BuildContext context) async {
    //Show a dialog to confirm the end of the contest
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.sauvegarder_resultats),
              content:
                  Text(AppLocalizations.of(context)!.vous_pourrez_modifier),
              actions: [
                TextButton(
                    onPressed: () => Get.back(),
                    child: Text(AppLocalizations.of(context)!.annuler,
                        style: Theme.of(context).textTheme.bodyMedium)),
                TextButton(
                    onPressed: () async {
                      await scoreContest(context);
                    },
                    child: Text(AppLocalizations.of(context)!.confirmer,
                        style: Theme.of(context).textTheme.bodyMedium))
              ],
            ));

    // Get.back();
  }

  Future<void> scoreContest(BuildContext context) async {
    Account account = Get.find<MultiAccountManagement>().actifAccount!;
    List<IsBlocSucceedReq> score = [];
    blocCardList.value.forEach((bloc) {
      score.add(IsBlocSucceedReq(
          blocId: bloc.bloc.id!,
          isSucceed: bloc.isSelected.isEmpty
              ? false
              : bloc.isSelected
                  .map((e) => e)
                  .reduce((value, element) => value && element),
          isZoneSucceed: bloc.isSelected.isEmpty
              ? List.generate(bloc.bloc.zones!, (value) => false)
              : bloc.isSelected.sublist(0, bloc.bloc.zones!)));
    });
    postScore(account.climbingLocationId, contestResp.value.id!,
        ScoreReq(score: score));
    Get.back();
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      messageText: Text(
        "Score enregistré, les résultats s'actualiseront d'ici 2 minutes",
        style: Theme.of(Get.context!)
            .textTheme
            .bodyMedium!
            .copyWith(color: ColorsConstantDarkTheme.background, fontSize: 16),
      ),
      borderRadius: 10,
      maxWidth: 300,
      duration: 3.seconds,
      snackPosition: SnackPosition.TOP,
    ));
  }

  void comfirmSubscribe(bool isMale, String name, String firstName,
      bool isMember, bool is18YO) async {
    Account account = Get.find<MultiAccountManagement>().actifAccount!;
    UserContestReq userContestReq = UserContestReq(
        is18YO: is18YO,
        genre: isMale ? "M" : "F",
        nom: name,
        prenom: firstName,
        phaseId: contestResp.value.phases[phaseIndex.value].id!,
        isMemberShip: isMember);
    contestResp.value = await subscribeToContest(
        account.climbingLocationId, contestResp.value.id!, userContestReq);
    contestResp.refresh();
    Get.back();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      Account account = Get.find<MultiAccountManagement>().actifAccount!;
      if (barcodeScanRes == contestResp.value.id!) {
        qrCodeScanned(account.climbingLocationId, contestResp.value!.id!);
        contestResp.value.qrCodeScanned = true;
        contestResp.refresh();
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
  }

  Future<void> unSubscribe() async {
    Account account = Get.find<MultiAccountManagement>().actifAccount!;
    await unSubscribeToContest(
      account.climbingLocationId,
      contestResp.value!.id!,
    );
    contestResp.value.inscription.removeWhere((element) =>
        element.user!.id ==
        account.id); //Remove the user from the list of inscription
    contestResp.value.isSubscribed = false;
    contestResp.refresh();
  }

  void _getContest(String id, String climbingLocationId) async {
    contestResp.value =
        await getContest(climbingLocationId: climbingLocationId, contestId: id);
    contestResp.refresh();
    dayOfWeek.value =
        DateFormat.EEEE(AppLocalizations.of(Get.context!)!.pays_code)
            .format(contestResp.value.date!);
    dayMonth.value =
        DateFormat.MMMMd(AppLocalizations.of(Get.context!)!.pays_code)
            .format(contestResp.value.date!);
    hour.value = DateFormat.Hm(AppLocalizations.of(Get.context!)!.pays_code)
        .format(contestResp.value.date!);
    isLoading.value = false;
    isLoading.refresh();
    generateBlocCard();
  }

  void refreshNewsResp(ContestResp newsResp) {
    this.contestResp.value = newsResp;
    dayOfWeek.value =
        DateFormat.EEEE(AppLocalizations.of(Get.context!)!.pays_code)
            .format(newsResp.date!);
    dayMonth.value =
        DateFormat.MMMMd(AppLocalizations.of(Get.context!)!.pays_code)
            .format(newsResp.date!);
    hour.value = DateFormat.Hm(AppLocalizations.of(Get.context!)!.pays_code)
        .format(newsResp.date!);
  }

  void onBackPressed() {
    if (Get.parameters['deepLink'] == "true") {
      Get.offAllNamed(AppRoutesVT.MainPage);
    } else {
      Get.back();
    }
  }

  void onListInscriptionPress(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => Container(
            height: context.height * 0.5,
            padding: const EdgeInsets.only(left: 25, right: 25),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Theme.of(context).colorScheme.surface),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                  height: height * 0.01,
                  width: width * 0.3,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              Text(AppLocalizations.of(context)!.ces_personnes_sont_inscrites,
                  style: Theme.of(context).textTheme.titleLarge!),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: contestResp.value!.inscription.length != 0
                      ? ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                          itemCount: contestResp.value!.inscription.length,
                          itemBuilder: (context, index) => fromUserMini(context,
                              contestResp.value!.inscription[index].user),
                        )
                      : Center(
                          child: Text(
                          AppLocalizations.of(context)!.personne_est_inscrit,
                        ))),
            ])));
  }

  void onRankingPress(BuildContext context) {
    Get.toNamed(AppRoutesVT.contestRankingScreen, parameters: {
      "climbingLocationId":
          Get.find<MultiAccountManagement>().actifAccount!.climbingLocationId,
      "contestId": contestResp.value.id!
    });
  }
}
