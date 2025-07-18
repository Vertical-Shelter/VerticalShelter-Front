import 'package:app/core/app_export.dart';
import 'package:app/widgets/mousquette.dart';

class PlusMousquetteAnimation extends StatefulWidget {
  int count;
  PlusMousquetteAnimation({Key? key, required this.count}) : super(key: key);
  @override
  _MousquetteAnimationState createState() => _MousquetteAnimationState();
}

//create a an animation for the mousquettes
// it should blink and move
class _MousquetteAnimationState extends State<PlusMousquetteAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _animation.value * 3 > 1 ? 1 : _animation.value * 3,
      child: Row(children: [Text(" +${widget.count}"), Mousquette()]),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
