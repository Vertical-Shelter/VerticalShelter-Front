import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/projet/api.dart';
import 'package:app/data/models/User/projet/projetResp.dart';
import 'package:app/utils/utils.dart';

class ProjetController extends GetxController {
  RxList<ProjetResp> projetList = <ProjetResp>[].obs;

  @override
  void onInit() async {
    await getProjects();
    super.onInit();
  }

  Future<void> getProjects() async {
    projetList.value = await list_projets();
    for (ProjetResp projet in projetList) {
      if (projet.is_sprayWall) {
        projet.image =
            await loadNetworkImage(projet.wall!.secteurResp!.images.first);
      }
    }
    projetList.refresh();
  }
}
