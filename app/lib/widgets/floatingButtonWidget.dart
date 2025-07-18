import 'dart:io';

import 'package:app/core/app_export.dart';
import 'package:app/widgets/mousquette.dart';
import 'package:app/widgets/mousquettesAnimation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class floatingButtonWidget extends StatefulWidget {
  final List<SpeedDialChild> children;
  final Rxn<File> creationImage;
  final Rxn<String> creationState;
  final int count;
  floatingButtonWidget(
      {required this.creationImage,
      required this.creationState,
      required this.count,
      required this.children});

  @override
  _floatingButtonWidgetState createState() => _floatingButtonWidgetState();
}

class _floatingButtonWidgetState extends State<floatingButtonWidget> {
  bool floatExtended = false;
  bool rmicons = true;
  bool extend = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(() => widget.creationImage.value != null
        ? SpeedDial(
            backgroundColor: ColorsConstantDarkTheme.neutral_white,
            activeBackgroundColor: ColorsConstantDarkTheme.neutral_white,
            child: ClipOval(
                child: widget.creationState.value == null
                    ? Stack(children: [
                        Image(
                          image: FileImage(widget.creationImage.value!),
                          fit: BoxFit.cover, // Prevent clipping
                          width: double
                              .infinity, // Expand the image to its original size
                          height: double.infinity,
                        ),
                        //Loading error or success widget
                        Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: ColorsConstantDarkTheme.neutral_white,
                            )))
                      ])
                    : (widget.creationState.value == 'success'
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Theme.of(context).colorScheme.primary,
                            child: widget.count == 0
                                ? Icon(Icons.check)
                                : Row(children: [
                                    Text(
                                      " +${widget.count} ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: ColorsConstantDarkTheme
                                                  .background,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Mousquette()
                                  ]),
                          )
                        : Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.red.withOpacity(0.5),
                            child: Center(
                                child: Icon(
                              Icons.error,
                              color: ColorsConstantDarkTheme.neutral_white,
                            ))))))
        : SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            spacing: 3,
            childPadding: const EdgeInsets.all(5),
            spaceBetweenChildren: 4,

            // it's the SpeedDial size which defaults to 56 itself
            iconTheme: const IconThemeData(size: 30),
            onOpen: () => setState(() {
                  rmicons = true;
                }),
            onClose: () => setState(() => rmicons = false),
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            foregroundColor: Theme.of(context).colorScheme.surface,
            backgroundColor: Theme.of(context).colorScheme.primary,
            activeForegroundColor: Theme.of(context).colorScheme.surface,
            activeBackgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 8.0,
            animationCurve: Curves.elasticInOut,

            // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            children: widget.children));
  }
}
