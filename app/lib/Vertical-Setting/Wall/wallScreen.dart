import 'package:app/Vertical-Setting/Wall/wallController.dart';
import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/commentsWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/colorFilter/gradeSquareWidget.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:photo_view/photo_view.dart';

class VSWallScreen extends GetWidget<VSWallController> {
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
                              delegate: MyHeader(
                                  currentPage: controller.currentPage,
                                  changeIndex: controller.changeIndex),
                              pinned: true,
                              floating: true,
                            ),
                          ];
                        },
                        body: Container(
                            padding: EdgeInsets.only(left: 12, right: 12),
                            child: controller
                                .pages[controller.currentPage.value])),
                  ))));
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
                              child: Stack(children: [
                            PhotoView(
                                minScale: PhotoViewComputedScale.contained * 1,
                                maxScale: PhotoViewComputedScale.covered * 1.8,
                                imageProvider: CachedNetworkImageProvider(
                                    controller.wallResp!.secteurResp!.images![
                                        controller.currentPage.value])),
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
                          itemCount:
                              controller.wallResp!.secteurResp!.images!.length,
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
                                  .wallResp!.secteurResp!.images![index],
                            );
                          })),
                ),
                Positioned(
                    top: 5,
                    left: 5,
                    child: BackButtonWidget(
                      onPressed: () => controller.onBackPressed(),
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
                          itemCount: controller.wallResp!.attributes!.length,
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
                            return Text(controller.wallResp!.attributes![index],
                                style: Theme.of(context).textTheme.bodySmall);
                          }),
                    )),
                Positioned(
                    bottom: 10,
                    left: width * 0.5,
                    child: CirclePageIndicator(
                      dotColor: ColorsConstant.white.withOpacity(0.2),
                      selectedDotColor: Theme.of(context).colorScheme.surface,
                      itemCount:
                          controller.wallResp!.secteurResp!.images!.length,
                      currentPageNotifier: _currentPageNotifier,
                    )),
                Positioned(
                    bottom: 5,
                    right: 10,
                    child: GradeSquareWidget.fromGrade(
                        controller.wallResp!.grade!))
              ]),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            '${AppLocalizations.of(Get.context!)!.ouvreur} :',
                            style: Theme.of(context).textTheme.bodySmall,
                          )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            controller.wallResp!.routeSetterName == ""
                                ? AppLocalizations.of(Get.context!)!
                                    .pas_douvreur
                                : controller.wallResp!.routeSetterName!,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodySmall,
                          )),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            '${AppLocalizations.of(context)!.prises} :',
                            style: Theme.of(context).textTheme.bodySmall,
                          )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            controller.wallResp!.hold_to_take == "" ||
                                    controller.wallResp!.hold_to_take == null
                                ? AppLocalizations.of(context)!
                                    .prises_non_specifier
                                : controller.wallResp!.hold_to_take!,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodySmall,
                          )),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            '${AppLocalizations.of(context)!.description} :',
                            style: Theme.of(context).textTheme.bodySmall,
                          )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            controller.wallResp!.description == "" ||
                                    controller.wallResp!.description == null
                                ? AppLocalizations.of(context)!
                                    .pas_de_description
                                : controller.wallResp!.description!,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodySmall,
                          )),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            AppLocalizations.of(context)!
                                .cotation_des_utilisateurs,
                            style: Theme.of(context).textTheme.bodySmall,
                          )),
                      Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              for (var data in controller.dataMap.keys)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                        child: GradeSquareWidget.fromGrade(
                                      data,
                                    )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      controller.dataMap[data].toString() + '%',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    )
                                  ],
                                ),
                            ],
                          )),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline_outlined,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${controller.wallResp!.sentWalls!.length} ${AppLocalizations.of(context)!.personnes}',
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        ' ${AppLocalizations.of(context)!.ont_reussi_bloc}',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${controller.likes} ${AppLocalizations.of(context)!.personnes}',
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        ' ${AppLocalizations.of(context)!.ont_aime_le_bloc}',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
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
                              controller.secteurId,
                              controller.wallResp!.id!,
                              controller.comments.first.id!))),
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
                        AppLocalizations.of(context)!.voir_les_commentaires,
                        style: Theme.of(context).textTheme.bodyMedium,
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
                  controller.wallResp!.betaOuvreur == null
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
}

class MyHeader extends SliverPersistentHeaderDelegate {
  RxInt currentPage;
  void Function(int index) changeIndex;

  MyHeader({required this.currentPage, required this.changeIndex});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Activity(context);
  }

  @override
  double get maxExtent => 25;

  @override
  double get minExtent => 25;

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
        child: Text(
          AppLocalizations.of(context)!.autres_betas,
          style: Theme.of(context).textTheme.bodyMedium,
        ));
  }
}
