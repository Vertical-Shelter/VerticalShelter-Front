import 'package:app/core/app_export.dart';
import 'package:app/data/models/Contest/contestResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/MyCachedNetworkItmage.dart';
import 'package:intl/intl.dart';

class ContestCard extends StatelessWidget {
  ContestResp contestResp;

  ContestCard({required this.contestResp});

  @override
  Widget build(BuildContext context) {
    String dayOfWeek = DateFormat.EEEE(AppLocalizations.of(context)!.pays_code)
        .format(contestResp.date!);
    String dayMonth = DateFormat.MMMMd(AppLocalizations.of(context)!.pays_code)
        .format(contestResp.date!);
    return InkWell(
        onTap: () {
          String climbingLocationId = Get.find<MultiAccountManagement>()
              .actifAccount!
              .climbingLocationId;
          Get.toNamed(AppRoutesVT.contestDetaiil, parameters: {
            "contestId": contestResp.id!,
            "climbingLocationId": climbingLocationId
          });
        },
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
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
                        imageUrl: contestResp.imageUrl == null
                            ? ''
                            : contestResp.imageUrl!,
                      ),
                    )),
                SizedBox(
                  width: width * 0.01,
                ),
                Flexible(
                    flex: 4,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(contestResp.title!,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                          Flexible(
                            child: Row(children: [
                              Text('$dayOfWeek $dayMonth'),
                            ]),
                          )
                        ])),
                SizedBox(
                  width: width * 0.01,
                ),
                //si la date est la meme qu'aujourd'hui ecrire en cours
                tag(context)
              ],
            )));
  }

  Widget tag(BuildContext context) {
    if (contestResp.etat! == 0) {
      return Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              )),
          child: Text(
            AppLocalizations.of(context)!.en_cours,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: ColorsConstantDarkTheme.background),
          ));
    } else if (contestResp.etat! > 0) {
      return Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              )),
          child: Text(
            AppLocalizations.of(context)!.termine,
          ));
    }
    return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            )),
        child: Text(
          AppLocalizations.of(context)!.a_venir,
        ));
  }
}
