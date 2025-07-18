import 'package:app/core/app_export.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/widgets/MyCachedNetworkItmage.dart';
import 'package:app/widgets/colorFilter/gradeSquareWidget.dart';

class WallMinimalistOuvreurWidget extends StatelessWidget {
  WallResp wallMinimalResp;
  void Function() onPressed;

  WallMinimalistOuvreurWidget(
      {required this.onPressed, required this.wallMinimalResp});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onTertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 80,
            width: width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),
                      child: MyCachedNetworkImage(
                        width: width,
                        height: height,
                        imageUrl: wallMinimalResp.secteurResp!.images == null
                            ? ''
                            : wallMinimalResp.secteurResp!.images!.firstOrNull,
                      ),
                    )),
                Flexible(
                    flex: 4,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              flex: 2,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      "${AppLocalizations.of(context)!.prises} :",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!),
                                  const SizedBox(width: 5),
                                  Text(wallMinimalResp.hold_to_take.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!),
                                ],
                              )),
                          Flexible(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                Text(
                                    wallMinimalResp.sentWalls!.length
                                        .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface)),
                                const SizedBox(width: 5),
                                Text(
                                    wallMinimalResp.sentWalls!.length < 2
                                        ? AppLocalizations.of(context)!
                                            .personne_a_reussi_ce_bloc
                                        : AppLocalizations.of(context)!
                                            .personnes_ont_reussi_ce_bloc,
                                    style:
                                        Theme.of(context).textTheme.bodySmall!),
                              ]))
                        ])),
                Flexible(
                    child: GradeSquareWidget.fromGrade(wallMinimalResp.grade!)),
                SizedBox(
                  width: width * 0.01,
                )
              ],
            )));
  }
}
