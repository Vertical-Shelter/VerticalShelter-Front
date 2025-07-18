import 'package:app/Vertical-Tracking/Gyms/gymsController.dart';
import 'package:app/Vertical-Tracking/SprayWall/sprayWallController.dart';
import 'package:app/data/models/grade/gradeResp.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/GenericContainer.dart';
import 'package:app/widgets/commentsWidget.dart';
import 'package:app/widgets/loadingButton.dart';
import 'package:app/widgets/walls/sprayWallImage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/Vertical-Tracking/Wall/wallController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/colorFilter/gradeSquareWidget.dart';
import 'package:app/widgets/profil/profilImage.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:photo_view/photo_view.dart';

class SprayWallDetailScreen extends GetWidget<SprayWallDetailController> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
    );
  }

  Widget gradeWidget() {
    //find the corresponding grade in the grade system of the gym
    GradeResp? grade = Get.find<ClimbingLocationController>()
        .climbingLocationResp!
        .gradeSystem!
        .firstWhereOrNull(
            (element) => element.id == controller.wallResp.value!.gradeId);
    return GradeSquareWidget.fromGrade(grade!);
  }

  Widget allLikeWidget(BuildContext context) {
    return InkWell(
        onTap: () => controller.onAllLikePressed(context),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          stackProfileWidget(
              context,
              controller.wallResp.value!.likes
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
                Spraywallimage(
                  height: context.height * 0.5,
                  width: width,
                  annotations: controller.sprayWallResp.value!.annotations!,
                  image: controller.image.value!,
                  points: controller.wallResp.value!.holds,
                ),
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
                          itemCount:
                              controller.wallResp.value!.attributes!.length,
                          separatorBuilder: (context, index) => Container(
                                margin: EdgeInsets.only(left: 5, right: 5),
                                child: Icon(
                                  Icons.circle,
                                  size: 2,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Text(
                                controller.wallResp.value!.attributes![index],
                                style: Theme.of(context).textTheme.bodySmall);
                          }),
                    )),
                Positioned(bottom: 5, right: 10, child: gradeWidget()),
                Positioned(
                    bottom: 5,
                    right: 50,
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
                            controller.wallResp.value!.equivalentExte ?? '',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall))),
                Positioned(
                    bottom: 40,
                    right: 15,
                    child: Icon(
                      Icons.pinch_outlined,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
              ]),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(context, Theme.of(context).colorScheme.tertiary,
                      AppLocalizations.of(context)!.prise_de_main),
                  CustomText(context, ColorsConstantDarkTheme.secondary,
                      AppLocalizations.of(context)!.prise_de_pied),
                  CustomText(context, ColorsConstantDarkTheme.primary,
                      AppLocalizations.of(context)!.prise_de_start_fin),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Container(
                  margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                  child: Row(children: [
                    Expanded(
                        flex: 4,
                        child: Text(controller.wallResp.value!.name ?? "",
                            style: Theme.of(context).textTheme.titleLarge)),
                    Spacer(),
                    Text(
                      "${AppLocalizations.of(context)!.ouvert_par}: ${controller.wallResp.value!.routeSetter!.username}",
                    )
                  ])),
              Container(
                  margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                  child: Row(children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          controller.wallResp.value!.description ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontStyle: FontStyle.italic),
                        )),
                    Spacer(),
                    Text(
                        "${AppLocalizations.of(context)!.cotation_communautaire}: ${controller.wallResp.value!.equivalentExteMean ?? controller.wallResp.value!.equivalentExte}",
                        style: Theme.of(context).textTheme.bodySmall),
                  ])),
              Container(
                  margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                  child: Row(children: [
                    Text(controller.wallResp.value!.name ?? "",
                        style: Theme.of(context).textTheme.titleLarge),
                    Spacer(),
                    Text(
                        "${AppLocalizations.of(context)!.cotation_communautaire}: ${controller.wallResp.value!.equivalentExteMean ?? controller.wallResp.value!.equivalentExte}",
                        style: Theme.of(context).textTheme.bodySmall),
                  ])),
              Container(
                  margin: EdgeInsets.only(top: 20, left: 12, right: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        controller.isProject.value == false &&
                                controller.isDone.value == false
                            ? GenericContainer(
                                boxDecoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(180)),
                                child: InkWell(
                                  onTap: () => controller.saveProject(),
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .ajouter_un_projet,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface)),
                                ))
                            : controller.isDone.value == false
                                ? GenericContainer(
                                    boxDecoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius:
                                            BorderRadius.circular(180)),
                                    child: InkWell(
                                      onTap: () =>
                                          controller.deleteProjectPopup(),
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .deja_dans_vos_projets,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background)),
                                    ))
                                : Container(),
                        Container(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(800)),
                            child: InkWell(
                                onTap: () {
                                  controller.avoidSpam.value == false
                                      ? controller
                                          .onLike(_scaffoldKey.currentContext!)
                                      : null;
                                },
                                child: controller.isLiked.value == false
                                    ? Icon(
                                        Icons.favorite_border_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: width * 0.05,
                                      )
                                    : Icon(
                                        Icons.favorite_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: width * 0.05,
                                      ))),
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
                                  e.user!.image != null ? e.user!.image! : "")
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
                    controller.wallResp.value!.comments.isEmpty
                        ? AppLocalizations.of(context)!.pas_de_commentaire
                        : AppLocalizations.of(context)!.commentaires,
                    style: Theme.of(context).textTheme.bodyMedium!,
                  )),
              Container(
                margin: controller.wallResp.value!.comments.isEmpty
                    ? null
                    : EdgeInsets.only(top: 10, left: 12, right: 12),
                child: controller.wallResp.value!.comments.isEmpty
                    ? null
                    : CommentsWidget(
                        commentsResp: controller.wallResp.value!.comments.first,
                        ondelete: () => controller.delete(
                            controller.ClimbingId,
                            controller.SprayWallId,
                            controller.WallId,
                            controller.wallResp.value!.comments.first.id!)),
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
                        controller.wallResp.value!.comments.isEmpty
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
                  child: Obx(() => controller.videoCapture == null &&
                          controller.thumbnailUrl.value == null
                      ? Container()
                      : Container(
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.only(
                              top: 10, left: 12, right: 12, bottom: 20),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8)),
                          constraints: BoxConstraints(
                              maxHeight: height * 0.1, maxWidth: width * 0.2),
                          child: controller.thumbnailUrl.value != null
                              ? GestureDetector(
                                  onTap: () => controller.launchURLTest(
                                      controller.wallResp.value!.betaOuvreur!),
                                  child: controller
                                          .thumbnailUrl.value!.isNotEmpty
                                      ? Image.network(
                                          controller.thumbnailUrl.value!,
                                          fit: BoxFit.fitHeight,
                                        )
                                      : Center(
                                          child: CircularProgressIndicator()),
                                )
                              : controller.videoCapture!))),
            ]));
  }

  String getLikeText() {
    switch (controller.wallResp.value!.likes.length) {
      case 0:
        return AppLocalizations.of(Get.context!)!.personne_aime;
      case 1:
        return '${controller.wallResp.value!.likes.first.user!.username} ${AppLocalizations.of(Get.context!)!.aime_ce_bloc}';
      case 2:
        return '${controller.wallResp.value!.likes.first.user!.username} ${AppLocalizations.of(Get.context!)!.et} ${controller.wallResp.value!.likes.last.user!.username} ${AppLocalizations.of(Get.context!)!.ont_aime_le_bloc}';
      default:
        return '${controller.wallResp.value!.likes.first.user!.username}, ${controller.wallResp.value!.likes[1].user!.username} ${AppLocalizations.of(Get.context!)!.et} ${controller.wallResp.value!.likes.length - 2} ${AppLocalizations.of(Get.context!)!.autres_personne_ont_aimer}';
    }
  }

  String getSentText() {
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

  Widget CustomText(BuildContext context, Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          margin: EdgeInsets.only(left: 10),
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.5)),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class VideoHeader extends SliverPersistentHeaderDelegate {
  late SprayWallDetailController controller;

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
        width: double.infinity,
        child: Row(children: [
          Text(
            AppLocalizations.of(Get.context!)!.autres_betas,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Spacer(),
          InkWell(
              onTap: () => controller.isDone.value
                  ? controller.onMaBetaPressed(context)
                  : controller.onSentWallPressed(context),
              child: Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2),
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(180)),
                  child: Text(
                    AppLocalizations.of(Get.context!)!.ajouter_une_video,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )))
        ]));
  }
}
