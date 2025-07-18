import 'package:flutter/material.dart';

class SwipeUpDownContainer extends StatefulWidget {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  SwipeUpDownContainer(
      {Key? key,
      required this.child,
      required this.maxHeight,
      required this.minHeight})
      : super(key: key);

  @override
  _SwipeUpDownContainerState createState() => _SwipeUpDownContainerState();
}

class _SwipeUpDownContainerState extends State<SwipeUpDownContainer> {
  late double _offset;
  late double _maxHeight; // Adjust this value as needed

  @override
  void initState() {
    super.initState();
    _maxHeight = widget.maxHeight;
    _offset = widget.minHeight;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offset += details.delta.dy;
      _offset = _offset.clamp(widget.minHeight, _maxHeight);

      // Directly set the offset to the maximum height when dragging upwards
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: AnimatedContainer(
        constraints: BoxConstraints(
          minHeight: widget.minHeight,
          maxHeight: widget.maxHeight,
        ),
        duration: Duration(milliseconds: 1),
        height: _maxHeight - _offset,
        child: widget.child,
      ),
    );
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    // Add any additional logic here when the drag ends, if needed
  }
}
