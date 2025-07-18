import 'package:app/Vertical-Tracking/Gyms/gymsController.dart';
import 'package:app/data/models/User/projet/projetResp.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/data/models/grade/gradeResp.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:app/widgets/MyCachedNetworkItmage.dart';

import 'package:app/widgets/colorFilter/gradeSquareWidget.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/tag.dart';
import 'package:app/widgets/walls/sprayWallImage.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class ProjectWidget extends StatelessWidget {
  ProjetResp projetResp;
  bool isNext;
  bool isRecent;
  void Function() onPressed;

  void Function() selectWall;
  bool isSelected;
  void Function() unselectWall;

  ProjectWidget(
      {required this.projetResp,
      this.isNext = false,
      this.isRecent = false,
      required this.isSelected,
      required this.onPressed,
      required this.selectWall,
      required this.unselectWall});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (projetResp.is_sprayWall) {
            Get.toNamed(AppRoutesVT.sprayWallScreen, parameters: {
              'WallId': projetResp.wall!.id!,
              'SprayWallId': projetResp.secteur_id!,
              'ClimbingId': projetResp.climbingLocation_id!,
            }, arguments: {
              'isProject': true,
              'sprayWallResp': projetResp.wall!.secteurResp!.toSprayWallResp(),
            });
          } else {
            Get.toNamed(AppRoutesVT.WallScreenRoute, parameters: {
              'WallId': projetResp.wall!.id!,
              'SecteurId': projetResp.secteur_id!,
              'climbingLocationId': projetResp.climbingLocation_id!,
              'WallIdNext': projetResp.wall!.id!,
              'SecteurIdNext': projetResp.secteur_id!,
              'ClimbingIdNext': projetResp.climbingLocation_id!,
            });
          }
        },
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    flex: 2,
                    child: Stack(alignment: Alignment.center, children: [
                      projetResp.is_sprayWall && projetResp.image != null
                          ? Spraywallimage(
                              image: projetResp.image!,
                              annotations:
                                  projetResp.wall!.secteurResp!.annotations,
                              points: projetResp.wall!.holds,
                              width: 80,
                              height: 100,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                              child: MyCachedNetworkImage(
                                width: 80,
                                height: 100,
                                imageUrl:
                                    projetResp.wall!.secteurResp!.images.isEmpty
                                        ? ''
                                        : projetResp
                                            .wall!.secteurResp!.images!.first,
                              ),
                            ),
                      ClipOval(
                          child: CircleAvatar(
                        radius: 20,
                        backgroundColor: ColorsConstantDarkTheme.neutral_white,
                        child: MyCachedNetworkImage(
                            imageUrl: projetResp.wall!.climbingLocation!.image),
                      ))
                    ])),
                Flexible(
                    flex: 4,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 2,
                              child: Text(projetResp.wall!.name!,
                                  textAlign: TextAlign.left,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium)),
                          Flexible(
                              child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: projetResp.wall!.attributes!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return index ==
                                      projetResp.wall!.attributes!.length - 1
                                  ? Row(children: [
                                      Text(projetResp.wall!.attributes![index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!),
                                    ])
                                  : Row(children: [
                                      Text(projetResp.wall!.attributes![index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!),
                                      const SizedBox(width: 5),
                                      Icon(Icons.circle, size: 2),
                                      const SizedBox(width: 5),
                                    ]);
                            },
                          )),
                        ])),
                projetResp.wall!.betaOuvreur != null
                    ? Icon(FontAwesomeIcons.clapperboard,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20)
                    : Container(),
                SizedBox(
                  width: 10,
                ),
                Text(projetResp.wall!.equivalentExte ?? "",
                    style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(
                  width: 10,
                ),
                gradeSquareWidget(),
                SizedBox(
                  width: 5,
                ),
              ],
            )));
  }

  Widget gradeSquareWidget() {
    try {
      if (projetResp.wall!.grade != null) {
        return GradeSquareWidget.fromGrade(projetResp.wall!.grade!);
      } else {
        ClimbingLocationController vtGymController =
            Get.find<ClimbingLocationController>();
        GradeResp gradeResp = vtGymController.climbingLocationResp!.gradeSystem!
            .firstWhere((element) => element.id == projetResp.wall!.gradeId);
        return GradeSquareWidget.fromGrade(gradeResp);
      }
    } catch (e) {
      return Container();
    }
  }
}
