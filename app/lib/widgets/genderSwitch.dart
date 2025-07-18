import 'package:app/Vertical-Tracking/VSL/createTeam/createTeamController.dart';
import 'package:app/core/app_export.dart';

class GenderSwitch extends StatefulWidget {
  CreateTeamcontroller controller;
  GenderSwitch({required this.controller});
  @override
  _GenderSwitchState createState() => _GenderSwitchState();
}

class _GenderSwitchState extends State<GenderSwitch> {
  bool isFemale = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFemale = !isFemale;
          widget.controller.isMale.value = isFemale;
        });
      },
      child: Container(
        width: width * 0.25,
        height: 40,
        decoration: BoxDecoration(
          color: isFemale
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              duration: Duration(milliseconds: 300),
              alignment:
                  isFemale ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isFemale
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.onSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(isFemale ? 'F' : 'H',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isFemale
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
