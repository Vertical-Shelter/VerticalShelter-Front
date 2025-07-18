import 'package:app/Vertical-Tracking/Gyms/gymsController.dart';
import 'package:app/data/models/Annotation/Annotation.dart';
import 'package:app/data/models/SentWall/sentWallReq.dart';
import 'package:app/data/models/SentWall/sentWall_api.dart';
import 'package:app/data/models/SprayWall/hold.dart';

import 'package:app/core/app_export.dart';
import 'package:app/data/models/grade/gradeResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:app/widgets/colorFilter/colorFilterController.dart';
import 'package:app/widgets/colorFilter/gradeSquareWidget.dart';
import 'package:app/widgets/walls/sprayWallImage.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;
import '../../data/models/Wall/WallResp.dart';

import '../../data/models/Wall/WallResp.dart';

// ignore: must_be_immutable
class SprayWallWidget extends StatefulWidget {
  WallResp sprayWallResp;
  void Function() onPressed;
  ui.Image image;
  List<Annotation> annotations;
  String sprayWallId;

  SprayWallWidget(
      {required this.sprayWallResp,
      required this.sprayWallId,
      required this.image,
      required this.onPressed,
      required this.annotations});

  @override
  _SprayWallWidgetState createState() => _SprayWallWidgetState();
}

class _SprayWallWidgetState extends State<SprayWallWidget> {
  List<HoldResp> points = [];

  Account account = Get.find<MultiAccountManagement>().actifAccount!;

  @override
  void initState() {
    super.initState();
    points = filterpoint();
  }

  Widget gradeWidget() {
    //find the corresponding grade in the grade system of the gym
    GradeResp? grade = Get.find<ClimbingLocationController>()
        .climbingLocationResp!
        .gradeSystem!
        .firstWhereOrNull(
            (element) => element.id == widget.sprayWallResp.gradeId);
    return GradeSquareWidget.fromGrade(grade!);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPressed,
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    child: Spraywallimage(
                      image: widget.image,
                      points: points,
                      annotations: widget.annotations,
                      width: 80,
                      height: 100,
                    )),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.sprayWallResp.equivalentExte ?? ''),
                    gradeWidget(),
                  ],
                )),
                SizedBox(
                  width: 10,
                ),
                Container(
                    width: width * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.sprayWallResp.name ?? '',
                        ),
                        Text(
                          '${widget.sprayWallResp.nbRepetitions} ${AppLocalizations.of(context)!.tops}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Container(
                          constraints:
                              BoxConstraints(maxWidth: width, maxHeight: 30),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.only(left: 9, right: 9, top: 9),
                          // color: Colors.black,
                          child: ListView.separated(
                              itemCount:
                                  widget.sprayWallResp.attributes!.length,
                              separatorBuilder: (context, index) => Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    child: Icon(
                                      Icons.circle,
                                      size: width * 0.005,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Text(
                                    widget.sprayWallResp!.attributes![index],
                                    style:
                                        Theme.of(context).textTheme.bodySmall);
                              }),
                        )
                      ],
                    )),
                Spacer(),
                widget.sprayWallResp.betaOuvreur != null
                    ? Icon(FontAwesomeIcons.clapperboard,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20)
                    : Container(
                        width: 20,
                        height: 0,
                      ),
                account.isGym
                    ? SizedBox(width: 20)
                    : InkWell(
                        onTap: () {
                          if (widget.sprayWallResp.isDone != null &&
                              !widget.sprayWallResp.isDone!) {
                            setState(() {
                              widget.sprayWallResp.isDone = true;
                            });
                            sentSprayWallDetails(
                                SentWallReq(
                                    gradeID: null,
                                    nTentative: 1,
                                    date: DateTime.now(),
                                    beta: null),
                                Get.find<ClimbingLocationController>()
                                    .climbingLocationResp!
                                    .id,
                                widget.sprayWallId,
                                widget.sprayWallResp.id!);
                            //add a vibration
                            HapticFeedback.lightImpact();
                          }
                        },
                        child: widget.sprayWallResp.isDone != null &&
                                widget.sprayWallResp.isDone!
                            ? Icon(Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                                size: 30)
                            : Icon(Icons.check_circle_outline_sharp,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 30),
                      ),
                SizedBox(
                  width: 20,
                ),
              ],
            )));
  }

  List<HoldResp> filterpoint() {
    List<HoldResp> res = [];
    for (var hold in widget.sprayWallResp.holds) {
      res.add(HoldResp(id: hold.id, type: hold.type));
    }
    // for(SprayWallSVG point in sprayWallController.sprayWallSvg){
    //   if(widget.sprayWallResp.holds.any((x) => (x.id.compareTo(point.id)==0))){
    //    points.add(point);
    //   }
    // }
    return res;
  }
}
