import 'package:app/core/app_export.dart';
import 'package:app/data/models/Contest/userContestResp.dart';

class UserContestCard extends StatelessWidget {
  final UserContestResp userContestResp;
  final int index;
  UserContestCard({
    required this.userContestResp,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${index + 1}',
        ),
        SizedBox(width: 10),
        Text(
          userContestResp.prenom ?? '',
        ),
        SizedBox(width: 5),
        Text(
          userContestResp.nom ?? '',
        ),
        Spacer(),
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Text(
              '${userContestResp.points!.toInt()} ${AppLocalizations.of(context)!.pts}',
            )),
      ],
    );
  }
}
