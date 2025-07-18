import 'package:app/Vertical-Tracking/contest/ContestFile/contestFileController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/BackButton.dart';
import 'package:app/widgets/blocCard.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/profil/profilImage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class ContestFile extends GetWidget<ContestFileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: PopScope(
                onPopInvokedWithResult: (didPop, result) =>
                    controller.onBackPressed(),
                child: Obx(() => controller.isLoading.value == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: Obx(() => switchBuild(context)))))));
  }

  Widget switchBuild(BuildContext context) {
    switch (controller.contestResp.value.etat) {
      case 0:
        if (controller.contestResp.value.isSubscribed == false) {
          return beforeContestStart(context);
        } else if (controller.contestResp.value.qrCodeScanned == false) {
          return contestStartButNoScanQrCode(context);
        } else {
          return buildBloc(context);
        }
      case 1:
        return contestDone(context);
      default:
        return beforeContestStart(context);
    }
  }

  Widget beforeContestStart(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
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
                          backgroundDecoration:
                              const BoxDecoration(color: Colors.transparent),
                          imageProvider: CachedNetworkImageProvider(
                              controller.contestResp!.value.imageUrl!),
                        ),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(180)),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  child: Icon(Icons.close,
                                      size: width * 0.04,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
                            ))
                      ]))))),
              child: Container(
                  height: context.height * 0.4,
                  width: width,
                  child: CachedNetworkImage(
                    imageUrl: controller.contestResp!.value.imageUrl!,
                    fit: BoxFit.cover,
                  )),
            ),
            Positioned(
                top: 5,
                left: 5,
                child: BackButtonWidget(
                  onPressed: () => controller.onBackPressed(),
                )),
            Positioned(
                bottom: 45,
                left: 5,
                child: Container(
                    constraints: BoxConstraints(maxWidth: width),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.only(
                        left: 9, right: 9, top: 9, bottom: 9),
                    // color: Colors.black,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            "${controller.dayOfWeek.value} ${controller.dayMonth.value}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                      ],
                    ))),
            Positioned(
                bottom: 5,
                left: 5,
                // height: 40,
                child: Row(children: [
                  Container(
                      constraints: BoxConstraints(maxWidth: width),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.only(
                          left: 9, right: 9, top: 9, bottom: 9),
                      // color: Colors.black,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "${AppLocalizations.of(context)!.prix_abonnee} ${controller.contestResp.value.priceA} ${AppLocalizations.of(context)!.monnaie_symbole}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
                        ],
                      )),
                  const SizedBox(width: 5),
                  Container(
                      constraints: BoxConstraints(maxWidth: width),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.only(
                          left: 9, right: 9, top: 9, bottom: 9),
                      // color: Colors.black,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "${AppLocalizations.of(context)!.prix_non_abonnee} ${controller.contestResp.value.priceE} ${AppLocalizations.of(context)!.monnaie_symbole}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
                        ],
                      ))
                ])),
          ]),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              controller.contestResp.value.title!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 30),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              controller.contestResp.value.description!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 30),
          listInscriptionWidget(context),
          const SizedBox(height: 30),
          Obx(() => controller.contestResp.value.isSubscribed == false
              ? ButtonWidget(
                  onPressed: () => controller.subscribe(context),
                  child: Text(
                    AppLocalizations.of(context)!.s_inscrire,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.surface),
                  ))
              : ButtonWidget(
                  onPressed: () => controller.unSubscribe(),
                  child: Text(
                    AppLocalizations.of(context)!.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.surface),
                  ))),
          const SizedBox(height: 10)
        ]));
  }

  Widget contestStartButNoScanQrCode(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
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
                          backgroundDecoration:
                              const BoxDecoration(color: Colors.transparent),
                          imageProvider: CachedNetworkImageProvider(
                              controller.contestResp!.value.imageUrl!),
                        ),
                        Positioned(
                            top: 10,
                            right: 10,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(180)),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
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
                  child: CachedNetworkImage(
                    imageUrl: controller.contestResp!.value.imageUrl!,
                    fit: BoxFit.cover,
                  )),
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
                child: Row(children: [
                  Container(
                      constraints: BoxConstraints(maxWidth: width),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.only(
                          left: 9, right: 9, top: 9, bottom: 9),
                      // color: Colors.black,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "${controller.dayOfWeek.value} ${controller.dayMonth.value}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
                        ],
                      )),
                  const SizedBox(width: 5),
                  Container(
                      constraints: BoxConstraints(maxWidth: width),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.only(
                          left: 9, right: 9, top: 9, bottom: 9),
                      // color: Colors.black,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "${AppLocalizations.of(context)!.prix_abonnee} ${controller.contestResp.value.priceA} ${AppLocalizations.of(context)!.monnaie_symbole}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
                        ],
                      )),
                  const SizedBox(width: 5),
                  Container(
                      constraints: BoxConstraints(maxWidth: width),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.only(
                          left: 9, right: 9, top: 9, bottom: 9),
                      // color: Colors.black,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "${AppLocalizations.of(context)!.prix_abonnee} ${controller.contestResp.value.priceA} ${AppLocalizations.of(context)!.monnaie_symbole}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
                        ],
                      ))
                ])),
          ]),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              controller.contestResp.value.title!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 30),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(controller.contestResp.value.description!),
          ),
          const SizedBox(height: 30),
          listInscriptionWidget(context),
          const SizedBox(height: 30),
          ButtonWidget(
              onPressed: () => controller.scanQR(),
              child: Text(
                AppLocalizations.of(context)!.scan_qr_code,
                style: Theme.of(context).textTheme.bodyMedium!,
              )),
        ]));
  }

  Widget contestDone(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
          SizedBox(
              height: 140,
              width: width,
              child: Stack(children: [
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
                                  controller.contestResp!.value.imageUrl!),
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
                      height: 140,
                      width: width,
                      child: CachedNetworkImage(
                        imageUrl: controller.contestResp!.value.imageUrl!,
                        fit: BoxFit.cover,
                      )),
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
                    child: Row(children: [
                      Container(
                          constraints: BoxConstraints(maxWidth: width),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.only(
                              left: 9, right: 9, top: 9, bottom: 9),
                          // color: Colors.black,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "${controller.dayOfWeek.value} ${controller.dayMonth.value}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface)),
                            ],
                          )),
                    ])),
              ])),
          const SizedBox(height: 10),
          Row(children: [
            const SizedBox(width: 5),
            Container(
                constraints: BoxConstraints(maxWidth: width),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.only(left: 9, right: 9, top: 9, bottom: 9),
                // color: Colors.black,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "${AppLocalizations.of(context)!.prix_abonnee} ${controller.contestResp.value.priceA} ${AppLocalizations.of(context)!.monnaie_symbole}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                  ],
                )),
            const SizedBox(width: 5),
            Container(
                constraints: BoxConstraints(maxWidth: width),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.only(left: 9, right: 9, top: 9, bottom: 9),
                // color: Colors.black,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "${AppLocalizations.of(context)!.prix_non_abonnee} ${controller.contestResp.value.priceE} ${AppLocalizations.of(context)!.monnaie_symbole}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ))
          ]),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              controller.contestResp.value.title!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 30),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(controller.contestResp.value.description!),
          ),
          const SizedBox(height: 80),
          ButtonWidget(
              onPressed: () => controller.onRankingPress(context),
              child: Text(
                AppLocalizations.of(context)!.voir_resultats,
                style: Theme.of(context).textTheme.bodyMedium!,
              )),
          const SizedBox(height: 10)
        ]));
  }

  Widget buildBloc(BuildContext context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BackButtonWidget(
              onPressed: () => controller.onBackPressed(),
            ),
            const Spacer(),
            Text(
              controller.contestResp.value.title!,
              style: Theme.of(context).textTheme.titleMedium!,
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 20),
        InkWell(
            onTap: () => controller.onRankingPress(context),
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.twenty_one_mp_outlined,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.classement,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.surface),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 10),
        Obx(() => Flexible(
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: controller.blocCardList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5),
                itemBuilder: (context, index) {
                  return controller.blocCardList[index];
                }))),
        const SizedBox(height: 20),
      ]),
      Positioned(
          child: SizedBox(
              width: 100,
              child: FloatingActionButton(
                onPressed: () {
                  controller.onDone(context);
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(AppLocalizations.of(context)!.valider,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.surface)),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(Icons.save)
                ]),
              )))
    ]);
  }

  Widget listInscriptionWidget(BuildContext context) {
    return InkWell(
        onTap: () => controller.onListInscriptionPress(context),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              stackProfileWidget(
                  context,
                  controller.contestResp.value!.inscription
                      .map((e) => e.user!.image == null ? "" : e.user!.image!)
                      .toList()),
              Flexible(
                  child: Text(
                getListTest(),
                style: Theme.of(context).textTheme.bodySmall!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
            ]));
  }

  String getListTest() {
    switch (controller.contestResp.value.inscription.length) {
      case 0:
        return AppLocalizations.of(Get.context!)!.personne_est_inscrit;
      case 1:
        return '${controller.contestResp.value.inscription.first.user!.username} ${AppLocalizations.of(Get.context!)!.est_inscrit}';
      case 2:
        return '${controller.contestResp.value.inscription.first.user!.username} ${AppLocalizations.of(Get.context!)!.et} ${controller.contestResp.value.inscription.last.user!.username} ${AppLocalizations.of(Get.context!)!.sont_inscrits}';
      default:
        return '${controller.contestResp.value.inscription.first.user!.username}, ${controller.contestResp.value.inscription[1].user!.username} ${AppLocalizations.of(Get.context!)!.et} ${controller.contestResp.value.inscription.length - 2} ${AppLocalizations.of(Get.context!)!.sont_inscrits}';
    }
  }

  Widget stackProfileWidget(BuildContext context, List<String> images) {
    switch (images.length) {
      case 0:
        return const SizedBox(
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
                    left: 10,
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
