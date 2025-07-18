import 'dart:async';

import 'package:app/core/app_export.dart';
import 'package:app/data/models/VSL/Api.dart';
import 'package:app/utils/VSLController.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class DescriptionVslController extends GetxController {
  RxList<String> list = <String>[].obs;
  Vslcontroller vsl = Get.find<Vslcontroller>();
  RxBool commentCaMarche = true.obs;
  RxBool quEstCeQueCest = true.obs;
  RxBool equipe = true.obs;
  RxBool salle = true.obs;
  RxBool bloc = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchList();
  }

  Future<void> fetchList() async {
    list.value = await getVslInformation(edition: 1);
  }

  Future<void> preRegister() async {
    preRegisterVSL(vsl.vsl.value!.id!);
    if (vsl.vsl.value!.start_date!.compareTo(DateTime.now()) > 0) {
      showDialog(
          context: Get.context!,
          builder: (context) => Dialog(
              child: Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //inscription start in + timer
                        Text("Vous êtes pré-inscrit !"),
                        SizedBox(height: 10),
                        vsl.timerInscription(context)
                      ]))));
      return;
    }
  }
}
