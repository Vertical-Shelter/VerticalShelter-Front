import 'package:app/core/app_export.dart';

var languageName = {
  'en': 'English',
  'fr': 'Francais',
};

OnChangeLanguageTap(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) => Container(
          padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
          child: Column(children: [
            Container(
              height: height * 0.01,
              width: width * 0.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.onSurface),
            ),
            SizedBox(height: 20),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                if (AppLocalizations.supportedLocales[index].languageCode ==
                    Get.locale!.languageCode) {
                  return Row(children: [
                    Icon(Icons.check_circle_outlined,
                        color: Theme.of(context).colorScheme.primary),
                    SizedBox(width: 30),
                    Text(
                        languageName[AppLocalizations
                                .supportedLocales[index].languageCode] ??
                            AppLocalizations
                                .supportedLocales[index].languageCode,
                        style: Theme.of(context).textTheme.bodyMedium!),
                  ]);
                }
                return Row(children: [
                  Icon(Icons.circle_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  SizedBox(width: 30),
                  TextButton(
                      onPressed: () {
                        Get.find<PrefUtils>().addLocal(AppLocalizations
                            .supportedLocales[index].languageCode);
                        Get.updateLocale(
                            AppLocalizations.supportedLocales[index]);
                        Get.reloadAll();
                        Get.back();
                      },
                      child: Text(
                          languageName[AppLocalizations
                                  .supportedLocales[index].languageCode] ??
                              AppLocalizations
                                  .supportedLocales[index].languageCode,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyMedium!))
                ]);
              },
              itemCount: AppLocalizations.supportedLocales.length,
            )),
          ])));
}
