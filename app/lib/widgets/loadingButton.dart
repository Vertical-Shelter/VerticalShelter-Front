import 'dart:math';

import 'package:app/core/app_export.dart';

class LoadingButtonController {
  RxBool isLoading = false.obs;
  RxInt progress = 0.obs;

  onLoading() {
    isLoading.value = true;
    progress.value = 0;
    Future.delayed(Duration(milliseconds: 100), () {
      progress.value = 10;
    });
    Future.delayed(Duration(milliseconds: 200), () {
      progress.value = 20;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      progress.value += Random.secure().nextInt(10) + 3;
    });
    Future.delayed(Duration(milliseconds: 777), () {
      progress.value += Random.secure().nextInt(10) + 2;
    });
    Future.delayed(Duration(milliseconds: 900), () {
      progress.value += Random.secure().nextInt(5) + 30;
    });
  }
}

// ignore: must_be_immutable
class ValidateButtonLoading extends StatelessWidget {
  final Key? key;
  final VoidCallback? onPressed;
  final VoidCallback? onDone;
  final LoadingButtonController controller;
  final Widget icon;
  final Widget isDoneIcon;
  final bool isDone;

  ValidateButtonLoading({
    this.key,
    required this.icon,
    required this.isDoneIcon,
    required this.onDone,
    required this.controller,
    required this.isDone,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
        onTap: controller.isLoading.value
            ? null
            : isDone
                ? onDone
                : onPressed,
        child: controller.isLoading.value
            ? // Progress Bar following the progress value
            Container(
                decoration: BoxDecoration(
                    color: isDone
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(180)),
                width: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(180),
                    child: LinearProgressIndicator(
                        minHeight: MediaQuery.of(context).size.height * 0.05,
                        value: controller.progress.value / 100,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ))))
            : Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 24, right: 24),
                decoration: BoxDecoration(
                    color: isDone
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(180)),
                child: Row(children: [
                  isDone
                      ? Text(AppLocalizations.of(context)!.bloc_fait,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.surface))
                      : Text(AppLocalizations.of(context)!.valider,
                          style: Theme.of(context).textTheme.bodyMedium!),
                  SizedBox(width: width * 0.02),
                  isDone ? isDoneIcon : icon
                ]))));
  }
}
