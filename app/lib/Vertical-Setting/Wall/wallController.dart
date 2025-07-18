import 'package:app/Vertical-Setting/BottomBar/bottomBarController.dart';
import 'package:app/Vertical-Setting/home/homeController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/Comments/commentsApi.dart';
import 'package:app/data/models/Comments/commentsReq.dart';
import 'package:app/data/models/Comments/commentsResp.dart';
import 'package:app/data/models/Likes/likeApi.dart';
import 'package:app/data/models/Wall/Api.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/data/models/grade/gradeResp.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:app/widgets/WallBeta/WallBetaController.dart';
import 'package:app/widgets/WallBeta/WallBetaScreen.dart';
import 'package:app/widgets/commentsWidget.dart';
import 'package:app/widgets/mentionTextField.dart';
import 'package:app/widgets/profil/profilImage.dart';
import 'package:app/widgets/tag.dart';
import 'package:app/widgets/vid%C3%A9oCapture.dart';
import 'package:video_player/video_player.dart';

class VSWallController extends GetxController {
  WallResp? wallResp;
  RxBool isLoading = false.obs;
  PageController pageController = PageController();
  TextEditingController commentController = TextEditingController();
  RxList<CommentsResp> comments = <CommentsResp>[].obs;
  RxBool isLoad = false.obs;
  String userImage = "";

  VideoCapture? videoCapture;

  List pages = [Get.put(WallBetaScreen())];
  RxInt currentPage = 0.obs;
  RxMap<GradeResp, int> dataMap = Map<GradeResp, int>().obs;
  RxInt likes = 0.obs;
  TagWidget? getGrade;
  String climbingLocationId = "";
  String secteurId = "";

  @override
  void onReady() {
    climbingLocationId = Get.parameters['climbingLocationId']!;
    secteurId = Get.parameters['SecteurId']!;
    init(Get.parameters['wallId']!, Get.parameters['climbingLocationId']!,
        Get.parameters['SecteurId']!);
    super.onReady();
  }

  void onBackPressed() async {
    // Get.find<ClimbingLocationController>().refreshWall();
    Get.back();
  }

  Future<void> initVideo() async {
    if (wallResp!.betaOuvreur != null) {
      videoCapture = VideoCapture(
        'edit',
        controller: VideoPlayerController.networkUrl(
          Uri.parse(wallResp!.betaOuvreur!),
        ),
        isReadOnly: true,
      );
    }
  }

  void onMyBetaPressed() async {}

  void changeIndex(int index) {
    currentPage.value = index;
    currentPage.refresh();
  }

  onUserPressed(BuildContext context) {
    // showDialog(context: context, builder: (context) => Dialog(child: ,));
  }

  onLikePressed() {}

  void init(String wallId, String climbingLocaitonId, String secteurId) async {
    isLoading.value = false;
    currentPage.value = 0;

    await getWall(wallId, climbingLocaitonId, secteurId);
    await listComments(
      wallId,
      climbingLocaitonId,
      secteurId,
    );
    await initVideo();
    isLoading.value = true;
    isLoading.refresh();
  }

  Future<void> listComments(
      String wallId, String climbingLocationId, String SecteurId) async {
    comments.value = await getComments(climbingLocationId, SecteurId, wallId);
    comments.refresh();
    isLoad.value = true;
    isLoad.refresh();
  }

  Future<void> getWall(
      String wallId, String climbingLocaitonId, String secteurId) async {
    wallResp = await wall_get(wallId, climbingLocaitonId, secteurId);
    getLikes(climbingLocaitonId, secteurId, wallId).then((value) {
      likes.value = value.length;
      likes.refresh();
    });

    getGrade = TagWidget(
      tag: tagText(wallResp!.grade!.ref1),
    );

    List<GradeResp> grades = [];
    for (var user in wallResp!.sentWalls!) {
      if (user.grade == null) {
        continue;
      }
      if (grades.indexWhere((element) => element.ref1 == user.grade!.ref1) ==
          -1) {
        grades.add(user.grade!);
      }
      dataMap[user.grade!] = (dataMap[user.grade!] ?? 0) + 1;
    }

    dataMap.forEach((key, value) {
      dataMap[key] = dataMap[key]! * 100 ~/ wallResp!.sentWalls!.length;
    });

    if (grades.isEmpty) {
      return;
    }
  }

  Color tagColor(String colorName) {
    try {
      return ColorsConstant.fromHex(colorName);
    } catch (e) {
      return ColorsConstant.white;
    }
  }

  String tagText(String colorName) {
    try {
      ColorsConstant.fromHex(colorName);
      return "      ";
    } catch (e) {
      return colorName;
    }
  }

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
                          ondelete: () => delete(climbingLocationId, secteurId,
                              wallResp!.id!, comments[index].id!),
                        );
                      },
                    )),
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
                          prefixIcon: profileImage(
                            image: userImage,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                post(wallResp!.id!, climbingLocationId,
                                    secteurId);
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
