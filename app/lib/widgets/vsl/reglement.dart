import 'package:app/core/app_export.dart';
import 'package:app/widgets/buttonWidget.dart';

class ReglementVsl extends StatelessWidget {
  ReglementVsl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      height: 70,
      width: width,
      onPressed: () {
        Get.toNamed(AppRoutesVT.descriptionVSL);
      },
      child: Row(children: [
        SizedBox(width: 10),
        Image.asset(
          'assets/images/mascot_gecko.png',
          height: 50,
        ),
        SizedBox(width: 10),
        Image.asset(
          'assets/images/mascot_gorille.png',
          height: 50,
        ),
        Spacer(),
        Text(
          AppLocalizations.of(context)!.reglement,
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: ColorsConstantDarkTheme.purple,
              fontWeight: FontWeight.bold),
        ),
        Spacer(),
        SizedBox(width: 10),
        Image.asset(
          'assets/images/mascot_ninja.png',
          height: 50,
        ),
        SizedBox(width: 20),
      ]),
    );
  }
}
