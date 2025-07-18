import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/APIrequest.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_req.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/utils/climbingLocationController.dart';

class OuvreurNameWidget extends StatefulWidget {
  String? selectedOuvreur;
  List<TextEditingController> controllers;
  final Future<void> Function(Map<String, dynamic>)? onTap;

  OuvreurNameWidget(
      {this.onTap, this.selectedOuvreur, this.controllers = const []})
      : super(key: GlobalKey());

  @override
  _OuvreurNameWidgetState createState() => _OuvreurNameWidgetState();
}

class _OuvreurNameWidgetState extends State<OuvreurNameWidget>
    with AutomaticKeepAliveClientMixin {
  bool isEditing = false;
  List<FocusNode> focusNodes = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print("i am here");
    for (int i = 0; i < widget.controllers.length; i++) {
      focusNodes.add(FocusNode());
    }
  }

  Widget stateEditing() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 10,
          );
        },
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.controllers.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == widget.controllers.length) {
            return IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  widget.controllers.add(TextEditingController());
                  focusNodes.add(FocusNode());
                  focusNodes[focusNodes.length - 1].requestFocus();
                });
              },
            );
          }
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  constraints: BoxConstraints(
                      minWidth: 50, maxWidth: 100, maxHeight: 50),
                  child: TextField(
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      controller: widget.controllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      onEditingComplete: () => setState(() {
                            widget.selectedOuvreur =
                                widget.controllers[index].text.trim();
                            widget.controllers[index].text =
                                widget.controllers[index].text.trim();
                            patchOuvreursList();
                          }),
                      onSubmitted: (value) {
                        print('submitted');
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        border: InputBorder.none,
                      ),
                      style: AppTextStyle.rr14)),
              Positioned(
                  right: -15,
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          widget.controllers.removeAt(index);
                          focusNodes.removeAt(index);
                        });
                      },
                      icon: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        radius: 7,
                        child: Icon(
                          Icons.close,
                          size: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )))
            ],
          );
        });
  }

  Widget stateSelection() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 10,
          );
        },
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.controllers.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () => setState(() {
                    if (widget.selectedOuvreur ==
                        widget.controllers[index].text) {
                      widget.selectedOuvreur = null;
                    } else {
                      widget.selectedOuvreur = widget.controllers[index].text;
                    }
                    if (widget.onTap != null) {
                      widget.onTap!({"ouvreur": widget.selectedOuvreur});
                    }
                  }),
              child: Opacity(
                  opacity:
                      widget.selectedOuvreur == widget.controllers[index].text
                          ? 1
                          : 0.5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    constraints: BoxConstraints(maxHeight: 40),
                    alignment: Alignment.center,
                    child: Text(
                      widget.controllers[index].text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorsConstantDarkTheme.background,
                      ),
                    ),
                  )));
        });
  }

  Future<void> patchOuvreursList() async {
    List<String> ouvreurs = [];
    for (int i = 0; i < widget.controllers.length; i++) {
      ouvreurs.add(widget.controllers[i].text);
    }
    if (ouvreurs.isEmpty) {
      Get.snackbar(AppLocalizations.of(context)!.erreur,
          AppLocalizations.of(context)!.pas_douvreur_dans_la_salle);
      return;
    }
    String climbingLocationId =
        Get.find<MultiAccountManagement>().actifAccount!.climbingLocationId;
    climbingLocation_put(
        climbingLocationId, ClimbingLocationReq(ouvreurNames: ouvreurs));
    try {
      Get.find<ClimbingLocationController>()
          .climbingLocationResp!
          .ouvreurNames = ouvreurs;
    } catch (e) {
      print(e);
    }
    isEditing = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(children: [
          Text(AppLocalizations.of(context)!.ouvreur + "s"),
          Spacer(),
          IconButton(
              onPressed: () {
                for (int i = 0; i < widget.controllers.length; i++) {
                  if (widget.controllers[i].text.isEmpty) {
                    widget.controllers.removeAt(i);
                  }
                }
                setState(() {
                  //check if some fields are empty
                  if (isEditing) {
                    patchOuvreursList();
                  } else
                    isEditing = !isEditing;
                });
              },
              icon: Icon(isEditing ? Icons.check : Icons.edit))
        ]),
        !isEditing
            ? Expanded(child: stateSelection())
            : Expanded(child: stateEditing()),
      ],
    );
  }
}
