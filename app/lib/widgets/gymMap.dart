import 'package:app/core/app_export.dart';
import 'package:app/data/models/Secteur/secteur_svg.dart';
import 'package:app/widgets/clipper.dart';
import 'package:app/widgets/snappingSheet/snapping_sheet.dart';

class GymMap extends StatelessWidget {
  List<SecteurSvg> secteurSvgList;
  List<SecteurSvg>? selectedSecteur;
  List<String> labelNextSecteur;
  dynamic Function(Map<String, dynamic>) onShapeSelected;
  List<String> labelSecteurRecent;
  SnappingSheetController? snappingSheetController;
  double? height2;
  GymMap(
      {required this.secteurSvgList,
      required this.selectedSecteur,
      required this.onShapeSelected,
      this.snappingSheetController,
      this.height2,
      required this.labelNextSecteur,
      required this.labelSecteurRecent});

  @override
  Widget build(BuildContext context) {
    double svgHeight = secteurSvgList.first.height;
    if (height2 != null) {
      svgHeight = height2!;
    }
    double heightFactor = svgHeight > height
        ? svgHeight / height
        : (height / (height2 ?? height));
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _legendContainer(context),
          Expanded(
              child: InteractiveViewer(
                  panAxis: PanAxis.free,
                  minScale: 0.5,
                  maxScale: 5,
                  boundaryMargin:
                      EdgeInsets.symmetric(horizontal: width, vertical: height),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      //add secteur
                      for (var secteur in secteurSvgList)
                        _getClippedImage(
                          clipper: Clipper(
                            height: secteur.height * heightFactor,
                            width: secteur.width * heightFactor,
                            svgPath: secteur.svgPath,
                          ),
                          color: Theme.of(Get.context!)
                              .colorScheme
                              .onSurface
                              .withOpacity(selectedSecteur == null ||
                                      selectedSecteur!
                                          .map((e) =>
                                              e.svgPath == secteur.svgPath)
                                          .contains(true)
                                  ? 1
                                  : 0.5),
                          secteurSvg: secteur,
                          onShapeSelected: onShapeSelected,
                        ),
                      // add dots
                      for (var secteur in secteurSvgList)
                        _getClippedImage(
                            clipper: Clipper(
                              height: secteur.height * heightFactor,
                              width: secteur.width * heightFactor,
                              svgPath: secteur.circlePath,
                            ),
                            color: labelNextSecteur
                                    .contains(secteur.secteurName)
                                ? ColorsConstantDarkTheme.tertiary.withOpacity(
                                    selectedSecteur == null || selectedSecteur!.map((e) => e.svgPath == secteur.svgPath).contains(true)
                                        ? 1
                                        : 0.5)
                                : labelSecteurRecent
                                        .contains(secteur.secteurName)
                                    ? ColorsConstantDarkTheme.secondary.withOpacity(
                                        selectedSecteur == null || selectedSecteur!.map((e) => e.svgPath == secteur.svgPath).contains(true)
                                            ? 1
                                            : 0.5)
                                    : Theme.of(Get.context!)
                                        .colorScheme
                                        .surface
                                        .withOpacity(selectedSecteur == null ||
                                                selectedSecteur!
                                                    .map((e) => e.svgPath == secteur.svgPath)
                                                    .contains(true)
                                            ? 1
                                            : 0.5),
                            secteurSvg: secteur,
                            onShapeSelected: onShapeSelected),
                      // add texts
                      for (var secteur in secteurSvgList)
                        _getClippedImage(
                          clipper: Clipper(
                            height: secteur.height * heightFactor,
                            width: secteur.width * heightFactor,
                            svgPath: secteur.labelPath,
                          ),
                          color: Theme.of(Get.context!)
                              .colorScheme
                              .onSurface
                              .withOpacity(selectedSecteur == null ||
                                      selectedSecteur!
                                          .map((e) =>
                                              e.svgPath == secteur.svgPath)
                                          .contains(true)
                                  ? 1
                                  : 0.5),
                          secteurSvg: secteur,
                          onShapeSelected: onShapeSelected,
                        ),
                    ],
                  )))
        ]);
  }

  Widget _legendContainer(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          AppLocalizations.of(context)!.nouveau_secteur,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(
          width: 50,
        ),
        CircleAvatar(
          radius: 5,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          AppLocalizations.of(context)!.ferme_tres_bientot,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _getClippedImage({
    required CustomClipper<Path> clipper,
    required SecteurSvg secteurSvg,
    required Color? color,
    final Function(Map<String, dynamic>)? onShapeSelected,
  }) {
    return ClipPath(
      clipper: clipper,
      child: GestureDetector(
        onTap: () {
          if (secteurSvg == selectedSecteur) {
            onShapeSelected?.call({"area": null});

            if (snappingSheetController != null) {
              snappingSheetController!.snapToPosition(
                  snappingSheetController!.snappingPositions.first);
            }
          } else {
            onShapeSelected?.call({"area": secteurSvg});

            if (snappingSheetController != null) {
              snappingSheetController!.snapToPosition(
                  snappingSheetController!.snappingPositions.last);
            }
          }
        },
        child: Container(
          color: color,
        ),
      ),
    );
  }
}
