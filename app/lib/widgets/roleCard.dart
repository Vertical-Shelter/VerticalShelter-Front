import 'package:app/Vertical-Tracking/VSL/createTeam/createTeamController.dart';
import 'package:app/core/app_export.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final String point;
  final String image;
  final bool isDisable;
  RxString selectedRole = "".obs;
//  final CreateTeamcontroller? teamcontroller;

  RoleCard({
    required this.title,
    required this.description,
    required this.point,
    required this.image,
    required this.isDisable,
    required this.selectedRole,
    // required this.teamcontroller,
  });

  @override
  Widget build(BuildContext context) {
    return 
    // GestureDetector(
    //   onTap: () {
    //     teamcontroller!.selectedRole.value = title;
    //   },
    //   child: 
      Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Obx(() => Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: width,
                      height: 160,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selectedRole.value == title
                            ? ColorsConstantDarkTheme.purple
                            : null,
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
                                    .labelLarge
                                    ?.copyWith(
                                      color: ColorsConstantDarkTheme.secondary,
                                    ),
                              ),
                              Text(
                                description,
                                style: Theme.of(context).textTheme.labelMedium,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                point,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color:
                                            ColorsConstantDarkTheme.secondary,
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
          if (isDisable)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                color: ColorsConstantDarkTheme.background.withOpacity(0.7),
              ),
            )
          )
                  ])),
        ),
    );
  }
}
