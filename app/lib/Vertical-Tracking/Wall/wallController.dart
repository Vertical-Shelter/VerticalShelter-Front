import 'dart:async';
import 'dart:io';

import 'package:app/utils/climbingLocationController.dart';
import 'package:app/utils/projectController.dart';
import 'package:app/widgets/WallBeta/WallBetaController.dart';
import 'package:app/widgets/WallBeta/WallBetaScreen.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/Comments/commentsApi.dart';
import 'package:app/data/models/Comments/commentsReq.dart';
import 'package:app/data/models/Comments/commentsResp.dart';
import 'package:app/data/models/Likes/likeApi.dart';
import 'package:app/data/models/Likes/likeResp.dart';
import 'package:app/data/models/SentWall/sentWallResp.dart';
import 'package:app/data/models/SentWall/sentWall_api.dart';
import 'package:app/data/models/User/projet/api.dart';
import 'package:app/data/models/User/projet/projectReq.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/Wall/Api.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/ConfirmDialog.dart';
import 'package:app/widgets/commentsWidget.dart';
import 'package:app/widgets/loadingButton.dart';
import 'package:app/widgets/mentionTextField.dart';
import 'package:app/widgets/profil/profilImage.dart';
import 'package:app/widgets/profil/profilMinivertical.dart';
import 'package:app/widgets/sentWalls/sentWallCreateWidget.dart';
import 'package:app/widgets/sentWalls/sentWallEditWidget.dart';
import 'package:app/widgets/socialMedia/socialSharing.dart';
import 'package:app/widgets/vid%C3%A9oCapture.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_editor/image_editor.dart';
import 'package:app/widgets/shareToInstagram.dart';

class VTWallController extends GetxController {
  PageController pageController = PageController();
  Rxn<WallResp> wallResp = Rxn();
  Rx<SentWallResp?> sentWallResp = Rx<SentWallResp?>(null);
  LoadingButtonController loadingButtonController = LoadingButtonController();

  RxList<LikeResp> likes = <LikeResp>[].obs;
  List<String> attributes = <String>[];

  RxBool isLoading = false.obs;
  RxBool isDone = false.obs;
  RxBool isLiked = false.obs;
  RxBool avoidSpam = false.obs;

  StreamController<bool> likeController = StreamController();

  String climbingLocationId = '';
  String SecteurId = '';

  String WallId = '';
  String Url = '';

  //initial status
  bool isInitialLiked = false;
  bool isInitialDone = false;
  bool isNext = false;

  RxBool isProject = false.obs;
  VideoCapture? videoCapture;

  //Controllers Needed
  ClimbingLocationController climbingLocationController =
      Get.find<ClimbingLocationController>();

  WallBetaController wallBetaController = Get.find<WallBetaController>();

  ProjetController projetController = Get.find<ProjetController>();
  MultiAccountManagement multiAccountManagement =
      Get.find<MultiAccountManagement>();

  List pages = [Get.put(WallBetaScreen())];
  @override
  void onReady() {
    _init();
    super.onReady();
  }

  void goToPage(String route) {
    Get.toNamed(route);
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
    ProjectReq projectReq = ProjectReq(
        wall_id: wallResp.value!.id!,
        climbingLocation_id: climbingLocationId,
        secteur_id: SecteurId);
    try {
      postProject(projectReq).then((value) {
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

  Future<void> shareToInstagramStory() async {
    if (sentWallResp.value == null) {
      Get.snackbar(AppLocalizations.of(Get.context!)!.video,
          AppLocalizations.of(Get.context!)!.ajoute_une_video_pour_partager,
          margin: EdgeInsets.all(10),
          duration: 3.seconds,
          backgroundColor: Theme.of(Get.context!).colorScheme.background);
      return;
    }
    if (sentWallResp.value!.beta == null) {
      Get.snackbar(AppLocalizations.of(Get.context!)!.video,
          AppLocalizations.of(Get.context!)!.ajoute_une_video_pour_partager,
          margin: EdgeInsets.all(10),
          duration: 3.seconds,
          backgroundColor: Theme.of(Get.context!).colorScheme.background);
      return;
    }
    VideoDownloader videoDownloader = VideoDownloader();

    String video =
        await videoDownloader.downloadAndSaveVideo(sentWallResp.value!.beta!);
    File logoFile = await getImageFileFromAssets('images/Frame 27200.png');

    SocialMediaSharing.shareInstagramStory(
      appId: '1114045873139467',
      imagePath: logoFile.path,
      backgroundTopColor: '#D1FF97',
      backgroundBottomColor: '#FF5757',
      backgroundResourcePath: video,
    ).then((data) {
      print('Shared to Instagram story');
      //delete the video
      File(video).delete();
    });
  }

  @override
  void onClose() {
    likeController.close();
    videoCapture?.controller?.dispose();
    if (isLiked.value && !isInitialLiked) {
      postLikes(climbingLocationId, SecteurId, WallId);
    } else if (isInitialLiked && !isLiked.value) {
      deleteLikes(climbingLocationId, SecteurId, WallId);
    }
    super.onClose();
  }

  void onBackPressed() async {
    Get.back();
  }

  void changeWallBack() async {
    changeWallRefresh(false);
  }

  void changeWallNext() async {
    changeWallRefresh(true);
  }

  void changeWallRefresh(bool isNext) async {
    WallResp currentWall = climbingLocationController.displayedWalls
        .firstWhere((element) => element.id == WallId);
    int WallIndex = 0;
    if (isNext) {
      if (climbingLocationController.displayedWalls.indexOf(currentWall) >=
          climbingLocationController.displayedWalls.length) {
        return;
      }
      WallIndex =
          climbingLocationController.displayedWalls.indexOf(currentWall) + 1;
    } else {
      if (climbingLocationController.displayedWalls.indexOf(currentWall) == 0) {
        return;
      }
      WallIndex =
          climbingLocationController.displayedWalls.indexOf(currentWall) - 1;
    }
    //WallResp nextWall = climbingLocationController.displayedWalls.elementAt(WallIndex);

    WallId = climbingLocationController.displayedWalls[WallIndex].id!;
    SecteurId =
        climbingLocationController.displayedWalls[WallIndex].secteurResp!.id;
    climbingLocationId = climbingLocationController.climbingLocationResp!.id;

    pageController = PageController();
    sentWallResp = Rx<SentWallResp?>(null);
    loadingButtonController = LoadingButtonController();

    likes = <LikeResp>[].obs;
    attributes = <String>[];

    isLoading = false.obs;
    isDone = false.obs;
    isLiked = false.obs;
    // currentSkills = <SkillResp>[];
    avoidSpam = false.obs;

    // currentSkills = await getMySkills();
    getWall(WallId, climbingLocationId, SecteurId);
    wallResp.value = (await wall_get(WallId, climbingLocationId, SecteurId));

    isLoading.value = true;
    isLoading.refresh();

    wallBetaController.refreshBetas(wallResp.value!.sentWalls);
  }

  void onLike(BuildContext context) async {
    // Si on spam y a un probleme
    avoidSpam.value = true;
    avoidSpam.refresh();
    if (!isLiked.value) {
      Account me = multiAccountManagement.actifAccount!;
      UserMinimalResp user = UserMinimalResp(
        id: me.id,
        username: me.name,
        image: me.picture,
      );
      LikeResp like = LikeResp(date: "", user: user);
      likes.add(like);
    } else {
      likes.removeWhere((element) =>
          element.user!.id == multiAccountManagement.actifAccount!.id);
    }
    isLiked.value = !isLiked.value;
    isLiked.refresh();
    avoidSpam.value = false;
    avoidSpam.refresh();
    // showPopupSkills(context);
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
    climbingLocationId = Get.parameters['climbingLocationId']!;
    SecteurId = Get.parameters['SecteurId']!;
    WallId = Get.parameters['WallId']!;

    // currentSkills = await getMySkills();
    await getWall(WallId, climbingLocationId, SecteurId);

    isProject.value = projetController.projetList
        .any((element) => element.wall!.id == WallId);

    isProject.refresh();
    // Get.find<ActivityController>().updateValue(wallResp!.users!);
    isLoading.value = true;
    isLoading.refresh();
  }

  void onSentWallPressed(BuildContext context) async {
    try {
      // ignore: use_build_context_synchronously
      var isSent = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (context) => SentWallWidget(
              wallId: wallResp.value!.id!,
              cimbingLocationId: climbingLocationId,
              secteurId: SecteurId,
              onSentWallEdit: (value) {
                wallResp.value!.sentWalls.add(value);
                sentWallResp.value = value;
                isDone.value = true;
                loadingButtonController.isLoading.value = false;
                climbingLocationController.allWalls["actual"]!
                    .firstWhere((element) => element.id == WallId)
                    .isDone = true;
                climbingLocationController.filterWall({});
                wallBetaController.users.refresh();
                if (isProject.value) {
                  projetController.projetList
                      .removeWhere((element) => element.wall!.id == WallId);
                  isProject.value = false;
                }
                //update the wall in climbingLocationController

                // showPopupSkills(_context);
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
    } on Exception {}
  }

  Future<void> getWall(
      String wallId, String climbingLocationId, String SecteurId) async {
    print('get wall');
    String user_id = multiAccountManagement.actifAccount!.id;
    wallResp.value = (await wall_get(
        wallId, climbingLocationId, SecteurId)); //la gueule de la fonctoin

    wallResp.value!.sentWalls.sort((a, b) => a.date!.compareTo(b.date!));

    getLikes(climbingLocationId, SecteurId, wallId).then((value) {
      likes.value = value;
      isLiked.value =
          likes.indexWhere((element) => element.user!.id == user_id) != -1;
      isInitialLiked = isLiked.value;
      isLiked.refresh();
    });
    await initVideo();
    for (var attribute in wallResp.value!.attributes) {
      attributes.add(
        attribute.toString(),
      );
    }
    wallResp.value!.sentWalls.sort((a, b) => a.date!.compareTo(b.date!));
    // (pages[0] as WallBetaScreen).controller.users.value = wallResp!.users!;
    SentWallResp? myBeta = wallResp.value!.sentWalls
        .firstWhereOrNull(((element) => element.user!.id == user_id));
    if (myBeta != null) {
      isDone.value = true;
      isInitialDone = true;
      sentWallResp.value = myBeta;
    }
    comments.value = wallResp.value!.comments;
    comments.refresh();
    wallBetaController.updateValues(wallResp.value!.sentWalls);
  }

  void onUsersPressed(BuildContext context) {
    print('on user press');
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

  Future<void> initVideo() async {
    if (wallResp.value!.betaOuvreur != null) {
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
              wallId: wallResp.value!.id!,
              cimbingLocationId: climbingLocationId,
              secteurId: SecteurId,
              onUnsent: () async {
                await showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                        title: AppLocalizations.of(context)!
                            .annuler_la_realisation,
                        mainText: AppLocalizations.of(context)!
                            .etes_vous_sur_de_vouloir_annuler_la_realisation,
                        onConfirm: (context) async {
                          unsent_it(
                            climbingLocationId,
                            SecteurId,
                            WallId,
                            sentWallResp.value!.id!,
                          );
                          wallResp.value!.sentWalls.removeWhere((element) =>
                              element.user!.id ==
                              multiAccountManagement.actifAccount!.id);
                          wallBetaController.users.removeWhere((element) =>
                              element.user!.id ==
                              multiAccountManagement.actifAccount!.id);
                          wallResp.refresh();
                          Get.back();
                          Get.back();

                          isDone.value = false;
                          climbingLocationController.allWalls["actual"]!
                              .firstWhere((element) => element.id == WallId)
                              .isDone = false;
                          climbingLocationController.filterWall({});
                          // showPopupSkills(_context);
                        }));
              },
              sentWallResp: sentWallResp.value!,
              loadingButtonController: loadingButtonController,
              onSentWallEdit: (value) {
                wallResp.value!.sentWalls.removeWhere((element) =>
                    element.user!.id ==
                    multiAccountManagement.actifAccount!.id);
                wallResp.value!.sentWalls.add(value);
                wallBetaController.users.refresh();
                sentWallResp.value = value;
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
                  child: likes.length != 0
                      ? ListView.builder(
                          itemCount: likes.length,
                          itemBuilder: (context, index) => Row(
                                children: [
                                  SizedBox(
                                    width: context.width * 0.02,
                                  ),
                                  fromUserMini(context, likes[index].user),
                                ],
                              ))
                      : Center(
                          child: Text(
                          AppLocalizations.of(context)!
                              .aucun_utilisateur_a_aimer_ce_bloc,
                        ))),
            ])));
  }

  TextEditingController commentController = TextEditingController();
  RxList<CommentsResp> comments = <CommentsResp>[].obs;
  RxBool isLoad = false.obs;
  String userImage = "";

  Future<void> delete(String climbingLocationId, String SecteurId,
      String wallId, String commentId) async {
    await deleteComment(climbingLocationId, SecteurId, wallId, commentId);
    comments.removeWhere((element) => element.id == commentId);
    comments.refresh();
  }

  Future<void> post(
      String wallId, String climbingLocationId, String SecteurId) async {
    CommentsReq commentReq = CommentsReq(message: commentController.text);
    commentController.clear();
    CommentsResp _comment =
        await postComment(climbingLocationId, SecteurId, wallId, commentReq);
    comments.insert(0, _comment);
    comments.refresh();
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
                        itemCount: comments.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return CommentsWidget(
                              commentsResp: comments[index],
                              ondelete: () => delete(
                                    climbingLocationId,
                                    SecteurId,
                                    WallId,
                                    comments[index].id!,
                                  ),
                              onreply: () {
                                name.value = comments[index].user!.username!;
                                commentController.text = "@${name.value} ";
                                print(comments[index].user!.username);
                              });
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
                                post(WallId, climbingLocationId, SecteurId);
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
    // showPopupSkills(context);
  }

  // void showPopupSkills(BuildContext context) async {
  //   List<SkillResp> newSkills = await getMySkills();
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       showCloseIcon: false,
  //       elevation: 0,
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: Colors.transparent,
  //       duration: Duration(seconds: 3),
  //       content: Builder(
  //         builder: (context) =>
  //             SkillsPopup(oldSkillResp: currentSkills, newSkillResp: newSkills),
  //       )));
  //   Future.delayed(Duration(seconds: 1), () {
  //     currentSkills = newSkills;
  //   });
  // }

  onTapPoints(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  '${AppLocalizations.of(context)!.ce_bloc_vaut_actuellement} ${wallResp.value!.points!.round()} ${AppLocalizations.of(context)!.points}.\n\n${AppLocalizations.of(context)!.ce_calcul_est_baser}\n\n${AppLocalizations.of(context)!.le_calcul_est_le_suivant}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ))));
  }
}
