import 'package:app/Vertical-Tracking/Gyms/boulder/boulderController.dart';
import 'package:app/Vertical-Tracking/Gyms/boulder/boulderScreen.dart';
import 'package:app/Vertical-Tracking/Gyms/sprayWall/sprayWallScreen.dart';
import 'package:app/Vertical-Tracking/contest/ContestList/contestController.dart';
import 'package:app/Vertical-Tracking/contest/ContestList/contestScreen.dart';
import 'package:app/Vertical-Tracking/news/newsList/newsListSalles/newsListSalle.dart';

import 'package:app/Vertical-Tracking/profil/profil_controller.dart';
import 'package:app/data/models/ClimbingLocation/askClocReq.dart';
import 'package:app/data/models/User/api.dart';
import 'package:app/data/models/User/user_req.dart';
import 'package:app/data/models/news/userNews/api.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/APIrequest.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Wall/Api.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/utils/VSLController.dart';
import 'package:app/utils/firebase_utils.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:app/widgets/settingmenu.dart';

class VTGymController extends GetxController with GetTickerProviderStateMixin {
  RxBool hasNotif = false.obs;

  ClimbingLocationController gymController =
      Get.find<ClimbingLocationController>();

  RxList<ClimbingLocationResp> climbingLocationMinimalRespList =
      <ClimbingLocationResp>[].obs;
  RxString actualTab = "".obs;

  Future<void> SetClimbingLoc(String climbingLocation_id) async {
    is_done_loading_CLoc.value = false;
    is_done_loading_CLoc.refresh();
    Get.parameters['climbingLocationId'] = climbingLocation_id;
    try {
      UserReq userReq = UserReq(climbingLocation_id: climbingLocation_id);
      user_put(userReq);

      Get.find<MultiAccountManagement>().updateClimbingLocationId(
          climbingLocation_id,
          Get.find<MultiAccountManagement>().actifAccount!.id);
      is_done_loading_CLoc.value = true;
      is_done_loading_CLoc.refresh();

      //Update the user in the multiAccountManagement

      gymIdIsSet.value = true;
      gymIdIsSet.refresh();

      Account user = Get.find<MultiAccountManagement>().actifAccount!;
      Get.find<MultiAccountManagement>()
          .updateClimbingLocationId(climbingLocation_id, user.id);
      FirebaseUtils.firebase_subscribeToTopic(
          user.climbingLocationId.toString());
      //Todo : clear displayedWalls
      Get.find<VTGymController>().getGym();
    } on Exception catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> getAllGyms() async {
    climbingLocationMinimalRespList.value =
        await climbinglocation_list_by_name("");
  }

  void onChandeColumnIndex(String tabName) {
    actualTab.value = tabName;
    actualTab.refresh();
  }

  Map<String, dynamic> header = {
    "fr": {
      'Blocs': {"link": Get.put(BoulderScreen()), "status": "inactive"},
      'SprayWall': {"link": Get.put(SprayWallScreen()), "status": "inactive"},
      'Actualités': {
        "link": Get.put(NewsListSalleScreen()),
        "status": "inactive"
      },
      'Contests': {"link": Get.put(ContestList()), "status": "inactive"},
    },
    "en": {
      'Boulders': {"link": Get.put(BoulderScreen()), "status": "inactive"},
      'SprayWall': {"link": Get.put(SprayWallScreen()), "status": "inactive"},
      'News': {"link": Get.put(NewsListSalleScreen()), "status": "inactive"},
      'Contests': {"link": Get.put(ContestList()), "status": "inactive"},
    }
  };

  @override
  void onInit() async {
    super.onInit();
    actualTab.value = header[Get.find<PrefUtils>().getLocal()].keys.first;
    await getGym();
  }

  RxBool is_done_loading_CLoc = false.obs;
  RxString climbingLocation_id = ''.obs;
  RxBool gymIdIsSet = true.obs;

  void setGym(String climbingLocationId) {
    Get.parameters['climbingLocationId'] = climbingLocationId;
  }

  Future<void> getGym() async {
    is_done_loading_CLoc.value = false;
    is_done_loading_CLoc.refresh();

    //check if there is a climbingLocationId in the params

    var params = Get.parameters;
    if (params['climbingLocationId'] != null) {
      UserReq userReq =
          UserReq(climbingLocation_id: params['climbingLocationId']);
      user_put(userReq);
      climbingLocation_id.value = params['climbingLocationId']!;
      Get.find<MultiAccountManagement>().updateClimbingLocationId(
          climbingLocation_id.value,
          Get.find<MultiAccountManagement>().actifAccount!.id);
    } else {
      climbingLocation_id.value =
          Get.find<MultiAccountManagement>().actifAccount!.climbingLocationId;
    }
    if (climbingLocation_id.value == '') {
      gymIdIsSet.value = false;
      gymIdIsSet.refresh();
      getAllGyms();
      is_done_loading_CLoc.value = true;
      is_done_loading_CLoc.refresh();
      return;
    } else {
      gymIdIsSet.value = true;
      gymIdIsSet.refresh();
    }

    await gymController.getGym(climbingLocation_id.value);
    is_done_loading_CLoc.value = true;
    is_done_loading_CLoc.refresh();
    //check if BoulderController has been init and is in the tree
    bool isBoulderControllerInit = Get.isRegistered<BoulderController>();
    bool isContestControllerInit = Get.isRegistered<ContestController>();
    if (isBoulderControllerInit == false || isContestControllerInit == false) {
      Get.put(BoulderController());
      Get.put(ContestController());
    } else {
      Get.find<BoulderController>().getBoulders();
      Get.find<ContestController>().listContestResp();
    }
  }

  Future<void> popupRequestForAGym() async {
    //show a popup that let user fill a form with informations about the gym :
    // name, city and the user contact if he wants to be contacted
    // then send the request to the backend
    TextEditingController salleNameController = TextEditingController();
    TextEditingController villeController = TextEditingController();
    TextEditingController instagramController = TextEditingController();
    await showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(Get.context!)!.demande_de_salle),
            content: Column(
              children: [
                Text(AppLocalizations.of(Get.context!)!
                    .veuillez_remplir_les_infos_suivantes),
                TextFormField(
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(Get.context!)!.nom_de_salle),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(Get.context!)!.ville),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(Get.context!)!.votre_instagram),
                ),
              ],
            ),
            actions: [
              InkWell(
                  onTap: () async {
                    print("gym selected");
                    //climbingLocationResp = await climbingLocation_get(climbingLocation_id.value);
                    askCloc(AskClocReq(
                        name: salleNameController.text,
                        city: villeController.text,
                        instagram: instagramController.text));
                    //show a snackbar to confirm the request
                    Get.back();
                    Get.snackbar(
                        AppLocalizations.of(Get.context!)!.demande_envoyee,
                        AppLocalizations.of(Get.context!)!
                            .demande_envoyee_avec_succes);
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Theme.of(Get.context!).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text(
                            AppLocalizations.of(Get.context!)!.confirmer,
                            style: Theme.of(Get.context!).textTheme.bodyMedium,
                          )
                        ],
                      )))
            ],
          );
        });
  }

  void onPressContest() async {
    if (gymController.climbingLocationResp!.actualContest == null) {
      Get.rawSnackbar(
          message: AppLocalizations.of(Get.context!)!.pas_de_contest_en_cour,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 5));
      return;
    }
    Get.toNamed(AppRoutesVT.contestDetaiil, parameters: {
      "contestId": gymController.climbingLocationResp!.actualContest!.id!
    });
  }

  void onTapNotif() {
    VTProfilController profilController = Get.find<VTProfilController>();
    profilController.userResp.value!.lastDateNews = DateTime.now().toUtc();
    profilController.userResp.refresh();
    // colorFilterController?.refresh!();
    // setLastDateNews();
    Get.toNamed(AppRoutesVT.userNewsScreen);
  }
}
