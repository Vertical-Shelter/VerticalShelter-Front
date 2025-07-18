import 'package:app/widgets/snappingSheet/src/sheet_size_calculator.dart';
import 'package:app/widgets/snappingSheet/src/snapping_calculator.dart';
import 'package:app/widgets/snappingSheet/src/snapping_sheet_content.dart';
import 'package:flutter/widgets.dart';

class ScrollControllerOverride extends StatefulWidget {
  final SheetSizeCalculator sizeCalculator;
  final ScrollController scrollController;
  final SheetLocation sheetLocation;
  final Widget child;

  final Function(double) dragUpdate;
  final VoidCallback dragEnd;
  final double currentPosition;
  final SnappingCalculator snappingCalculator;
  final Axis axis;

  ScrollControllerOverride({
    required this.sizeCalculator,
    required this.scrollController,
    required this.dragUpdate,
    required this.dragEnd,
    required this.currentPosition,
    required this.snappingCalculator,
    required this.child,
    required this.sheetLocation,
    required this.axis,
  });

  @override
  _ScrollControllerOverrideState createState() =>
      _ScrollControllerOverrideState();
}

class _ScrollControllerOverrideState extends State<ScrollControllerOverride> {
  DragDirection? _currentDragDirection;
  double _currentLockPosition = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.removeListener(_onScrollUpdate);
    widget.scrollController.addListener(_onScrollUpdate);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScrollUpdate);
    super.dispose();
  }

  void _onScrollUpdate() {
    if (!_allowScrolling) _lockScrollPosition(widget.scrollController);
  }

  void _overrideScroll(double dragAmount) {
    if (!_allowScrolling) widget.dragUpdate(dragAmount);
  }

  void _setLockPosition() {
    if (_currentDragDirection == DragDirection.up &&
            widget.sheetLocation == SheetLocation.below ||
        _currentDragDirection == DragDirection.down &&
            widget.sheetLocation == SheetLocation.above) {
      _currentLockPosition = widget.scrollController.position.pixels;
    } else {
      _currentLockPosition = 0;
    }
  }

  bool get _allowScrolling {
    if (widget.sheetLocation == SheetLocation.below) {
      if (_currentDragDirection == DragDirection.up) {
        if (widget.currentPosition >= _biggestSnapPos)
          return true;
        else
          return false;
      }
      if (_currentDragDirection == DragDirection.down) {
        if (widget.scrollController.position.pixels > 0) return true;
        if (widget.currentPosition <= _smallestSnapPos)
          return true;
        else
          return false;
      }
    }

    if (widget.sheetLocation == SheetLocation.above) {
      if (_currentDragDirection == DragDirection.down) {
        if (widget.currentPosition <= _smallestSnapPos) {
          return true;
        } else
          return false;
      }
      if (_currentDragDirection == DragDirection.up) {
        if (widget.scrollController.position.pixels > 0) return true;
        if (widget.currentPosition >= _biggestSnapPos)
          return true;
        else
          return false;
      }
    }

    return false;
  }

  double get _biggestSnapPos =>
      widget.snappingCalculator.getBiggestPositionPixels();
  double get _smallestSnapPos =>
      widget.snappingCalculator.getSmallestPositionPixels();

  void _lockScrollPosition(ScrollController controller) {
    // controller.position.setPixels(_currentLockPosition);
  }

  void _setDragDirection(double dragAmount) {
    this._currentDragDirection =
        dragAmount > 0 ? DragDirection.down : DragDirection.up;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (dragEvent) {
        final dragValue = widget.axis == Axis.horizontal
            ? -dragEvent.delta.dx
            : dragEvent.delta.dy;
        _setDragDirection(dragValue);
        _setLockPosition();
        _overrideScroll(dragValue);
      },
      onPointerUp: (_) {
        if (!_allowScrolling)
          widget.scrollController.jumpTo(_currentLockPosition);
        widget.dragEnd();
      },
      child: widget.child,
    );
  }
}
