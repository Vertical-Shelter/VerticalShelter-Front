import 'package:app/widgets/profil/profilImage.dart';

import 'package:app/core/app_export.dart';

class ProfileMiniAccount extends StatelessWidget {
  final String id;
  final String? name;
  final String? image;
  final Widget? trailing;
  final bool isGym;
  final void Function()? onTap;

  const ProfileMiniAccount(
      {Key? key,
      required this.id,
      required this.name,
      required this.isGym,
      required this.image,
      this.onTap,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.only(
                top: height * 0.021,
                bottom: height * 0.021,
                left: width * 0.04,
                right: width * 0.04),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                profileImage(image: image, size: height * 0.05),
                Column(children: [
                  Text(
                    name ?? "No name",
                  ),
                  Text(
                    isGym ? "   ${AppLocalizations.of(context)!.salle_descalade}" : "    ${AppLocalizations.of(context)!.grimpeur}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  )
                ]),
                trailing ?? Container()
              ],
            )));
  }
}
