import 'package:app/Vertical-Setting/SprayWallManagmenent/SprayWallManagementController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/BackButton.dart';

class SprayWallManagementScreen
    extends GetWidget<SprayWallManagementController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            BackButtonWidget(),
            Spacer(),
            Text(AppLocalizations.of(context)!.gestion_de_spraywall,
                style: Theme.of(context).textTheme.labelLarge),
            Spacer()
          ]),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        body: Obx(() => GridView.count(
                crossAxisCount: 3,
                childAspectRatio:
                    0.4, // change this value for different results
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: <Widget>[
                  for (var i = 0;
                      i < controller.sprayWallListResp.length + 1;
                      i++)
                    InkWell(
                        onTap: () {
                          controller.showPopupCreateSprayWall(i);
                        },
                        child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: i == controller.sprayWallListResp.length
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Icon(Icons.add),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .ajouter_un_spraywall,
                                          textAlign: TextAlign.center,
                                        )
                                      ])
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                        Image.network(controller
                                            .sprayWallListResp[i].image!),
                                        Spacer(),
                                        Text(controller
                                            .sprayWallListResp[i].name!),
                                        Spacer()
                                      ])))
                ])));
  }
}
