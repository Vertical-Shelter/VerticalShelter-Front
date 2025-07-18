import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/skills_resp.dart';

class SkillsPopup extends StatefulWidget {
  final List<SkillResp> oldSkillResp;
  final List<SkillResp> newSkillResp;

  SkillsPopup({
    Key? key,
    required this.oldSkillResp,
    required this.newSkillResp,
  }) : super(key: key);

  @override
  _SkillsPopupState createState() => _SkillsPopupState();
}

class _SkillsPopupState extends State<SkillsPopup>
    with TickerProviderStateMixin {
  late final List<SkillResp> oldSkillResp;
  late final List<SkillResp> newSkillResp;
  late List<AnimationController> controllerList;
  @override
  void initState() {
    oldSkillResp = [
      for (var i = 0; i < widget.oldSkillResp.length; i++)
        widget.oldSkillResp[i]
    ];
    newSkillResp = [
      for (var i = 0; i < widget.newSkillResp.length; i++)
        widget.newSkillResp[i]
    ];
    //remove old skill and new skills when similar
    int i = 0;
    while (i < oldSkillResp.length) {
      if (oldSkillResp[i] == newSkillResp[i]) {
        oldSkillResp.removeAt(i);
        newSkillResp.removeAt(i);
      } else {
        i++;
      }
    }
    controllerList = [
      for (var i = 0; i < oldSkillResp.length; i++)
        AnimationController(
          vsync: this,
          lowerBound: 0.0,
          upperBound: newSkillResp[i].xp_current_level! /
              newSkillResp[i].xp_next_level!,
          duration: const Duration(milliseconds: 500),
        )..addListener(() {
            setState(() {});
          })
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < oldSkillResp.length; i++) {
      if (newSkillResp[i].xp_current_level! / newSkillResp[i].xp_next_level! >
          0) {
        controllerList[i].animateTo(
            newSkillResp[i].xp_current_level! / newSkillResp[i].xp_next_level!);
      }
    }
    if (oldSkillResp.isEmpty) {
      return Container();
    }
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 24, right: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, i) {
            bool hasLevelUp = newSkillResp[i].level! > oldSkillResp[i].level!;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  oldSkillResp[i].display_name!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                SizedBox(width: width * 0.02),
                Flexible(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: LinearProgressIndicator(
                        value: controllerList[i].value,
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor: ColorsConstantDarkTheme.neutral_grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      )),
                ),
                SizedBox(width: width * 0.02),
                hasLevelUp
                    ? Text(
                        "Level Up",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      )
                    : Text(
                        "${newSkillResp[i].xp_current_level! - oldSkillResp[i].xp_current_level!} xp",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      )
              ],
            );
          },
          separatorBuilder: (context, i) {
            return SizedBox(height: height * 0.02);
          },
          itemCount: oldSkillResp.length,
        ));
  }

  @override
  void dispose() {
    controllerList.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }
}
