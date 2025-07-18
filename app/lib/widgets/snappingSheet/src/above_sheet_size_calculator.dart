import 'package:app/widgets/snappingSheet/src/sheet_size_calculator.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_content.dart';
import 'package:flutter/widgets.dart';

class AboveSheetSizeCalculator extends SheetSizeCalculator {
  final SnappingSheetContent? sheetData;
  final double currentPosition;
  final double maxHeight;
  final double grabbingHeight;
  final Axis axis;

  AboveSheetSizeCalculator(
      {this.sheetData,
      required this.currentPosition,
      required this.maxHeight,
      required this.axis,
      required this.grabbingHeight})
      : super(sheetData, maxHeight);

  @override
  double getSheetEndPosition() {
    return currentPosition + grabbingHeight / 2;
  }

  @override
  double getVisibleHeight() {
    return this.maxHeight - getSheetEndPosition();
  }

  @override
  Positioned positionWidget({required Widget child}) {
    if (this.axis == Axis.horizontal) {
      return Positioned(
        top: 0,
        bottom: 0,
        right: getSheetStartPosition(),
        left: getSheetEndPosition(),
        child: child,
      );
    }
    return Positioned(
      left: 0,
      right: 0,
      top: getSheetStartPosition(),
      bottom: getSheetEndPosition(),
      child: child,
    );
  }
}
