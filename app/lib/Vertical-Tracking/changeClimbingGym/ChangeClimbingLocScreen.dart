import 'package:app/Vertical-Tracking/changeClimbingGym/changeClimbingLocController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/climbingLocationMinimalist.dart';
import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/searchBar/searchBarWidget.dart';

class VTChangeClimbingLocScreen
    extends GetWidget<VTChangeClimbingLocController> {
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    controller.isFocusing.value = false;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          

          actions: [

            BackButtonWidget(
                onPressed: () => Get.back(),
              ),

            Obx(() => Visibility(
                        visible: controller.isFocusing.value == false,
                        child: Spacer())),
              Expanded(
                        child: AnimatedSearchBar(
                      controller: controller.searchTextControler,
                      duration: Duration(milliseconds: 300),
                      height: 40,
                      animationDuration: Duration(milliseconds: 300),
                      onClose: () {
                        controller.isFocusing.value = false;
                        controller.isFocusing.refresh();
                      },
                      onTap: () {
                        controller.isFocusing.value = true;
                        controller.isFocusing.refresh();
                      },
                      onChanged: (p0) async {
                        controller.searchClimbingGym(p0);
                      },
                      // text: 'Rechercher',
                      // focusNode: controller.focusNode
                    )),
            InkWell(
                  onTap: () {
                    controller.popupRequestForAGym();
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color:
                              Theme.of(Get.context!).colorScheme.surface,
                          borderRadius: BorderRadius.circular(30)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add)
                        ],
                      ))),
      ],
        ),
        
        body: Obx(() => controller.is_loading.value
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.topLeft,
                child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemCount: controller.climbingGymList.length,
                    itemBuilder: (context, index) {
                      return ClimbingLocationMinimalistWidget(
                          context, controller.climbingGymList[index],
                          onPressed: () => controller.changeClimbingGym(
                              controller.climbingGymList[index]));
                    }))));
  }
}