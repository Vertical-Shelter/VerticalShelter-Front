import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/APIrequest.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_req.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:app/utils/climbingLocationController.dart';

class AttributeNameWidget extends StatefulWidget {
  List<String> selectedAttribute;
  List<TextEditingController> controllers;
  final Future<void> Function(Map<String, dynamic>)? onTap;

  AttributeNameWidget(
      {this.onTap,
      required this.selectedAttribute,
      this.controllers = const []})
      : super(key: GlobalKey());

  @override
  _AttributeNameWidgetState createState() => _AttributeNameWidgetState();
}

class _AttributeNameWidgetState extends State<AttributeNameWidget> {
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
                      // scrollPhysics: NeverScrollableScrollPhysics(),
                      textAlign: TextAlign.center,
                      cursorColor: Theme.of(context).colorScheme.secondary,
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
                    if (widget.selectedAttribute
                        .contains(widget.controllers[index].text)) {
                      widget.selectedAttribute
                          .remove(widget.controllers[index].text);
                      return;
                    }
                    if (widget.selectedAttribute.length < 3) {
                      widget.selectedAttribute
                          .add(widget.controllers[index].text);
                    } else {
                      Get.snackbar(AppLocalizations.of(context)!.erreur,
                          AppLocalizations.of(context)!.max_3_attributs);
                    }

                    if (widget.onTap != null) {
                      widget.onTap!({"attribute": widget.selectedAttribute});
                    }
                  }),
              child: Opacity(
                  opacity: widget.selectedAttribute
                          .contains(widget.controllers[index].text)
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

  Future<void> patchAttributesList() async {
    List<String> Attributes = [];
    for (int i = 0; i < widget.controllers.length; i++) {
      Attributes.add(widget.controllers[i].text);
    }
    if (Attributes.isEmpty) {
      Get.snackbar(AppLocalizations.of(context)!.erreur,
          AppLocalizations.of(context)!.pas_de_style);
      return;
    }
    String climbingLocationId =
        Get.find<MultiAccountManagement>().actifAccount!.climbingLocationId;
    climbingLocation_put(
        climbingLocationId, ClimbingLocationReq(attributes: Attributes));
    try {
      Get.find<ClimbingLocationController>().climbingLocationResp!.attributes =
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
          Text(AppLocalizations.of(context)!.type_de_bloc),
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
                    patchAttributesList();
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
