import 'package:app/data/models/grade/gradeResp.dart';
import 'package:app/widgets/createWallWidgets/attributesWidget.dart';
import 'package:app/widgets/colorFilter/colorFilterController.dart';
import 'package:app/widgets/colorFilter/colorsFilterWidget.dart';
import 'package:app/widgets/colorFilter/gradeSquareWidget.dart';
import 'package:app/widgets/createWallWidgets/holdsWidget.dart';
import 'package:app/widgets/createWallWidgets/ouvreurNameWidgets.dart';
import 'package:app/widgets/textFieldsWidget.dart';
import 'package:app/widgets/vid%C3%A9oCapture.dart';
import 'package:app/core/app_export.dart';
import 'package:expandable/expandable.dart';

class CreateWallWidget extends StatefulWidget {
  String? wallId;
  void Function(int) onPressTrash;
  int removeIndex;
  String? Function(dynamic) validator;
  String? typeError;
  List<GradeResp> system;
  String initialDesc;
  String initialPrise;
  String initialOuvreur;
  ExpandableController expandableController;
  List<String> attributesAllList = [];
  List<String> initialAttributes = [];
  List<TextEditingController> ouvreurNames;
  late OuvreurNameWidget ouvreurNameWidget;
  late AttributeNameWidget attributeNameWidget;
  late HoldNameWidget holdNameWidget;
  TextEditingController description = TextEditingController();
  List<String> holds = [];
  String text;
  DateTime date;
  late ColorFilterController colorFilterController;
  late VideoCapture videoCapture;
  late bool isAmbaddaseur;
  Key? key;
  CreateWallWidget(
      {this.wallId,
      required this.removeIndex,
      required this.onPressTrash,
      required this.holds,
      required this.validator,
      this.isAmbaddaseur = false,
      required this.expandableController,
      required this.system,
      required this.attributesAllList,
      required this.text,
      required this.videoCapture,
      this.initialAttributes = const [],
      required this.date,
      required this.ouvreurNames,
      this.initialOuvreur = "",
      this.initialDesc = "",
      required this.key,
      this.initialPrise = ""})
      : super(key: key) {
    description.text = initialDesc;
    holdNameWidget = HoldNameWidget(
      controllers: holds.map((e) => TextEditingController(text: e)).toList(),
      selectedHold: initialPrise,
    );

    colorFilterController =
        ColorFilterController(gradesTree: GradeTreeFromList(system));
    attributeNameWidget = AttributeNameWidget(
      controllers:
          attributesAllList.map((e) => TextEditingController(text: e)).toList(),
      selectedAttribute: initialAttributes.map((e) => e).toList(),
    );
    ouvreurNameWidget = OuvreurNameWidget(
      controllers: ouvreurNames,
      selectedOuvreur: initialOuvreur,
    );
  }
  @override
  CreateWallWidgetState createState() => CreateWallWidgetState();
}

class CreateWallWidgetState extends State<CreateWallWidget> {
  late TextEditingController description;

  late String? Function(dynamic) validator;
  String? typeError;
  late List<GradeResp> system;
  late DateTime date;
  late String text;
  late ColorFilterController colorFilterController;
  late VideoCapture videoCapture;
  String? wallId;
  late void Function(int) onPressTrash;
  late int removeIndex;

  //set _selectedAttributes corresponding to the selected attributesAllList in values

  @override
  void initState() {
    super.initState();
    wallId = widget.wallId;
    date = widget.date;
    removeIndex = widget.removeIndex;
    onPressTrash = widget.onPressTrash;
    validator = widget.validator;
    system = widget.system;
    text = widget.text;
    colorFilterController = widget.colorFilterController;
    videoCapture = widget.videoCapture;
    description = widget.description;

    colorFilterController.selectedGrade.listen((p0) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
        controller: widget.expandableController,
        theme: ExpandableThemeData(
          iconColor: Theme.of(context).colorScheme.onSurface,
        ),
        header: Container(
          padding:
              const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: Theme.of(context).colorScheme.primary),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(text),
            colorFilterController.selectedGrade.value == null
                ? SizedBox()
                : GradeSquareWidget.fromGrade(
                    colorFilterController.selectedGrade.value!),
            //NIEN ?
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                onPressTrash(removeIndex);
              },
            )
          ]),
        ),
        collapsed: SizedBox(),
        expanded: Container(
            padding: const EdgeInsets.all(10),
            child: Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                LimitedBox(maxHeight: 80, child: widget.ouvreurNameWidget),
                SizedBox(
                  height: 20,
                ),
                Text(AppLocalizations.of(context)!.donnez_une_cotation),
                SizedBox(
                  height: 10,
                ),
                ColorFilterWidget(colorFilterController),
                SizedBox(
                  height: 10,
                ),

                //date picker
                Row(children: [
                  Text(AppLocalizations.of(context)!.date),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2025),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              textTheme: TextTheme(
                                labelLarge:
                                    Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) => setState(() {
                            if (value != null) {
                              date = value;
                              widget.date = date;
                            }
                          }));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary)),
                      child: Text(date.day.toString() +
                          "/" +
                          date.month.toString() +
                          "/" +
                          date.year.toString()),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 10,
                ),
                widget.isAmbaddaseur
                    ? SizedBox()
                    : Text(
                        AppLocalizations.of(context)!.video,
                      ),
                widget.isAmbaddaseur
                    ? SizedBox()
                    : Container(
                        alignment: Alignment.center,
                        height: height * 0.21,
                        child: videoCapture,
                      ),
                SizedBox(
                  height: 20,
                ),

                LimitedBox(maxHeight: 80, child: widget.attributeNameWidget),
                if (typeError != null)
                  Text(
                    typeError!,
                  ),
                SizedBox(
                  height: 20,
                ),
                LimitedBox(maxHeight: 80, child: widget.holdNameWidget),
                SizedBox(
                  height: 20,
                ),
                widget.isAmbaddaseur
                    ? SizedBox()
                    : Text(AppLocalizations.of(context)!.description),
                widget.isAmbaddaseur
                    ? SizedBox()
                    : SizedBox(
                        height: 10,
                      ),
                widget.isAmbaddaseur
                    ? SizedBox()
                    : TextFieldWidget(
                        controller: description,
                        hintText: AppLocalizations.of(context)!.description,
                        validator: (value) => null,
                        fillColor: ColorsConstant.white,
                      ),
              ],
            ))));
  }
}
