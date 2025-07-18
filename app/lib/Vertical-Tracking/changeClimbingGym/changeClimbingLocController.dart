import 'package:app/Vertical-Tracking/Gyms/gymsController.dart';
import 'package:app/Vertical-Tracking/news/newsList/newsListSalles/newsListSalleController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/APIrequest.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/ClimbingLocation/askClocReq.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/utils/firebase_utils.dart';
import 'package:app/utils/sprayWallController.dart';

class VTChangeClimbingLocController extends GetxController {
  RxBool is_loading = false.obs;
  RxList<ClimbingLocationResp> climbingGymList = <ClimbingLocationResp>[].obs;
  RxList<ClimbingLocationResp> searchResults = <ClimbingLocationResp>[].obs;
  TextEditingController climbingGymController = TextEditingController();
  TextEditingController searchTextControler = TextEditingController();
  RxBool isFocusing = false.obs;
  @override
  void onReady() async {
    await listClimbingGym('');
    super.onReady();
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsOverflowButtonSpacing: 10,
            title: Text(AppLocalizations.of(context)!.demande_de_salle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!
                    .veuillez_remplir_les_infos_suivantes),
                TextFormField(
                  controller: salleNameController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.nom_de_salle),
                ),
                TextFormField(
                  controller: villeController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.ville),
                ),
                TextFormField(
                  controller: instagramController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.votre_instagram),
                ),
              ],
            ),
            actions: [
              InkWell(
                  onTap: () {
                    askCloc(AskClocReq(
                        name: salleNameController.text,
                        city: villeController.text,
                        instagram: instagramController.text));
                    //show a snackbar to confirm the request
                    Get.back();
                    Get.snackbar(
                        AppLocalizations.of(context)!.demande_envoyee,
                        AppLocalizations.of(context)!
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
                            AppLocalizations.of(context)!.confirmer,
                            style: Theme.of(Get.context!).textTheme.bodyMedium,
                          )
                        ],
                      ))),
            ],
          );
        });
  }

  Future<void> changeClimbingGym(
      ClimbingLocationResp climbingLocationResp) async {
    is_loading.value = true;
    try {
      Account user = Get.find<MultiAccountManagement>().actifAccount!;
      FirebaseUtils.firebase_unsubscribeFromTopic(
          user.climbingLocationId.toString());
      Get.find<MultiAccountManagement>()
          .updateClimbingLocationId(climbingLocationResp.id, user.id);
      FirebaseUtils.firebase_subscribeToTopic(
          user.climbingLocationId.toString());
      //Todo : clear displayedWalls
      Get.find<NewsListSalleController>().listNesResp();
      Get.find<VTGymController>().setGym(climbingLocationResp.id);
      Get.find<VTGymController>().getGym().then((value) {
        Get.find<SprayWallController>().getGym();
      });
      Get.back();
      is_loading.value = false;
    } on Exception catch (e) {
      is_loading.value = false;
      throw e;
    }
  }

  Future<void> listClimbingGym(String p0) async {
    is_loading.value = true;

    try {
      climbingGymList.clear();
      climbingGymList.value =
          await climbinglocation_list_by_name(p0.capitalizeFirst);
      //searchResults = climbingGymList;
      climbingGymList.refresh();
      is_loading.value = false;
    } on Exception catch (e) {
      is_loading.value = false;
      throw e;
    }
  }

  Future<void> searchClimbingGym(String p0) async {
    is_loading.value = true;
    climbingGymList.value = await climbinglocation_list_by_name("");

    if (climbingGymList.isNotEmpty) {
      searchResults.clear(); // Clear previous search results
      for (ClimbingLocationResp contact in climbingGymList.value) {
        if (contact.name.toLowerCase().contains(p0.toLowerCase()) ||
            contact.city.toLowerCase().contains(p0.toLowerCase())) {
          searchResults
              .add(contact); // Add the contact to the searchResults list
        }
      }
      climbingGymList.clear();
      for (ClimbingLocationResp contact in searchResults.value) {
        climbingGymList.add(contact);
      }
      climbingGymList.refresh();
      is_loading.value = false;
      print(searchResults.isEmpty
          ? "Search result is empty"
          : "Found ${searchResults.length} results");
    } else {
      print("Contacts list is empty");
    }
  }
}
