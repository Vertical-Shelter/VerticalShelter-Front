import 'package:app/Vertical-Tracking/profil/profil_controller.dart';
import 'package:app/core/app_export.dart';

import 'package:app/widgets/menuButton.dart';

import 'package:app/widgets/profil/profilImage.dart';

import 'package:app/widgets/vid%C3%A9oCapture.dart';

import 'package:app/widgets/walls/wallProject.dart';

import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';

import 'package:video_player/video_player.dart';

class VTProfilScreen extends GetWidget<VTProfilController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              toolbarHeight: height * 0.1,
              elevation: 0,
              title: Row(children: [
                Text(AppLocalizations.of(context)!.profil,
                    style: Theme.of(context).textTheme.labelLarge!),
                Spacer(),
                MenuButtonWidget(
                    onPressed: () => controller.OnTapMenuButton(context))
              ]),
            ),
            body: Obx(() => controller.is_loading_top.value
                ? Center(child: CircularProgressIndicator())
                : controller.userResp == null
                    ? Center(
                        child: Text(
                            AppLocalizations.of(context)!.erreur_de_chargement))
                    : body(context))));
  }

  Widget body(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topPart(context),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverOverlapAbsorber(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                            sliver: SliverStickyHeader(
                                header: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                  Text(AppLocalizations.of(context)!.mes_videos,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!),
                                  SizedBox(height: 20),
                                  SizedBox(
                                      height: 150,
                                      child: Obx(() => controller
                                                  .videoList.length ==
                                              0
                                          ? Center(
                                              child: Text(
                                              AppLocalizations.of(context)!
                                                  .pas_de_video,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!,
                                              textAlign: TextAlign.center,
                                            ))
                                          : ListView.separated(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              cacheExtent: 100,
                                              addRepaintBoundaries: false,
                                              addAutomaticKeepAlives: true,
                                              itemBuilder: (context, index) =>
                                                  VideoCapture(
                                                    'betaUser',
                                                    wantKeepAlive: true,
                                                    controller:
                                                        VideoPlayerController
                                                            .networkUrl(Uri
                                                                .parse(controller
                                                                    .videoList[
                                                                        index]
                                                                    .url)),
                                                    isReadOnly: true,
                                                  ),
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                        width: 10,
                                                      ),
                                              itemCount: controller
                                                  .videoList.length))),
                                  SizedBox(height: 20),
                                ]))),
                        SliverPersistentHeader(
                          delegate: ProjectHeader(),
                          pinned: true,
                          floating: true,
                        ),
                      ];
                    },
                    body: Obx(() => controller
                            .projectController.projetList.isEmpty
                        ? Center(
                            child: Text(
                            AppLocalizations.of(context)!.pas_encore_de_projets,
                            style: Theme.of(context).textTheme.bodySmall!,
                            textAlign: TextAlign.center,
                          ))
                        : SizedBox(
                            height: 150,
                            child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) => ProjectWidget(
                                    isSelected: false,
                                    projetResp: controller
                                        .projectController.projetList[index],
                                    onPressed: () => {},
                                    selectWall: () {},
                                    unselectWall: () {}),
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 10,
                                    ),
                                itemCount: controller
                                    .projectController.projetList.length))),
                  )

                  // Text("Mes Anneaux",
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .titleLarge!
                  //         .copyWith(
                  //             color: Theme.of(context)
                  //                 .colorScheme
                  //                 .background)),
                  // SizedBox(height: 20),
                  // Obx(() => controller.baniereList.length == 0
                  //     ? Center(
                  //         child: Text(
                  //             "Vous n'avez pas encore d'anneaux, allez en chercher !",
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .bodySmall!
                  //                 .copyWith(
                  //                     color: Theme.of(context)
                  //                         .colorScheme
                  //                         .background)))
                  //     : SizedBox(
                  //         height: 150,
                  //         child: ListView.separated(
                  //             scrollDirection: Axis.horizontal,
                  //             itemBuilder: (context, index) =>
                  //                 BaniereWidgets(
                  //                     baniereResp:
                  //                         controller.baniereList[index],
                  //                     onTap: () {
                  //                       // controller.equipBaniere(controller.baniereList[index].id!);
                  //                     }),
                  //             separatorBuilder: (context, index) =>
                  //                 SizedBox(
                  //                   width: 10,
                  //                 ),
                  //             itemCount: controller.baniereList.length))),

                  // SizedBox(height: 20),
                  //
                  ))
        ]);
  }

  Widget topPart(BuildContext context) {
    return Container(
        width: width,
        height: 220,
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 10,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      profileImage(
                          image: controller.userResp.value!.profileImage,
                          baniereImage: controller.userResp.value!.baniere,
                          size: 100),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              BlackIconConstant.logo,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              controller.userResp.value!.username!,
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          ]),
                      controller.userResp.value!.description == ""
                          ? SizedBox()
                          : SizedBox(height: 10),
                      Text(
                        controller.userResp.value!.description ?? "",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ])),
            Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                    onTap: () async {
                      await controller.onTapQrCode(context);
                    },
                    child: Container(
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          BlackIconConstant.qrCode,
                          height: 50,
                        )))),
            // Positioned(
            //     bottom: 10,
            //     left: 10,
            //     child: Container(
            //         padding: EdgeInsets.all(10),
            //         decoration: BoxDecoration(
            //             color: Theme.of(context).colorScheme.onSurface,
            //             border: Border.all(
            //                 color: Theme.of(context).colorScheme.primary,
            //                 width: 2),
            //             borderRadius: BorderRadius.circular(20)),
            //         child: Row(
            //           children: [
            //             SvgPicture.asset(
            //               WhiteIconConstant.salle,
            //               height: 20,
            //               width: 30,
            //             ),
            //             SizedBox(width: 10),
            //             Text(
            //               AppLocalizations.of(context)!.la_boutique,
            //               style: Theme.of(context)
            //                   .textTheme
            //                   .bodyMedium!
            //                   .copyWith(
            //                       color:
            //                           Theme.of(context).colorScheme.surface),
            //             )
            //           ],
            //         ))),
            // Positioned(
            //     bottom: 10,
            //     right: 10,
            //     child: Row(children: [
            //       Text(
            //         controller.userResp.value!.coins.toString(),
            //         style: Theme.of(context).textTheme.bodyMedium,
            //       ),
            //       SizedBox(width: 10),
            //       Mousquette(),
            //     ])),
          ],
        ));
  }
}

class ProjectHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Activity(context);
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  Widget Activity(BuildContext context) {
    return Container(
        child: Text(AppLocalizations.of(context)!.mes_projets,
            style: Theme.of(context).textTheme.titleLarge!));
  }
}
