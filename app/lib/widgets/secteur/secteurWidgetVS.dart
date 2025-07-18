import 'package:app/core/app_export.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/widgets/secteur/secteurCard.dart';
import 'package:app/widgets/walls/wallMinimalistOuvreurWidget.dart';

class SecteurDateCard extends StatefulWidget {
  DateTime? date;
  Map<String, List<WallResp>> secteurList;

  SecteurDateCard({Key? key, required this.secteurList, required this.date})
      : super(key: key);

  @override
  _SecteurwidgetvsState createState() => _SecteurwidgetvsState();
}

class _SecteurwidgetvsState extends State<SecteurDateCard> {
  bool needWarningDate = false;

  @override
  void initState() {
    super.initState();
    if (widget.secteurList.isNotEmpty) {
      DateTime now = DateTime.now();
      //check if it has been more than 30 days since the last wall was created
      DateTime? wallDate = widget.date;
      if (wallDate == null) {
        needWarningDate = false;
      } else if (now.difference(wallDate).inDays > 30) {
        needWarningDate = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.date != null
            ? Text(widget.date!
                .format('yMMMMd', AppLocalizations.of(context)!.pays_code))
            : Text(AppLocalizations.of(context)!.date_inconnue),
        SizedBox(height: 10),
        if (needWarningDate)
          Row(children: [
            Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
            Text(
              AppLocalizations.of(context)!.secteur_ouvert_plus_de_30,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ]),
        SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.secteurList.keys.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            String secteurName = widget.secteurList.keys.elementAt(index);
            return SecteurCard(
              secteurName: widget.secteurList.keys.elementAt(index),
              wallList: widget.secteurList[secteurName]!,
            );
          },
        )
      ],
    ));
  }
}
