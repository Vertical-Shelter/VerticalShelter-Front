import 'package:app/core/app_export.dart';
import 'package:app/data/models/Contest/contestResp.dart';

class BlocCard extends StatefulWidget {
  BlocResp bloc;
  List<bool> isSelected = [];
  BlocCard({required this.bloc, this.isSelected = const []});

  @override
  _BlocCardState createState() => _BlocCardState();
}

class _BlocCardState extends State<BlocCard> {
  late BlocResp bloc;
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
    if (widget.isSelected.isEmpty) {
      isSelected = List.generate(bloc.zones! + 1, (index) => false);
      widget.isSelected = isSelected;
    } else {
      isSelected = widget.isSelected;
    }
  }

  Widget buildHasZone() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < (bloc.zones! + 1)!; i++)
          Expanded(
              child: InkWell(
                  onTap: () {
                    setState(() {
                      //set all before or equal to i to false
                      if (isSelected[i] == false)
                        for (int j = 0; j <= i; j++) isSelected[j] = true;
                      else {
                        for (int j = i; j < bloc.zones! + 1; j++)
                          isSelected[j] = false;
                      }
                      widget.isSelected = isSelected;
                    });
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 10),
                      width: width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(isSelected[i] ? 1 : 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        i == bloc.zones!
                            ? '${bloc.numero} Top'
                            : '${bloc.numero} Zone ${i + 1}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                      ))))
      ],
    );
  }

  Widget buildNoZone() {
    return InkWell(
        onTap: () {
          setState(() {
            isSelected[0] = !isSelected[0];
          });
        },
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(isSelected[0] ? 1 : 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(bloc.numero.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 20,
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    return bloc.zones != 0 ? buildHasZone() : buildNoZone();
  }
}
