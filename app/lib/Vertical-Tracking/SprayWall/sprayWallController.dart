import 'dart:async';
import 'dart:io';

import 'package:app/data/models/SprayWall/sprayWallResp.dart';
import 'package:app/utils/projectController.dart';
import 'package:app/utils/sprayWallController.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widgets/WallBeta/WallBetaController.dart';
import 'package:app/widgets/WallBeta/WallBetaScreen.dart';
import 'package:app/Vertical-Tracking/profil/profil_controller.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/Comments/commentsApi.dart';
import 'package:app/data/models/Comments/commentsReq.dart';
import 'package:app/data/models/Comments/commentsResp.dart';
import 'package:app/data/models/Likes/likeApi.dart';
import 'package:app/data/models/Likes/likeResp.dart';
import 'package:app/data/models/SentWall/sentWallResp.dart';
import 'package:app/data/models/SentWall/sentWall_api.dart';
import 'package:app/data/models/SprayWall/sprayWallApi.dart';
import 'package:app/data/models/User/projet/api.dart';
import 'package:app/data/models/User/projet/projectReq.dart';
import 'package:app/data/models/User/projet/projetResp.dart';
import 'package:app/data/models/User/skills_resp.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/ConfirmDialog.dart';
import 'package:app/widgets/commentsWidget.dart';
import 'package:app/widgets/loadingButton.dart';
import 'package:app/widgets/mentionTextField.dart';
import 'package:app/widgets/profil/profilImage.dart';
import 'package:app/widgets/profil/profilMinivertical.dart';
import 'package:app/widgets/sentWalls/sentWallCreateWidget.dart';
import 'package:app/widgets/sentWalls/sentWallEditWidget.dart';
import 'package:app/widgets/vid%C3%A9oCapture.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_editor/image_editor.dart';
import 'package:app/widgets/shareToInstagram.dart';
import 'dart:ui' as ui;

class SprayWallDetailController extends GetxController {
  PageController pageController = PageController();
  Rxn<WallResp> wallResp = Rxn();
  Rx<SentWallResp?> sentWallResp = Rx<SentWallResp?>(null);
  LoadingButtonController loadingButtonController = LoadingButtonController();
  SprayWallController sprayWallController = Get.find<SprayWallController>();

  RxBool isLoading = false.obs;
  RxBool isDone = false.obs;
  RxBool isLiked = false.obs;
  RxBool isProject = false.obs;

  List<SkillResp> currentSkills = <SkillResp>[];
  RxBool avoidSpam = false.obs;

  String ClimbingId = '';
  String SprayWallId = '';
  String WallId = '';

  TextEditingController commentController = TextEditingController();
  RxBool isLoad = false.obs;
  String userImage = "";

  //initial status
  bool isInitialLiked = false;
  bool isInitialDone = false;
  bool isNext = false;

  Rxn<SprayWallResp> sprayWallResp = Rxn<SprayWallResp>();

  Rxn<ui.Image> image = Rxn<ui.Image>();

  VideoCapture? videoCapture;
  Account userAccount = Get.find<MultiAccountManagement>().actifAccount!;
  List pages = [Get.put(WallBetaScreen())];

  WallBetaController wallBetaController = Get.find<WallBetaController>();

  ProjetController projetController = Get.find<ProjetController>();
  @override
  void onReady() {
    _init();
    super.onReady();
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final optionGroup = ImageEditorOption();
    //reduce the size of the image

    //Get the size of the image
    final uint8List = byteData.buffer.asUint8List();
    final result = await ImageEditor.editImage(
        image: uint8List, imageEditorOption: optionGroup);
    var tempDir = await getTemporaryDirectory();
    var filePath = '${tempDir.path}/logo.jpg';
    var file = File(filePath);
    await file.writeAsBytes(result!);
    return file;
  }

  Future<void> saveProject() async {
    if (userAccount.isGym) {
      Get.snackbar("Attention",
          "Connectez-vous en tant que grimpeur pour ajouter un bloc aux projets",
          snackPosition: SnackPosition.TOP);
      return;
    }

    ProjectReq projectReq = ProjectReq(
        wall_id: wallResp.value!.id!,
        climbingLocation_id: ClimbingId,
        secteur_id: SprayWallId,
        isSprayWall: true);
    try {
      postProject(projectReq).then((value) async {
        value.image =
            await loadNetworkImage(value.wall!.secteurResp!.images.first);
        projetController.projetList.add(value);
        projetController.projetList.refresh();
      });
      isProject.value = true;
      isProject.refresh();
    } catch (e) {
      Get.snackbar(AppLocalizations.of(Get.context!)!.erreur,
          AppLocalizations.of(Get.context!)!.une_erreur_est_survenue,
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  void onClose() {
    videoCapture?.controller?.dispose();

    super.onClose();
  }

  void onBackPressed() async {
    Get.back();
  }

  void onLike(BuildContext context) async {
    // Si on spam y a un probleme
    avoidSpam.value = true;
    avoidSpam.refresh();
    if (!isLiked.value) {
      UserMinimalResp user = UserMinimalResp(
        id: userAccount.id,
        username: userAccount.name,
        image: userAccount.picture,
      );
      LikeResp like = await postSprayWallLike(
          climbingLocationId: ClimbingId,
          sprayWallId: SprayWallId,
          wallId: WallId);
      wallResp.value!.likes.add(like);
    } else {
      deleteSprayWallLike(
          climbingLocationId: ClimbingId,
          sprayWallId: SprayWallId,
          wallId: WallId,
          likeId: wallResp.value!.likes
              .firstWhere((element) => element.user!.id == userAccount.id)
              .id!);
      wallResp.value!.likes
          .removeWhere((element) => element.user!.id == userAccount.id);
    }
    isLiked.value = !isLiked.value;
    isLiked.refresh();
    avoidSpam.value = false;
    avoidSpam.refresh();
  }

  void deleteProjectPopup() {
    //First show disclaimer popup
    showDialog(
        context: Get.context!,
        builder: (context) => ConfirmDialog(
              // title: AppLocalizations.of(Get.context!)!.supprimer_le_projet,
              // mainText: AppLocalizations.of(Get.context!)!
              //     .etes_vous_sur_de_vouloir_supprimer_le_projet,
              title: AppLocalizations.of(Get.context!)!.supprimer_projet,
              mainText:
                  AppLocalizations.of(Get.context!)!.confirmer_supprimer_projet,
              onConfirm: (context) async {
                try {
                  ProjetResp? id = projetController.projetList.firstWhereOrNull(
                      (element) => element.wall!.id == WallId);
                  while (id == null) {
                    await Future.delayed(1.seconds);
                    id = projetController.projetList.firstWhereOrNull(
                        (element) => element.wall!.id == WallId);
                  }
                  String projectID = projetController.projetList
                      .firstWhere((element) => element.wall!.id == WallId)
                      .id!;
                  deleteProject(projectID);
                  projetController.projetList
                      .removeWhere((element) => element.wall!.id == WallId);
                  projetController.projetList.refresh();
                  isProject.value = false;
                  isProject.refresh();

                  Get.back();
                } catch (e) {
                  Get.snackbar(
                      AppLocalizations.of(Get.context!)!.erreur,
                      AppLocalizations.of(Get.context!)!
                          .une_erreur_est_survenue,
                      snackPosition: SnackPosition.TOP);
                }
              },
            ));
  }

  void _init() async {
    ClimbingId = Get.parameters['ClimbingId']!;
    SprayWallId = Get.parameters['SprayWallId']!;
    WallId = Get.parameters['WallId']!;
    sprayWallResp.value = Get.arguments['sprayWallResp']!;
    image.value = await loadNetworkImage(sprayWallResp.value!.image!);
    await getWall(WallId, ClimbingId, SprayWallId);

    isProject.value = projetController.projetList
        .any((element) => element.wall!.id == WallId);

    isProject.refresh();

    isLoading.value = true;
    isLoading.refresh();
  }

  void onSentWallPressed(BuildContext context) async {
    if (userAccount.isGym) {
      Get.snackbar("Attention",
          "Connectez-vous en tant que grimpeur pour réaliser un bloc",
          snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      // ignore: use_build_context_synchronously
      var isSent = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (context) => SentWallWidget(
              isSprayWall: true,
              wallId: wallResp.value!.id!,
              cimbingLocationId: ClimbingId,
              secteurId: SprayWallId,
              onSentWallEdit: (value) {
                if (kDebugMode) {
                  print("the end");
                }
                wallResp.value!.sentWalls.add(value);
                sprayWallController.allWalls
                    .firstWhere((element) => element.id == WallId)
                    .sentWalls
                    .add(value);
                sprayWallController.allWalls
                    .firstWhere((element) => element.id == WallId)
                    .isDone = true;
                if (isProject.value) {
                  projetController.projetList
                      .removeWhere((element) => element.wall!.id == WallId);
                  isProject.value = false;
                }
                wallBetaController.users.refresh();

                sprayWallController.filterWall({});

                sentWallResp.value = value;
                isDone.value = true;
                // updateApp();
                loadingButtonController.isLoading.value = false;
              },
              onError: () {
                loadingButtonController.isLoading.value = false;
                Get.showSnackbar(GetSnackBar(
                  message:
                      AppLocalizations.of(context)!.une_erreur_est_survenue,
                  duration: 3.seconds,
                  snackPosition: SnackPosition.BOTTOM,
                ));
              }));
      if (isSent != null) {
        //Show popups to confirm gain point of skills

        loadingButtonController.onLoading();
      }
      // updateApp();
    } on Exception {}
  }

  Future<void> getWall(
      String wallId, String ClimbingId, String sprayWallId) async {
    wallResp.value = (await get_sprayWall_Wall(
        wallId: WallId,
        climbingLocationId: ClimbingId,
        sprayWallId: sprayWallId)); //la gueule de la fonctoin

    wallResp.value!.sentWalls.sort((a, b) => a.date!.compareTo(b.date!));

    isLiked.value = wallResp.value!.likes.any((element) =>
        element.user!.id == userAccount.id); //la gueule de la fonctoin
    await initVideo();

    wallResp.value!.sentWalls!.sort((a, b) => a.date!.compareTo(b.date!));
    // (pages[0] as WallBetaScreen).controller.users.value = wallResp!.users!;
    SentWallResp? myBeta = wallResp.value!.sentWalls
        .firstWhereOrNull(((element) => element.user!.id == userAccount.id));
    if (myBeta != null) {
      isDone.value = true;
      isInitialDone = true;
      sentWallResp.value = myBeta;
    }
    wallBetaController.updateValues(wallResp.value!.sentWalls!);
    // listComments(wallId, ClimbingId, SecteurId);
  }

  void onUsersPressed(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => Container(
            width: context.width,
            height: context.height * 0.5,
            padding: const EdgeInsets.only(left: 25, right: 25),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Theme.of(context).colorScheme.surface),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                  height: height * 0.01,
                  width: width * 0.3,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              Text(AppLocalizations.of(Get.context!)!.realise_par,
                  style: Theme.of(context).textTheme.titleLarge!),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: wallResp.value!.sentWalls.length != 0
                      ? ListView.builder(
                          itemCount: wallResp.value!.sentWalls.length,
                          itemBuilder: (context, index) => Row(
                                children: [
                                  Text(
                                    "${index + 1}",
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  fromUserMini(context,
                                      wallResp.value!.sentWalls[index].user),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                  Text(
                                    wallResp.value!.sentWalls[index]
                                                .nTentative ==
                                            1
                                        ? AppLocalizations.of(Get.context!)!
                                            .flash
                                        : "${wallResp.value!.sentWalls[index].nTentative} ${AppLocalizations.of(context)!.essais}",
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                ],
                              ))
                      : Center(
                          child: Text(
                          AppLocalizations.of(context)!
                              .aucun_utilisateur_a_realiser_ce_bloc,
                        ))),
            ])));
  }

  RxnString thumbnailUrl = RxnString();

  bool _isValidInstagramUrl(String url) {
    // Vérifie que l'URL commence par https://www.instagram.com/
    final instagramRegex = RegExp(r"^(https?:\/\/)?(www\.)?instagram\.com\/");
    return instagramRegex.hasMatch(url);
  }

  Future<void> launchURLTest(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Impossible d\'ouvrir l\'URL : $url';
    }
  }

  Future<void> initVideo() async {
    String? instagramUrl = wallResp.value!.betaOuvreur;
    if (instagramUrl == null) {
      return;
    }
    var data = await MetadataFetch.extract(instagramUrl);
    if (data != null &&
        data.image != null &&
        data.image!.isNotEmpty &&
        _isValidInstagramUrl(instagramUrl)) {
      thumbnailUrl.value = data.image!;
      thumbnailUrl.refresh();
    } else {
      videoCapture = VideoCapture(
        'edit',
        controller: VideoPlayerController.networkUrl(
          Uri.parse(wallResp.value!.betaOuvreur!),
        ),
        isReadOnly: true,
      );
    }
  }

  /// Play the video
  void onPlayBeta(BuildContext context) async {
    if (wallResp.value!.betaOuvreur != null) {
      videoCapture = VideoCapture(
        'edit',
        controller: VideoPlayerController.networkUrl(
          Uri.parse(wallResp.value!.betaOuvreur!),
        ),
        isReadOnly: true,
      );
    }
    if (videoCapture != null) {
      await initVideo();
      videoCapture!.controller!.play();
      await showDialog(
          context: context,
          builder: (context) => Dialog(
                insetPadding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.08,
                    vertical: context.height * 0.1),
                backgroundColor: ColorsConstant.white,
                surfaceTintColor: ColorsConstant.white,

                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: videoCapture!,
              ));
    } else {
      Get.snackbar(AppLocalizations.of(context)!.pas_de_video,
          AppLocalizations.of(context)!.il_ny_a_pas_de_video_pour_ce_bloc);
    }
  }

  void onMaBetaPressed(BuildContext context) async {
    print('on my beta press');
    if (isDone.value) {
      await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (context) => SentWallEditWidget(
              isSprayWall: true,
              wallId: wallResp.value!.id!,
              cimbingLocationId: ClimbingId,
              secteurId: SprayWallId,
              onUnsent: () async {
                await showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                        title: AppLocalizations.of(context)!
                            .annuler_la_realisation,
                        mainText: AppLocalizations.of(context)!
                            .etes_vous_sur_de_vouloir_annuler_la_realisation,
                        onConfirm: (context) async {
                          await deleteSprayWallSent(
                            ClimbingId,
                            SprayWallId,
                            WallId,
                          );
                          wallResp.value!.sentWalls.removeWhere(
                              (element) => element.user!.id == userAccount.id);
                          wallBetaController.users.removeWhere(
                              (element) => element.id == userAccount.id);
                          sprayWallController.allWalls
                              .firstWhere((element) => element.id == WallId)
                              .sentWalls
                              .removeWhere((element) =>
                                  element.id == sentWallResp.value!.id!);
                          sprayWallController.allWalls
                              .firstWhere((element) => element.id == WallId)
                              .isDone = false;
                          sprayWallController.filterWall({});
                          wallResp.refresh();
                          Get.back();
                          Get.back();

                          isDone.value = false;
                          // updateApp();
                        }));
              },
              sentWallResp: sentWallResp.value!,
              loadingButtonController: loadingButtonController,
              onSentWallEdit: (value) {
                int index = wallResp.value!.sentWalls
                    .indexWhere((element) => element.id == value.id);
                wallResp.value!.sentWalls[index] = value;
                wallBetaController.users.refresh();
                sentWallResp.value = value;
                sentWallResp.refresh();
                isDone.value = true;
              }));
    }
  }

  onAllLikePressed(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => Container(
            height: context.height * 0.5,
            padding: const EdgeInsets.only(left: 25, right: 25),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Theme.of(context).colorScheme.surface),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                  height: height * 0.01,
                  width: width * 0.3,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              Text(AppLocalizations.of(context)!.aimer_par,
                  style: Theme.of(context).textTheme.titleLarge!),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: wallResp.value!.likes.isNotEmpty
                      ? ListView.builder(
                          itemCount: wallResp.value!.likes.length,
                          itemBuilder: (context, index) => Row(
                                children: [
                                  SizedBox(
                                    width: context.width * 0.02,
                                  ),
                                  fromUserMini(context,
                                      wallResp.value!.likes[index].user),
                                ],
                              ))
                      : Center(
                          child: Text(
                          AppLocalizations.of(context)!
                              .aucun_utilisateur_a_aimer_ce_bloc,
                        ))),
            ])));
  }

  Future<void> delete(String ClimbingId, String SecteurId, String wallId,
      String commentId) async {
    deleteSprayWallComment(
        climbingLocationId: ClimbingId,
        sprayWallId: SprayWallId,
        wallId: wallId,
        commentId: commentId);
    wallResp.value!.comments.removeWhere((element) => element.id == commentId);
    wallResp.refresh();
  }

  Future<void> post(
      String wallId, String ClimbingId, String sprayWallId) async {
    CommentsReq commentReq = CommentsReq(message: commentController.text);
    commentController.clear();
    CommentsResp _comment = await postSprayWallComment(
        climbingLocationId: ClimbingId,
        sprayWallId: SprayWallId,
        wallId: wallId,
        comment: commentReq);
    wallResp.value!.comments.insert(0, _comment);
    commentController.clear();
  }

  onShowCommentairePressed(BuildContext context) async {
    ScrollController _scrollController = ScrollController();
    RxString name = "".obs;
    await showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          maxHeight: context.height * 0.8,
        ),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => Container(
            padding: EdgeInsets.only(
              left: context.width * 0.04,
              right: context.width * 0.04,
              top: 10,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: height * 0.01,
                width: width * 0.3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Text(AppLocalizations.of(context)!.commentaires,
                  style: Theme.of(context).textTheme.titleLarge!),
              Flexible(
                  child: Obx(
                () => Scrollbar(
                    controller: _scrollController,
                    child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                              height: 15,
                            ),
                        itemCount: wallResp.value!.comments.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return CommentsWidget(
                            commentsResp: wallResp.value!.comments[index],
                            ondelete: () => delete(
                              ClimbingId,
                              SprayWallId,
                              WallId,
                              wallResp.value!.comments[index].id!,
                            ),
                          );
                        })),
              )),
              SingleChildScrollView(
                  reverse: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: TextMentionField(
                          hintText: AppLocalizations.of(context)!
                              .laissez_un_commentaire,
                          prefixIcon: profileImage(image: userImage),
                          suffixIcon: IconButton(
                              onPressed: () {
                                post(WallId, ClimbingId, SprayWallId);
                                FocusScope.of(context).unfocus();
                              },
                              icon: Icon(Icons.send)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .veuillez_entrer_un_commentaire;
                            }
                            return null;
                          },
                          controller: commentController))),
            ])));
  }
}
