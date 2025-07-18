import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/Vertical-Tracking/Gyms/gymsController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/climbingLocationMinimalist.dart';
import 'package:app/widgets/menuButton.dart';
import 'package:app/widgets/settingmenu.dart';
import 'package:app/widgets/tabBarWidget.dart';

class VTGymScreen extends GetWidget<VTGymController> {
  List<WallResp> selectedItem = [];
  bool isMultiSelectionEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.is_done_loading_CLoc.value == false
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Obx(() => Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              appBar: _AppBarWidget(context),
              body: controller.gymIdIsSet.value == false
                  ? noGymSelected()
                  : controller.header[Get.find<PrefUtils>().getLocal()]
                      [controller.actualTab.value]["link"],
            )));
  }

  Widget noGymSelected() {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(Get.context!).colorScheme.surface,
            borderRadius: BorderRadius.circular(20)),
        child: Obx(() => ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            clipBehavior: Clip.hardEdge,
            itemCount: controller.climbingLocationMinimalRespList.length + 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == controller.climbingLocationMinimalRespList.length) {
                return InkWell(
                    onTap: () {
                      controller.popupRequestForAGym();
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
                              AppLocalizations.of(context)!.ajouter_une_salle,
                              style:
                                  Theme.of(Get.context!).textTheme.bodyMedium,
                            )
                          ],
                        )));
              }

              return ClimbingLocationMinimalistWidget(
                  context, controller.climbingLocationMinimalRespList[index],
                  onPressed: () => controller.SetClimbingLoc(
                      controller.climbingLocationMinimalRespList[index].id));
            })));
  }

  PreferredSizeWidget? _AppBarWidget(BuildContext context) {
    return PreferredSize(
        // You can set the size here, but it's left to zeros in order to expand based on its child.
        preferredSize: Size(width, 100),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: controller.gymIdIsSet.value == false
                ? Text(
                    AppLocalizations.of(context)!.veuillez_choisir_une_salle,
                    maxLines: 3,
                  )
                : Column(children: [
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                              child: ClimbingLocationMinimalistWidget(
                            context,
                            controller.gymController.climbingLocationResp!,
                            onPressed: () =>
                                Get.toNamed(AppRoutesVT.changeClimbingLoc),
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            child:
                                Theme.of(context).brightness == Brightness.dark
                                    ? SvgPicture.asset(
                                        BlackIconConstant.changersalle,
                                        height: 25,
                                      )
                                    : SvgPicture.asset(
                                        BlackIconConstant.changersalle,
                                        height: 25,
                                      ),
                            onTap: () =>
                                Get.toNamed(AppRoutesVT.changeClimbingLoc),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Obx(() =>
                              Stack(alignment: Alignment.center, children: [
                                InkWell(
                                  child: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? SvgPicture.asset(
                                          BlackIconConstant.notification,
                                          height: 25,
                                        )
                                      : SvgPicture.asset(
                                          BlackIconConstant.notification,
                                          height: 25,
                                        ),
                                  onTap: () => controller.onTapNotif(),
                                ),
                                controller.hasNotif.value == true
                                    ? Positioned(
                                        right: 10,
                                        top: 10,
                                        child: CircleAvatar(
                                          radius: 5,
                                          backgroundColor: Colors.red,
                                        ),
                                      )
                                    : Container()
                              ])),
                        ]),
                    Obx(() => Flexible(
                            child: TabBarWidget(
                          index: controller.actualTab.value,
                          tabNames: controller
                              .header[Get.find<PrefUtils>().getLocal()].keys
                              .map((e) {
                            return {
                              'name': e,
                              'link': controller
                                  .header[Get.find<PrefUtils>().getLocal()][e]
                                      ["link"]
                                  .toString(),
                              'status': controller
                                  .header[Get.find<PrefUtils>().getLocal()][e]
                                      ["status"]
                                  .toString()
                            };
                          }).toList(),
                          onTap: controller.onChandeColumnIndex,
                        )))
                  ])));
    //  ])));
  }
}
