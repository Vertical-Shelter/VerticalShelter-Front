import 'package:app/widgets/snappingSheet/src/on_drag_wrapper.dart';
import 'package:app/widgets/snappingSheet/src/scroll_controller_override.dart';
import 'package:app/widgets/snappingSheet/src/sheet_size_calculator.dart';
import 'package:app/widgets/snappingSheet/src/snapping_calculator.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_content.dart';
import 'package:flutter/widgets.dart';

class SheetContentWrapper extends StatefulWidget {
  final SheetSizeCalculator sizeCalculator;
  final SnappingSheetContent? sheetData;

  final Function(double) dragUpdate;
  final VoidCallback dragEnd;
  final double currentPosition;
  final SnappingCalculator snappingCalculator;
  final Axis axis;

  const SheetContentWrapper(
      {Key? key,
      required this.sheetData,
      required this.sizeCalculator,
      required this.currentPosition,
      required this.snappingCalculator,
      required this.dragUpdate,
      required this.dragEnd,
      required this.axis})
      : super(key: key);

  @override
  _SheetContentWrapperState createState() => _SheetContentWrapperState();
}

class _SheetContentWrapperState extends State<SheetContentWrapper> {
  Widget _wrapWithDragWrapper(Widget child) {
    return OnDragWrapper(
      axis: widget.axis,
      dragEnd: widget.dragEnd,
      child: child,
      dragUpdate: widget.dragUpdate,
    );
  }

  Widget _wrapWithScrollControllerOverride(Widget child) {
    return ScrollControllerOverride(
      axis: widget.axis,
      sizeCalculator: widget.sizeCalculator,
      scrollController: widget.sheetData!.childScrollController!,
      dragUpdate: widget.dragUpdate,
      dragEnd: widget.dragEnd,
      currentPosition: widget.currentPosition,
      snappingCalculator: widget.snappingCalculator,
      sheetLocation: widget.sheetData!.location,
      child: child,
    );
  }

  Widget _wrapWithNecessaryWidgets(Widget child) {
    Widget wrappedChild = child;
    if (widget.sheetData!.draggable) {
      if (widget.sheetData!.childScrollController != null) {
        wrappedChild = _wrapWithScrollControllerOverride(wrappedChild);
      } else {
        wrappedChild = _wrapWithDragWrapper(wrappedChild);
      }
    }
    return wrappedChild;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sheetData == null) return SizedBox();
    return widget.sizeCalculator.positionWidget(
      child: _wrapWithNecessaryWidgets(widget.sheetData!.child),
    );
  }
}
