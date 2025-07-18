import 'package:flutter/material.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/grade/gradeResp.dart';
import 'package:app/widgets/genericButton.dart';

class ButtonList extends StatefulWidget {
  RxList<GradeResp> system;
  RxMap<String, int>? numberOfWall;
  GradeResp? selectedGrade;
  Future<void> Function(Map<String, dynamic>)? onPressed;
  ButtonList(
      {required this.system,
      this.numberOfWall,
      this.onPressed,
      this.selectedGrade});
  @override
  _ButtonListState createState() => _ButtonListState();
}

class _ButtonListState extends State<ButtonList> {
  late bool isBlueButtonsVisible;
  int? _currentButtonActive;
  final List<Rx<Color>> _colorsList = <Rx<Color>>[].obs;
  List<GradeResp> system = [];
  final List<Widget> _colors = <Widget>[];
  final List<Widget> _subColors = <Widget>[];
  final List<Rx<Color>> _subColorsList = <Rx<Color>>[].obs;
  Future<void> Function(Map<String, dynamic>)? onPressed;
  RxMap<String, int>? _numberOfWall;
  Map<String, List<GradeResp>> colorsMap = {};

  void refreshOpacity(
      int index, Rx<Color> element, int index2, double opacity) {
    if (index == index2) {
      element.value = element.value.withOpacity(1);
    } else if (opacity == 1.0 && element.value.opacity != 1.0) {
      element.value = element.value.withOpacity(1);
    } else {
      element.value = element.value.withOpacity(0.3);
    }
    element.refresh();
  }

  void generateSubColorList(int i, GradeResp? _selectedColor, Color _color) {
    _subColorsList.addAll(
        List.generate(colorsMap.entries.elementAt(i).value.length, (index) {
      return _color.obs;
    }));
    _subColors.addAll(List.generate(
        colorsMap.entries.elementAt(i).value.length,
        (index) => Container(
            padding: EdgeInsets.only(right: 5),
            child: Obx(
              () => GenericButtonWidget(
                borderColor: Colors.transparent,
                button: Text(
                  colorsMap.entries.elementAt(i).value[index].ref2!,
                  style: AppTextStyle.rm20
                      .copyWith(color: ColorsConstant.orangeText),
                ),
                onPressed: () async {
                  widget.selectedGrade =
                      colorsMap.entries.elementAt(i).value[index];
                  double _currentButtonActiveOpacity =
                      _subColorsList[index].value.opacity;
                  _subColorsList.asMap().forEach((index2, element) {
                    refreshOpacity(
                        index, element, index2, _currentButtonActiveOpacity);
                  });
                },
                color: _subColorsList[index].value,
                height: MediaQuery.of(Get.context!).size.height * 0.0486,
                width: MediaQuery.of(Get.context!).size.width * 0.1051,
              ),
            ))));
  }

  void generateColorList() {
    for (int i = 0; i < colorsMap.length; i++) {
      Color _color = ColorsConstant.redAction;
      try {
        _color = ColorsConstant.fromHex(system[i].ref1);
      } catch (e) {
        continue;
      }

      _colorsList.add(_color.obs);
      _colors.add(Obx(() => GenericButtonWidget(
            borderColor: Colors.transparent,
            button: Obx(() => _numberOfWall!.isEmpty
                ? Container()
                : Text(
                    _numberOfWall![system[i].ref1] == null
                        ? "0"
                        : _numberOfWall![system[i].ref1].toString(),
                    style: AppTextStyle.rm20
                        .copyWith(color: ColorsConstant.orangeText))),
            onPressed: () async {
              _subColors.clear();
              _subColorsList.clear();
              GradeResp? _selectedColor;
              if (colorsMap.entries.elementAt(i).value.isNotEmpty) {
                generateSubColorList(i, _selectedColor, _color);
              }
              _selectedColor = colorsMap.entries.elementAt(i).value[0];
              _currentButtonActive = (_currentButtonActive == i) ? null : i;

              if (_currentButtonActive == null) {
                _selectedColor = null;
              }

              double _currentButtonActiveOpacity = _colorsList[i].value.opacity;
              _colorsList.asMap().forEach((index, element) {
                refreshOpacity(i, element, index, _currentButtonActiveOpacity);
              });
              widget.selectedGrade = _selectedColor;
              if (onPressed != null) {
                print(widget.selectedGrade?.ref1);
                await onPressed!({'color': widget.selectedGrade?.ref1});
              } else {
                toggleButtons();
              }
            },
            color: _colorsList[i].value,
            height: MediaQuery.of(Get.context!).size.height * 0.0486,
            width: MediaQuery.of(Get.context!).size.width * 0.1051,
          )));
    }
  }

  @override
  void initState() {
    super.initState();
    system = widget.system;
    _numberOfWall = widget.numberOfWall;
    onPressed = widget.onPressed;
    for (int i = 0; i < system.length; i++) {
      if (colorsMap.containsKey(system[i].ref1)) {
        colorsMap[system[i].ref1]!.add(system[i]);
      } else {
        colorsMap[system[i].ref1] = [system[i]];
      }
    }
    _currentButtonActive = widget.selectedGrade == null
        ? null
        : colorsMap.keys.toList().indexOf(widget.selectedGrade!.ref1);
    isBlueButtonsVisible = (_currentButtonActive != null);

    generateColorList();

    if (_currentButtonActive != null) {
      Color _color = ColorsConstant.redAction;
      try {
        _color = ColorsConstant.fromHex(system[_currentButtonActive!].ref1);
      } catch (e) {
        _color = ColorsConstant.redAction;
      }

      generateSubColorList(_currentButtonActive!, widget.selectedGrade, _color);

      double _currentButtonActiveOpacity =
          _colorsList[_currentButtonActive!].value.opacity;
      _colorsList.asMap().forEach((index, element) {
        refreshOpacity(
            _currentButtonActive!, element, index, _currentButtonActiveOpacity);
      });

      int _index = colorsMap[system[_currentButtonActive!].ref1]!
          .indexOf(widget.selectedGrade!);
      _subColorsList.asMap().forEach((index, element) {
        refreshOpacity(
            _index, element, index, _subColorsList[index].value.opacity);
      });
    }
  }

  void toggleButtons() {
    setState(() {
      isBlueButtonsVisible = (_currentButtonActive != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    _subColors.insert(
        0,
        SizedBox(
            width: _currentButtonActive == null
                ? 0
                : _currentButtonActive! *
                    (MediaQuery.of(Get.context!).size.width * 0.1051 + 5)));
    return Column(children: [
      Row(
        children: _colors.fold(<Widget>[], (previousValue, element) {
          previousValue.add(element);
          previousValue.add(SizedBox(width: 5));
          return previousValue;
        }),
      ),
      SizedBox(
        height: height * 0.005,
      ),
      Visibility(
          visible: isBlueButtonsVisible, child: Row(children: _subColors)),
    ]);
  }
}
