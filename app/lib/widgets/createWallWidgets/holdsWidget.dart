import 'package:app/Vertical-Setting/BottomBar/bottomBarController.dart';
import 'package:app/Vertical-Setting/home/homeController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/APIrequest.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_req.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/utils/climbingLocationController.dart';
import 'package:http/http.dart';

class HoldNameWidget extends StatefulWidget {
  String? selectedHold;
  List<TextEditingController> controllers;
  final Future<void> Function(Map<String, dynamic>)? onTap;

  HoldNameWidget({this.onTap, this.selectedHold, this.controllers = const []})
      : super(key: GlobalKey());

  @override
  _HoldNameWidgetState createState() => _HoldNameWidgetState();
}

class _HoldNameWidgetState extends State<HoldNameWidget> {
  bool isEditing = false;
  List<FocusNode> focusNodes = [];

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
                      minWidth: 50, maxWidth: 170, maxHeight: 50),
                  child: TextField(
                      controller: widget.controllers[index],
                      // autofocus: isAutoFocus,
                      // readOnly: isReadOnly,
                      focusNode: focusNodes[index],
                      onEditingComplete: () => setState(() {
                            widget.selectedHold =
                                widget.controllers[index].text.trim();
                            widget.controllers[index].text =
                                widget.controllers[index].text.trim();
                            patchHoldsList();
                          }),
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        isDense: true,
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
                    if (widget.selectedHold == widget.controllers[index].text) {
                      widget.selectedHold = null;
                    } else {
                      widget.selectedHold = widget.controllers[index].text;
                    }
                    if (widget.onTap != null)
                      widget.onTap!({"Hold": widget.selectedHold});
                  }),
              child: Opacity(
                  opacity: widget.selectedHold == widget.controllers[index].text
                      ? 1
                      : 0.5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    constraints: BoxConstraints(maxHeight: 40),
                    child: Center(
                      child: Text(
                        widget.controllers[index].text,
                        style: TextStyle(
                          color: ColorsConstantDarkTheme.background,
                        ),
                      ),
                    ),
                  )));
        });
  }

  Future<void> patchHoldsList() async {
    List<String> Holds = [];
    for (int i = 0; i < widget.controllers.length; i++) {
      Holds.add(widget.controllers[i].text);
    }
    if (Holds.isEmpty) {
      Get.snackbar(AppLocalizations.of(context)!.erreur,
          AppLocalizations.of(context)!.pas_de_prises);
      return;
    }
    String climbingLocationId =
        Get.find<MultiAccountManagement>().actifAccount!.climbingLocationId;
    climbingLocation_put(
        climbingLocationId, ClimbingLocationReq(holds_color: Holds));
    try {
      Get.find<ClimbingLocationController>().climbingLocationResp!.holds_color =
          widget.controllers.map((e) => e.text).toList();
    } catch (e) {
      print(e);
    }
    isEditing = !isEditing;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(children: [
          Text(AppLocalizations.of(context)!.prise),
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
                    patchHoldsList();
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
