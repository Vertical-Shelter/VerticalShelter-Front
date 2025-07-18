import 'package:app/core/app_export.dart';

void onDefaultCancel(BuildContext context) {
  Navigator.of(context).pop();
}

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String mainText;
  final String? confirmText;
  final String? cancelText;
  final Function(BuildContext) onConfirm;
  final Function(BuildContext) onCancel;

  ConfirmDialog({
    required this.title,
    this.mainText = '',
    this.onCancel = onDefaultCancel,
    required this.onConfirm,
    this.cancelText,
    this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogHeight = screenHeight / 4;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: dialogHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  mainText,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: MaterialButton(
                    child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        child: Text(
                            cancelText ?? AppLocalizations.of(context)!.annuler,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ))),
                    onPressed: () {
                      onCancel(context);
                    },
                  ),
                ),
                Expanded(
                    child: MaterialButton(
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      child: Text(
                          confirmText ??
                              AppLocalizations.of(context)!.sauvegarder,
                          style: Theme.of(context).textTheme.bodyMedium!)),
                  onPressed: () {
                    onConfirm(context);
                  },
                )),
              ],
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
