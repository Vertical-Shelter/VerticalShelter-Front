import 'package:app/core/app_export.dart';

class BottomBarItem extends BottomNavigationBarItem {
  String iconName;
  String activeIconName;
  final String title;
  final Function? onTap;
  final BuildContext context = Get.context!;
  bool hasNotif;

  BottomBarItem(
      {required this.iconName,
      required this.activeIconName,
      required this.title,
      this.onTap,
      this.hasNotif = false})
      : super(icon: Container(), label: '');

  @override
  Widget get activeIcon => Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorsConstantDarkTheme.neutral_white,
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              SvgPicture.asset(
                activeIconName,
                width: 20,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.surface, BlendMode.srcIn),
              ),
              Spacer(),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: ColorsConstantDarkTheme.background,
                    ),
              )
            ]),
      );

  @override
  Widget get icon => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 60,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  SvgPicture.asset(
                    iconName,
                    width: 20,
                    // colorFilter: ColorFilter.mode(
                    //     Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                  ),
                  Spacer(),
                  Text(title, style: Theme.of(context).textTheme.bodySmall!)
                ]),
          ),
          if (hasNotif)
            Positioned(
                right: -2,
                top: 0,
                child: CircleAvatar(
                  radius: 3,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ))
        ],
      );
}
