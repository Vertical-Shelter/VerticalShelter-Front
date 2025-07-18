import 'package:app/core/app_export.dart';
import 'package:app/data/models/User/skills_resp.dart';
import 'package:app/widgets/tag.dart';
import 'package:flutter/material.dart';

class SkillWidget extends StatefulWidget {
  final SkillResp skillResp;

  SkillWidget({Key? key, required this.skillResp}) : super(key: key);

  @override
  _SkillWidgetState createState() => _SkillWidgetState();
}

class _SkillWidgetState extends State<SkillWidget>
    with SingleTickerProviderStateMixin {
  late SkillResp skillResp;
  late AnimationController controller;

  @override
  void initState() {
    skillResp = widget.skillResp;

    controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: skillResp.xp_current_level! / skillResp.xp_next_level!,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (skillResp.xp_current_level! / skillResp.xp_next_level! > 0) {
      controller
          .animateTo(skillResp.xp_current_level! / skillResp.xp_next_level!);
    }
    return AnimatedContainer(
      padding: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.onSurface,
            Theme.of(context).colorScheme.onSurface,
          ],
          stops: [0, controller.value, controller.value, 1],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      duration: controller.duration!,
      child: Container(
        padding:
            const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          image: DecorationImage(
              image: AssetImage("assets/images/VS-Outside-White.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.surface.withOpacity(0.85),
                  BlendMode.darken)),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.network(
              skillResp.icon!,
            ),
            SizedBox(width: width * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    skillResp.display_name!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(width: width * 0.01),
                  TagWidget(
                      tag:
                          "${AppLocalizations.of(context)!.niveau} ${skillResp.level}"),
                ]),
                SizedBox(height: height * 0.01),
                SizedBox(
                    width: width * 0.7,
                    child: Text(
                      skillResp.description!,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.bodySmall,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the animation controller
    controller.dispose();
    super.dispose();
  }
}
