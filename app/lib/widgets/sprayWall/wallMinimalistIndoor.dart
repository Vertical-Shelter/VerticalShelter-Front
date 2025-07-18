import 'package:app/data/models/SentWall/sentWallReq.dart';
import 'package:app/data/models/SentWall/sentWall_api.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/widgets/MyCachedNetworkItmage.dart';

import 'package:app/widgets/colorFilter/gradeSquareWidget.dart';
import 'package:app/core/app_export.dart';
import 'package:app/widgets/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class WallMinimalistIndoorWidget extends StatefulWidget {
  WallResp wallMinimalResp;
  // bool isNext;
  // bool isRecent;
  void Function() onPressed;
  // String climbingLocPk = '';
  // String secteurPk = '';

  WallMinimalistIndoorWidget({
    required this.wallMinimalResp,
    // this.isNext = false,
    // this.isRecent = false,
    //  required this.climbingLocPk,
    //  required this.secteurPk,
    required this.onPressed,
  });

  @override
  _WallMinimalistIndoorWidgetState createState() =>
      _WallMinimalistIndoorWidgetState();
}

class _WallMinimalistIndoorWidgetState
    extends State<WallMinimalistIndoorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StateNoSelection(context),
    );
  }

  Widget StateNoSelection(BuildContext context) {
    return InkWell(
        onTap: widget.onPressed,
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),
                      // child: MyCachedNetworkImage(
                      //   width: width,
                      //   height: height,
                      //   imageUrl:
                      //       widget.wallMinimalResp.secteurResp!.images == null
                      //           ? ''
                      //           : widget.wallMinimalResp.secteurResp!.images!
                      //               .firstOrNull,
                      // ),
                    )),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                    flex: 4,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
//                                GradeSquareWidget.fromGrade(
//                                    widget.wallMinimalResp.grade!),
                                const SizedBox(width: 15),
                                // widget.isRecent
                                //     ? CircleAvatar(
                                //         backgroundColor:
                                //             Theme.of(context).colorScheme.secondary,
                                //         radius: 5,
                                //       )
                                //     : widget.isNext
                                //         ? CircleAvatar(
                                //             backgroundColor:
                                //                 ColorsConstant.blue,
                                //             radius: 5,
                                //           )
                                //         : Container(),
                              ])),
                          Text(
                              AppLocalizations.of(context)!.prises + " : "
//                                  widget.wallMinimalResp.hold_to_take!
//                                      .toString(),
                              ,
                              style: Theme.of(context).textTheme.bodySmall!),
                        ])),
                Expanded(
                    child: widget.wallMinimalResp.betaOuvreur != null
                        ? Icon(FontAwesomeIcons.clapperboard,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 20)
                        : Container(
                            width: 20,
                            height: 0,
                          )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (widget.wallMinimalResp.isDone != null &&
                        !widget.wallMinimalResp.isDone!) {
                      setState(() {
                        widget.wallMinimalResp.isDone = true;
                      });
                      // sent_it(
                      //     SentWallReq(
                      //         gradeID: null,
                      //         nTentative: 1,
                      //         date: DateTime.now(),
                      //         beta: null),
                      //     widget.climbingLocPk,
                      //     widget.secteurPk,
                      //     widget.wallMinimalResp.id!);
                      //add a vibration
                      HapticFeedback.lightImpact();
                    }
                  },
                  child: widget.wallMinimalResp.isDone != null &&
                          widget.wallMinimalResp.isDone!
                      ? Icon(Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30)
                      : Icon(Icons.check_circle_outline_sharp,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 30),
                )),
                SizedBox(
                  width: 10,
                ),
              ],
            )));
  }
}
