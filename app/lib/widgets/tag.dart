import 'package:app/core/app_export.dart';

// ignore: must_be_immutable
class TagWidget extends StatelessWidget {
  static double max_width = 150;

  String tag;
  bool isDone;
  bool isNext;
  bool isRecent;

  TagWidget(
      {required this.tag,
      this.isDone = false,
      this.isNext = false,
      this.isRecent = false});

  Widget isDoneWidget(BuildContext context) {
    var _color = Theme.of(context).colorScheme.surface;
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primary),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Icon(
          Icons.check,
          color: _color,
          size: 16,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          tag,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: _color),
        )
      ]),
    );
  }

  Widget isNextWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.tertiary),
      child: Center(
          child: Text(
        tag,
        style: Theme.of(context).textTheme.bodySmall,
      )),
    );
  }

  Widget isRecentWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.secondary),
      child: Center(
          child: Text(
        tag,
        style: Theme.of(context).textTheme.bodySmall,
      )),
    );
  }

  Widget isDefaultWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.onSurface),
      child: Center(
          child: Text(
        tag,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.surface,
            ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isDone) {
      return isDoneWidget(context);
    } else if (isNext) {
      return isNextWidget(context);
    } else if (isRecent) {
      return isRecentWidget(context);
    } else {
      return isDefaultWidget(context);
    }
  }
}
