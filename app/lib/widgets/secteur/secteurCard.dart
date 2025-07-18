import 'package:app/core/app_export.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/widgets/walls/wallMinimalistOuvreurWidget.dart';

class SecteurCard extends StatefulWidget {
  List<WallResp> wallList;
  String secteurName;
  SecteurCard({required this.wallList, required this.secteurName});

  @override
  _SecteurCardState createState() => _SecteurCardState();
}

class _SecteurCardState extends State<SecteurCard> {
  bool isExpanded = false;
  String climbingId = "";

  @override
  void initState() {
    super.initState();
    climbingId =
        Get.find<MultiAccountManagement>().actifAccount!.climbingLocationId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Theme.of(context).brightness == Brightness.dark
                  ? AssetImage("assets/images/VS-Outside-White.png")
                  : AssetImage("assets/images/VS-Outside-Black.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.surface.withOpacity(0.89),
                  Theme.of(context).brightness == Brightness.dark
                      ? BlendMode.darken
                      : BlendMode.lighten)),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    widget.secteurName,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
              Expanded(
                  child: Text(
                      "${widget.wallList.length} ${AppLocalizations.of(context)!.blocs}",
                      style: Theme.of(context).textTheme.bodyMedium)),
              Expanded(
                  child: IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(
                    isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ))
            ]),
            SizedBox(
              height: 10,
            ),
            Visibility(
                visible: isExpanded,
                child: ListView.separated(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.wallList.length + 1,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index == widget.wallList.length) {
                        return SizedBox(height: 10);
                      } else {
                        return WallMinimalistOuvreurWidget(
                          onPressed: () => Get.toNamed(
                              AppRoutesVS.WallScreenRoute,
                              parameters: {
                                'wallId': widget.wallList[index].id!,
                                'SecteurId':
                                    widget.wallList[index].secteurResp!.id,
                                'climbingLocationId': climbingId,
                              }),
                          wallMinimalResp: widget.wallList[index],
                        );
                      }
                    }))
          ],
        ));
  }
}
