import 'package:app/core/app_export.dart';
import 'package:app/widgets/textFieldShaker/textFieldShakerController.dart';

class ShakeTextField extends StatefulWidget {
  final TextEditingController controller;
  final ShakeTextFieldController? shakeController;
  final String hintText;
  final Color borderColor;

  const ShakeTextField({
    required this.controller,
    this.shakeController,
    required this.hintText,
    required this.borderColor,
    Key? key,
  }) : super(key: key);

  @override
  _ShakeTextFieldState createState() => _ShakeTextFieldState();
}

class _ShakeTextFieldState extends State<ShakeTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isInvalid = false;
  bool isInvalidColor = false;
  Color current = ColorsConstantDarkTheme.neutral_white;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 5)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_controller);

    // Associer le contrôleur au callback pour déclencher le shake
    widget.shakeController?.bindShakeCallback(() {
      _triggerShakeAnimation();
      testvalid();
    });
    widget.controller.addListener(() {
      testvalid();
    });
  }

  void _triggerShakeAnimation() {
    setState(() {
      isInvalid = true;
      isInvalidColor = true;
    });
    _controller.forward().then((_) {
      _controller.reverse();
      setState(() {
        isInvalid = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void testvalid() {
    if (widget.controller.text.isEmpty && isInvalidColor) {
      setState(() {
        current = Theme.of(context).colorScheme.primary;
      });
    } else {
      setState(() {
        current = Theme.of(context).colorScheme.onSurface;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.hintText} *",
          style:
              Theme.of(context).textTheme.labelMedium!.copyWith(color: current),
        ),
        const SizedBox(height: 10),
        AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                    _animation.value *
                        (_controller.status == AnimationStatus.forward
                            ? 1
                            : -1),
                    0),
                child: child,
              );
            },
            child: TextField(
              controller: widget.controller,
              style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                hintText: widget.hintText,
                filled: true,
                hintStyle: Theme.of(context).textTheme.bodySmall,
                labelStyle: Theme.of(context).textTheme.bodySmall,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            )),
      ],
    );
  }
}
