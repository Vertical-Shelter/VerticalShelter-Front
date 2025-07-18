import 'package:app/core/app_export.dart';
import 'package:app/data/models/Contest/phaseResp.dart';

class PhaseCard extends StatelessWidget {
  PhaseResp phaseResp;
  final bool isSelected;

  PhaseCard({required this.phaseResp, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              "${AppLocalizations.of(context)!.phase} ${phaseResp.numero}",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface),
            ),
            Spacer(),
            Text(
              "${AppLocalizations.of(context)!.heure}: ${phaseResp.startTime}",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface),
            ),
            Spacer(),
            Text(
              "${AppLocalizations.of(context)!.duree}: ${phaseResp.duree}",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ));
  }
}
