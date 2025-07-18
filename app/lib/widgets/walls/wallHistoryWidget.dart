import 'package:app/widgets/MyCachedNetworkItmage.dart';
import 'package:app/widgets/colorFilter/gradeSquareWidget.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/Wall/WallResp.dart';

// ignore: must_be_immutable
class WallHistoryWidget extends StatelessWidget {
  WallResp wallMinimalResp;

  WallHistoryWidget(
    this.wallMinimalResp,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Get.toNamed(AppRoutesVT.WallScreenRoute, parameters: {
              'WallId': wallMinimalResp.id!,
              'SecteurId': wallMinimalResp.secteurResp!.id,
              'climbingLocationId': wallMinimalResp.climbingLocation!.id,
            }),
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onTertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            height: height * 0.10,
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
                                      AppLocalizations.of(context)!.prises +
                                          " :",
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
                              child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: wallMinimalResp.attributes!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return index ==
                                      wallMinimalResp.attributes!.length - 1
                                  ? Row(children: [
                                      Text(wallMinimalResp.attributes![index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!),
                                    ])
                                  : Row(children: [
                                      Text(wallMinimalResp.attributes![index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!),
                                      const SizedBox(width: 5),
                                      Icon(Icons.circle, size: 9),
                                      const SizedBox(width: 5),
                                    ]);
                            },
                          )),
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
