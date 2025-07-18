import 'package:app/Vertical-Tracking/Social/SocialController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/VSL/GuildResp.dart';
import 'package:app/data/models/friendrequest/friendrequest_resp.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/guildCard.dart';
import 'package:app/widgets/profil/profilMiniHorizontal.dart';
import 'package:app/widgets/profil/profilMinivertical.dart';
import 'package:app/widgets/searchBar/searchBarWidget.dart';
import 'package:app/widgets/stripe.dart';
import 'package:app/widgets/vsl/reglement.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class SocialScreen extends GetWidget<SocialController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: Obx(() => controller.isFocusing.value
            ? bodySearchingPeople(context)
            : bodyNormal(context)));
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      toolbarHeight: height * 0.1,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Row(children: [
        Obx(() => controller.isFocusing.value == false
            ? Text(AppLocalizations.of(context)!.social,
                style: Theme.of(context).textTheme.labelLarge)
            : Container()),
        Expanded(
            child: AnimatedSearchBar(
          controller: controller.searchTextControler,
          duration: Duration(milliseconds: 300),
          animationDuration: Duration(milliseconds: 300),
          onClose: () => controller.isFocusing.value = false,
          onTap: () {
            controller.isFocusing.value = true;
            controller.isFocusing.refresh();
          },
          onChanged: (p0) async {
            controller.searchGlobal(p0);
          },

          // text: 'Rechercher',
        ))
      ]),
    );
  }

  Widget bodyNormal(BuildContext context) {
    return NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverStickyHeader(
                  header: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.vsl,
                                style: Theme.of(context).textTheme.labelMedium),
                            SizedBox(height: 20),
                            ReglementVsl(),
                            SizedBox(height: 20),
                            Center(child: vslWidget(context)),
                            SizedBox(height: 20),
                            Text(
                                AppLocalizations.of(context)!
                                    .souvent_dans_ta_salle,
                                style: Theme.of(context).textTheme.labelMedium),
                            SizedBox(height: 20),
                            SizedBox(
                                height: 200,
                                child: Obx(() => controller
                                        .isUserClocLoading.value
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return ProfileMiniHorizontal(
                                              refuseFriend:
                                                  controller.refuseFriend,
                                              acceptFriend:
                                                  controller.acceptFriend,
                                              addFriend: controller.addFriend,
                                              cancelFriend:
                                                  controller.cancelFriend,
                                              status: controller
                                                  .userCloc[index].friendStatus,
                                              key: UniqueKey(),
                                              id: controller.userCloc[index].id,
                                              name: controller
                                                  .userCloc[index].username,
                                              image: controller
                                                  .userCloc[index].image);
                                        },
                                        separatorBuilder: (builder, context) =>
                                            SizedBox(
                                              width: 10,
                                            ),
                                        itemCount:
                                            controller.userCloc.length))),
                            SizedBox(height: 20),
                            Obx(() => controller.pending_friends.isEmpty
                                ? Container()
                                : Text(
                                    AppLocalizations.of(context)!.demande_damis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium)),
                            Obx(() => controller.pending_friends.isEmpty
                                ? Container()
                                : SizedBox(height: 20)),
                            Obx(() => controller.pending_friends.isEmpty
                                ? Container()
                                : ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return ProfileMiniVertical(
                                          showFriendButton: true,
                                          refuseFriend: controller.refuseFriend,
                                          acceptFriend: controller.acceptFriend,
                                          addFriend: controller.addFriend,
                                          cancelFriend: controller.cancelFriend,
                                          status: controller
                                              .pending_friends[index]
                                              .friendStatus,
                                          key: UniqueKey(),
                                          id: controller
                                              .pending_friends[index].id,
                                          name: controller
                                              .pending_friends[index].username,
                                          image: controller
                                              .pending_friends[index].image);
                                    },
                                    separatorBuilder: (builder, context) =>
                                        SizedBox(
                                          width: 10,
                                        ),
                                    itemCount:
                                        controller.pending_friends.length)),
                          ])),
                )),
            SliverPersistentHeader(
              delegate: MyFriendHeader(),
              pinned: true,
              floating: true,
            ),
          ];
        },
        body: Container(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: myFriendList(context)));
  }

  Widget bodySearchingPeople(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ProfileMiniVertical(
                  showFriendButton: true,
                  refuseFriend: controller.refuseFriend,
                  acceptFriend: controller.acceptFriend,
                  addFriend: controller.addFriend,
                  cancelFriend: controller.cancelFriend,
                  id: controller.global[index].id,
                  name: controller.global[index].username,
                  image: controller.global[index].image);
            },
            separatorBuilder: (builder, context) => SizedBox(
                  height: 10,
                ),
            itemCount: controller.global.length));
  }

  Widget myFriendList(BuildContext context) {
    return Obx(() => controller.isFriendLoading.value
        ? Center(child: CircularProgressIndicator())
        : ListView.separated(
            itemBuilder: (context, index) {
              return ProfileMiniVertical(
                  id: controller.displayFriends[index].id,
                  name: controller.displayFriends[index].username,
                  image: controller.displayFriends[index].image);
            },
            separatorBuilder: (builder, context) => SizedBox(
                  height: 10,
                ),
            itemCount: controller.displayFriends.length));
  }

  Widget vslWidget(BuildContext context) {
    return controller.vsl.timerInscription(context);
    // if (!controller.vsl.has_guild.value) {
    //   return Column(
    //     children: [
    //       Center(
    //         child: Text(
    //           AppLocalizations.of(context)!
    //               .vous_n_appartenez_pas_encore_a_une_guilde,
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //       const SizedBox(height: 20),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           ButtonWidget(
    //             padding: EdgeInsets.all(10),
    //             onPressed: () {
    //               Get.toNamed(AppRoutesVT.createTeamScreen);
    //             },
    //             child: Text(
    //               AppLocalizations.of(context)!.creer_mon_equipe_vsl,
    //             ),
    //           ),
    //           const SizedBox(width: 20),
    //           ButtonWidget(
    //             padding: EdgeInsets.all(10),
    //             onPressed: () {
    //               Get.toNamed(AppRoutesVT.joinTeamScreen);
    //             },
    //             child: Text(
    //               AppLocalizations.of(context)!.rejoindre_une_equipe_vsl,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   );
    // } else {
    //   return Column(
    //     children: [
    //       Text(
    //         AppLocalizations.of(context)!.mon_equipe_vsl,
    //       ),
    //       const SizedBox(height: 8),
    //       GuildCard(context: context, guild: controller.vsl.myGuild!)
    //     ],
    //   );
    // }
  }
}

class MyFriendHeader extends SliverPersistentHeaderDelegate {
  SocialController controller = Get.find<SocialController>();

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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Theme.of(context).colorScheme.surface,
        height: 40,
        child: Row(children: [
          Text(AppLocalizations.of(context)!.amis,
              style: Theme.of(context).textTheme.labelMedium),
        ]));
  }
}
