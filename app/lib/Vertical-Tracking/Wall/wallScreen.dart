import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/GenericContainer.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/commentsWidget.dart';
import 'package:app/widgets/loadingButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/Vertical-Tracking/Wall/wallController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/colorFilter/gradeSquareWidget.dart';
import 'package:app/widgets/profil/profilImage.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:photo_view/photo_view.dart';

class VTWallScreen extends GetWidget<VTWallController> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onPanEnd: (details) async {
          if (details.velocity.pixelsPerSecond.dx < 0) {
            controller.changeWallNext();
          } else {
            controller.changeWallBack();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          key: _scaffoldKey,
          body: SafeArea(
              child: Obx(() => controller.isLoading.value == false
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: height,
                      width: width,
                      child: NestedScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              SliverOverlapAbsorber(
                                  handle: NestedScrollView
                                      .sliverOverlapAbsorberHandleFor(context),
                                  sliver: SliverStickyHeader(
                                    header: middlePart(context),
                                  )),
                              SliverPersistentHeader(
                                delegate: VideoHeader(controller: controller),
                                pinned: true,
                                floating: true,
                              ),
                            ];
                          },
                          body: Container(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              child: controller.pages[0])),
                    ))),
          floatingActionButton: FloatingActionButton.small(
            onPressed: () => controller.onBackPressed(),
            backgroundColor: Colors.transparent,
            child: BackButtonWidget(),
          ),
        ));
  }

  Widget allLikeWidget(BuildContext context) {
    return InkWell(
        onTap: () => controller.onAllLikePressed(context),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          stackProfileWidget(
              context,
              controller.likes
                  .map((e) => e.user!.image == null ? "" : e.user!.image!)
                  .toList()),
          SizedBox(
              width: context.width * 0.8,
              child: Text(
                getLikeText(),
                style: Theme.of(context).textTheme.bodySmall!,
              )),
        ]));
  }

  Widget middlePart(BuildContext context) {
    return Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(children: [
                GestureDetector(
                  onTap: () async => (await showDialog(
                      context: context,
                      builder: ((context) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: Stack(children: [
                            PhotoView(
                              minScale: PhotoViewComputedScale.contained * 1,
                              maxScale: PhotoViewComputedScale.covered * 1.8,
                              basePosition: Alignment.center,
                              backgroundDecoration: const BoxDecoration(
                                  color: Colors.transparent),
                              imageProvider: CachedNetworkImageProvider(
                                controller.wallResp.value!.secteurResp!
                                    .images![_currentPageNotifier.value],
                              ),
                            ),
                            Positioned(
                                top: 10,
                                right: 10,
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          borderRadius:
                                              BorderRadius.circular(180)),
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: Icon(Icons.close,
                                          size: width * 0.04,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface)),
                                ))
                          ]))))),
                  child: Container(
                      height: context.height * 0.35,
                      width: width,
                      child: PageView.builder(
                          itemCount: controller
                              .wallResp.value!.secteurResp!.images!.length,
                          controller: controller.pageController,
                          onPageChanged: (int index) {
                            _currentPageNotifier.value = index;
                          },
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                backgroundColor:
                                    ColorsConstantDarkTheme.neutral_white,
                              )),
                              imageUrl: controller
                                  .wallResp.value!.secteurResp!.images![index],
                            );
                          })),
                ),
                Positioned(
                    bottom: 80,
                    left: 5,
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: width, maxHeight: 30),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20)),
                      padding:
                          EdgeInsets.only(left: 9, right: 9, top: 4, bottom: 4),
                      // color: Colors.black,
                      child: Text(
                        "${controller.wallResp.value!.points!.round()} ${AppLocalizations.of(context)!.points}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                Positioned(
                    bottom: 10,
                    left: width * 0.5,
                    child: CirclePageIndicator(
                      dotColor: ColorsConstant.white.withOpacity(0.2),
                      selectedDotColor: Theme.of(context).colorScheme.surface,
                      itemCount: controller
                          .wallResp.value!.secteurResp!.images!.length,
                      currentPageNotifier: _currentPageNotifier,
                    )),
                Positioned(
                    bottom: 5,
                    left: 5,
                    // height: 40,
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: width, maxHeight: 30),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.only(left: 9, right: 9, top: 9),
                      // color: Colors.black,
                      child: ListView.separated(
                          itemCount: controller.attributes.length,
                          separatorBuilder: (context, index) => Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Icon(
                                  Icons.circle,
                                  size: width * 0.005,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Text(controller.attributes[index],
                                style: Theme.of(context).textTheme.bodySmall);
                          }),
                    )),
                controller.wallResp.value!.hold_to_take != null &&
                        controller.wallResp.value!.hold_to_take != ""
                    ? Positioned(
                        bottom: 40,
                        left: 5,
                        // height: 40,
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: width, maxHeight: 30),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.only(
                              left: 9, right: 9, top: 9, bottom: 9),
                          // color: Colors.black,
                          child: Text(
                              "${AppLocalizations.of(context)!.prise}:  ${controller.wallResp.value!.hold_to_take}",
                              style: Theme.of(context).textTheme.bodySmall),
                        ))
                    : Container(),
                Positioned(
                    bottom: 5,
                    right: 10,
                    child: GradeSquareWidget.fromGrade(
                        controller.wallResp.value!.grade!))
              ]),
              Container(
                  margin: EdgeInsets.only(top: 20, left: 12, right: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(() => ValidateButtonLoading(
                            onDone: () => controller
                                .onMaBetaPressed(_scaffoldKey.currentContext!),
                            isDoneIcon: Icon(
                              Icons.check,
                              size: width * 0.04,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            controller: controller.loadingButtonController,
                            isDone: controller.isDone.value,
                            icon: Icon(
                              Icons.arrow_forward_rounded,
                              size: width * 0.04,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            onPressed: () {
                              controller.onSentWallPressed(
                                  _scaffoldKey.currentContext!);
                            })),
                        SizedBox(width: 10),
                        Expanded(
                            child: controller.isProject.value == false &&
                                    controller.isDone.value == false
                                ? ButtonWidget(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    onPressed: () => controller.saveProject(),
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .ajouter_un_projet,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  )
                                : controller.isDone.value == false
                                    ? ButtonWidget(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        onPressed: () =>
                                            controller.deleteProjectPopup(),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .deja_dans_vos_projets,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                      )
                                    : Container()),
                        SizedBox(width: 10),
                        ButtonWidget(
                            width: 40,
                            color: Theme.of(context).colorScheme.surface,
                            onPressed: () {
                              controller.avoidSpam.value == false
                                  ? controller
                                      .onLike(_scaffoldKey.currentContext!)
                                  : null;
                            },
                            child: controller.isLiked.value == false
                                ? Icon(
                                    Icons.favorite_border_rounded,
                                    color: ColorsConstantDarkTheme.secondary,
                                  )
                                : Icon(
                                    Icons.favorite_rounded,
                                    color: ColorsConstantDarkTheme.secondary,
                                  )),
                      ])),
              Container(
                  margin: EdgeInsets.only(top: 20, left: 12, right: 12),
                  child: allLikeWidget(_scaffoldKey.currentContext!)),
              Container(
                  margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                  child: InkWell(
                    onTap: () => controller.onUsersPressed(context),
                    child: Row(children: [
                      stackProfileWidget(
                          context,
                          controller.wallResp.value!.sentWalls
                              .map((e) =>
                                  (e.user != null && e.user!.image != null)
                                      ? e.user!.image!
                                      : "")
                              .toList()),
                      SizedBox(
                          width: context.width * 0.8,
                          child: Text(
                            getSentText(),
                            style: Theme.of(context).textTheme.bodySmall!,
                          )),
                    ]),
                  )),
              Container(
                  margin: EdgeInsets.only(top: 20, left: 12, right: 12),
                  child: Text(
                    controller.comments.isEmpty
                        ? AppLocalizations.of(context)!.pas_de_commentaire
                        : AppLocalizations.of(context)!.commentaires,
                    style: Theme.of(context).textTheme.bodyMedium!,
                  )),
              Container(
                margin: controller.comments.isEmpty
                    ? null
                    : EdgeInsets.only(top: 10, left: 12, right: 12),
                child: controller.comments.isEmpty
                    ? null
                    : CommentsWidget(
                        commentsResp: controller.comments.first,
                        ondelete: () => controller.delete(
                            controller.climbingLocationId,
                            controller.SecteurId,
                            controller.WallId,
                            controller.comments.first.id!)),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => controller
                      .onShowCommentairePressed(_scaffoldKey.currentContext!),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(180)),
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 12, right: 12),
                      child: Text(
                        controller.comments.isEmpty
                            ? AppLocalizations.of(context)!.ajouter_commentaire
                            : AppLocalizations.of(context)!
                                .voir_les_commentaires,
                      )),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 20,
                    left: 12,
                    right: 12,
                    bottom: controller.videoCapture == null ? 20 : 0),
                child: Text(
                  controller.wallResp.value!.betaOuvreur == null
                      ? AppLocalizations.of(context)!.pas_de_beta
                      : AppLocalizations.of(context)!.beta_des_ouvreurs,
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ),
              Flexible(
                  child: controller.videoCapture == null
                      ? SizedBox()
                      : Container(
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.only(
                              top: 10, left: 12, right: 12, bottom: 20),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8)),
                          constraints: BoxConstraints(
                              maxHeight: height * 0.1, maxWidth: width * 0.2),
                          child: controller.videoCapture)),
            ]));
  }

  String getLikeText() {
    switch (controller.likes.length) {
      case 0:
        return AppLocalizations.of(Get.context!)!.personne_aime;
      case 1:
        return '${controller.likes.first.user!.username} ${AppLocalizations.of(Get.context!)!.aime_ce_bloc}';
      case 2:
        return '${controller.likes.first.user!.username} ${AppLocalizations.of(Get.context!)!.et} ${controller.likes.last.user!.username} ${AppLocalizations.of(Get.context!)!.ont_aime_le_bloc}';
      default:
        return '${controller.likes.first.user!.username}, ${controller.likes[1].user!.username} ${AppLocalizations.of(Get.context!)!.et} ${controller.likes.length - 2} ${AppLocalizations.of(Get.context!)!.autres_personne_ont_aimer}';
    }
  }

  String getSentText() {
    if (controller.wallResp.value!.sentWalls!.isNotEmpty &&
        controller.wallResp.value!.sentWalls!.last.user != null) {
      switch (controller.wallResp.value!.sentWalls!.length) {
        case 0:
          return AppLocalizations.of(Get.context!)!.personne_reussi;
        case 1:
          return '${controller.wallResp.value!.sentWalls!.first.user!.username} ${AppLocalizations.of(Get.context!)!.reussi_ce_bloc}';
        case 2:
          return '${controller.wallResp.value!.sentWalls!.first.user!.username} ${AppLocalizations.of(Get.context!)!.et} ${controller.wallResp.value!.sentWalls!.last.user!.username} ${AppLocalizations.of(Get.context!)!.ont_reussi_bloc}';
        default:
          return '${controller.wallResp.value!.sentWalls!.first.user!.username}, ${controller.wallResp.value!.sentWalls![1].user!.username} ${AppLocalizations.of(Get.context!)!.et} ${controller.wallResp.value!.sentWalls!.length - 2} ${AppLocalizations.of(Get.context!)!.autres_personne_ont_reussi}';
      }
    } else {
      return AppLocalizations.of(Get.context!)!.personne_reussi;
    }
  }

  Widget stackProfileWidget(BuildContext context, List<String> images) {
    switch (images.length) {
      case 0:
        return SizedBox(
          width: 36,
        );
      case 1:
        return Container(
            height: 24,
            width: 36,
            // color: ColorsConstant.redAction,
            alignment: Alignment.centerLeft,
            child: profileImage(
              image: images.first,
            ));

      default:
        return Container(
            width: 36,
            height: 22,
            // color: ColorsConstant.redAction,
            child: Stack(
              children: [
                Positioned(
                    left: 8,
                    child: profileImage(
                      image: images[1],
                    )),
                profileImage(
                  image: images[0],
                ),
              ],
            ));
    }
  }
}

class VideoHeader extends SliverPersistentHeaderDelegate {
  late VTWallController controller;

  VideoHeader({required this.controller}) {}

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Activity(context);
  }

  @override
  double get maxExtent => 35;

  @override
  double get minExtent => 35;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

  Widget Activity(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.only(left: 12, right: 12),
        alignment: Alignment.topLeft,
        child: Row(children: [
          Text(
            AppLocalizations.of(Get.context!)!.autres_betas,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Spacer(),
          Flexible(
              flex: 2,
              child: ButtonWidget(
                  color: Theme.of(context).colorScheme.surface,
                  onPressed: () => controller.isDone.value
                      ? controller.onMaBetaPressed(context)
                      : controller.onSentWallPressed(context),
                  child: Text(
                    AppLocalizations.of(Get.context!)!.ajouter_une_video,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )))
        ]));
  }
}
