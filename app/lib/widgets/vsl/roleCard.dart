import 'package:app/Vertical-Tracking/VSL/createTeam/createTeamController.dart';
import 'package:app/core/app_export.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final String point;
  final String image;
  final bool isSelected;
  final void Function()? onTap;

  const RoleCard({
    required this.title,
    required this.description,
    required this.point,
    required this.isSelected,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: width,
                    height: 160,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? ColorsConstantDarkTheme.purple : null,
                      border: Border.all(
                          color: ColorsConstantDarkTheme.secondary, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Spacer(),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: ColorsConstantDarkTheme.secondary,
                                  ),
                            ),
                            Text(
                              point,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              description,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: ColorsConstantDarkTheme.secondary,
                                      fontStyle: FontStyle.italic),
                            )
                          ],
                        )),
                      ],
                    ),
                  ),
                  Positioned(
                      left: 0,
                      child: Image.asset(
                        image,
                        width: 190,
                      )),
                ])),
      ),
    );
  }
}
