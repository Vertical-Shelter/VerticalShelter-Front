import 'package:app/core/app_export.dart';

class SettingMenuElement {
  Widget icon;
  String text;
  Function(BuildContext) onPressed;

  SettingMenuElement(
      {required this.icon, required this.text, required this.onPressed});
}

class SettingMenuWidget extends StatelessWidget {
  final List<SettingMenuElement> elements;

  SettingMenuWidget({Key? key, required this.elements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: getPadding(left: 25, right: 25),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: height * 0.01,
            width: width * 0.3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.onSurface),
          ),
          SizedBox(
            height: 20,
          ),
          ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              // itemExtent: 50,
              itemCount: elements.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      elements[index].onPressed(context);
                    },
                    child: Row(
                      children: [
                        elements[index].icon,
                        SizedBox(
                          width: context.width * 0.05,
                        ),
                        Text(
                          elements[index].text,
                        ),
                      ],
                    ));
              }),
          SizedBox(
            height: 20,
          ),
        ]));
  }
}
