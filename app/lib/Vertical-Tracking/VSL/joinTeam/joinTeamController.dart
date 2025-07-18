import 'package:app/Vertical-Tracking/VSL/joinTeam/joinTeamScreen.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/VSL/GuildResp.dart';
import 'package:app/utils/VSLController.dart';
import 'package:app/widgets/textFieldShaker/textFieldShakerController.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class JoinTeamcontroller extends GetxController {
  Vslcontroller vsl = Get.find<Vslcontroller>();
  RxList<GuildResp> filteredList = <GuildResp>[].obs;

  RxString searchQuery = ''.obs;
  RxBool is_loading = false.obs;
  RxInt index = 1.obs;

  // Rxn<ClimbingLocationResp> climbingLocationSelected =
  //     Rxn<ClimbingLocationResp>();

  // TextEditingController guildName = TextEditingController();
  // RxList<ClimbingLocationResp> climbingGymList = <ClimbingLocationResp>[].obs;

  Rxn<GuildResp> guildSelected = Rxn<GuildResp>();

  //info perso
  TextEditingController lastname = TextEditingController();
  ShakeTextFieldController lastnameShake = ShakeTextFieldController();
  TextEditingController name = TextEditingController();
  ShakeTextFieldController nameShake = ShakeTextFieldController();
  RxnInt age = RxnInt();
  RxBool isMale = false.obs;
  
  RxString selectedRole = "".obs;
  TextEditingController teamName = TextEditingController();

  
  @override
  Future<void> onInit() async {
    super.onInit();

    // Initialiser la liste filtrée avec toutes les équipes
    filteredList.assignAll(vsl.listGuild);

    // Observer les changements dans la requête et mettre à jour la liste filtrée
    ever(searchQuery, (_) => filterList());

    vsl.listClimbingLocation;
  }

  void changeState(bool isNext) async {
    if (isNext) {
      if (index.value < 3) {
        index.value++;
      } else {
        // await updateGuildRole(guildSelected.value!.id, vsl.vsl.value!.id!, "ninja");

        Get.toNamed(AppRoutesVT.MainPage);
        Get.delete<JoinTeamcontroller>();
      }
    } else {
      if (index.value > 1) {
        index.value--;
      } else {
        Get.back();
      }
    }
    index.refresh();
  }

  Future<void> joinGuild() async {

    // Guildreq guild = Guildreq(
    //     name: guildSelected.value!.name,
    //     climbingLocation_id: guildSelected.value!.climbingLocation_id,
    //     image_url: guildSelected.value.image_url image_guild.value!.path);
    // try {
    //   createGuildPost(guild, vsl.vsl.value!.id!).then((value) {
    //     vsl.listGuild.add(value);
    //     joinGuildPost(guild_id: value.id!, vsl_id: vsl.vsl.value!.id!);
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  bool checkTextfields() {
    bool hasError = false;
    if (index.value == 1) {
      if (name.text.isEmpty) {
        nameShake.shake();
        hasError = true;
      }
      if (lastname.text.isEmpty) {
        lastnameShake.shake();
        hasError = true;
      }
      if (age.value == null) {
        hasError = true;
      }
    } else if (index.value == 2) {
      if (selectedRole.value.isEmpty) {
        return false;
      }
    }
    if (hasError) {
      return false;
    }
    return true;
  }

  void filterList() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredList.assignAll(vsl.listGuild); // Affiche tout si aucune recherche
    } else {
      filteredList.assignAll(
        vsl.listGuild.where((guild) {
          final nameLower = guild.name.toLowerCase();
          ClimbingLocationResp? location = findClimbingLocation(guild);
          if(location == null){
            return nameLower.contains(query);
          } else{
            final locationLower = location.name.toLowerCase();
            return nameLower.contains(query) || locationLower.contains(query);
          }
        }).toList(),
      );
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  ClimbingLocationResp? findClimbingLocation(GuildResp guild){
    if(vsl.listClimbingLocation.any((x) => (x.id.compareTo(guild.climbingLocation_id) == 0))){
      return vsl.listClimbingLocation.firstWhere((x) => (x.id.compareTo(guild.climbingLocation_id) == 0));
    }
    return null;
  }

  void sortList({required String criteria}) {
    if (criteria == 'name') {
      filteredList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else if (criteria == 'location') {
      filteredList.sort((a, b) => a.climbingLocation_id.compareTo(b.climbingLocation_id));
    }
  }

  void ontap(int index){
    guildSelected.value = filteredList[index];
      Get.to(() => JoinTeamscreen(), 
                  transition: Transition.rightToLeft,
                  duration: Duration(milliseconds: 500));
  }
}