import 'package:app/Vertical-Tracking/CreateBlocSprayWall/CreateBlocController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/SentWall/sentWallReq.dart';
import 'package:app/data/models/SentWall/sentWallResp.dart';
import 'package:app/data/models/SentWall/sentWall_api.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/colorFilter/colorFilterController.dart';
import 'package:app/widgets/colorFilter/colorsFilterWidget.dart';
import 'package:app/widgets/loadingButton.dart';
import 'package:app/widgets/vid%C3%A9oCapture.dart';
import 'package:video_player/video_player.dart';

class SentWallEditWidget extends StatefulWidget {
  String wallId;
  String cimbingLocationId;
  String secteurId;
  Function(SentWallResp sentWallResp) onSentWallEdit;
  SentWallResp sentWallResp;
  void Function() onUnsent;
  LoadingButtonController loadingButtonController;

  bool isSprayWall = false;
  Function()? onError;
  SentWallEditWidget(
      {Key? key,
      required this.loadingButtonController,
      required this.wallId,
      required this.onSentWallEdit,
      required this.cimbingLocationId,
      required this.secteurId,
      this.isSprayWall = false,
      required this.onUnsent,
      this.onError,
      required this.sentWallResp})
      : super(key: key);

  @override
  _SentwalleditwidgetState createState() => _SentwalleditwidgetState();
}

class _SentwalleditwidgetState extends State<SentWallEditWidget> {
  late DateTime date;
  ColorFilterController colorFilterController = ColorFilterController(
      gradesTree: GradeTreeFromList(Get.find<PrefUtils>().getGradeSystem()));
  VideoCapture videoCapture = VideoCapture(
    'MyBeta',
    wantKeepAlive: true,
  );

  int nTentative = 1;
  String selectedCotation = "";

  @override
  void initState() {
    super.initState();
    date = widget.sentWallResp.date ?? DateTime.now();
    if (widget.sentWallResp.grade != null) {
      colorFilterController.setSelectedGradeByID(widget.sentWallResp.grade!.id);
    }

    selectedCotation = widget.sentWallResp.grade_font ?? "";

    nTentative = widget.sentWallResp.nTentative ?? 1;

    if (widget.sentWallResp.beta != null) {
      videoCapture = VideoCapture(
        'MyBeta',
        controller: VideoPlayerController.networkUrl(
          Uri.parse(widget.sentWallResp.beta!),
        ),
      );
    } else if (widget.sentWallResp.beta_url != null) {
      print('save Url here');
    }
  }

  Future<void> editSent(BuildContext context) async {
    try {
      Get.back(result: true);
      if (!widget.isSprayWall) {
        patch_sent_it(
          SentWallReq(
              gradeID: colorFilterController.selectedGrade.value == null
                  ? null
                  : colorFilterController.selectedGrade.value!.id,
              nTentative: nTentative,
              date: date,
              beta: videoCapture.file,
              beta_url: videoCapture.url),
          widget.cimbingLocationId,
          widget.secteurId,
          widget.wallId,
          widget.sentWallResp.id!,
        ).then((value) {
          widget.onSentWallEdit(value);
        });
      } else {
        patchSprayWallDetails(
          SentWallReq(
              gradeID: colorFilterController.selectedGrade.value?.id,
              nTentative: nTentative,
              date: date,
              beta: videoCapture.file,
              beta_url: videoCapture.url),
          widget.cimbingLocationId,
          widget.secteurId,
          widget.wallId,
          widget.sentWallResp.id!,
        ).then((value) {
          widget.onSentWallEdit(value);
        });
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: AppLocalizations.of(context)!
            .une_erreur_est_survenue_essayez_plus_tard,
        duration: 3.seconds,
        snackPosition: SnackPosition.BOTTOM,
      ));
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.width,
        // height: context.height * 0.8,
        padding: const EdgeInsets.only(left: 25, right: 25),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Container(
                height: height * 0.01,
                width: width * 0.3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.onSurface),
              )),
              SizedBox(
                height: height * 0.02,
              ),
              Center(
                  child: InkWell(
                      onTap: () async {
                        date = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2010),
                                lastDate: DateTime.now()) ??
                            date;
                        setState(() {});
                      },
                      child: Container(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 8, bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          child: Text(
                            '${date.day} / ${date.month} / ${date.year}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                          )))),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.nombre_de_tentatives,
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  constraints: BoxConstraints(maxHeight: height * 0.05),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Opacity(
                        opacity: nTentative == index + 1 ? 1 : 0.5,
                        child: InkWell(
                            onTap: () {
                              nTentative = index + 1;
                              setState(() {});
                            },
                            child: Container(
                                width: width * 0.11,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                    index < 9
                                        ? index == 0
                                            ? AppLocalizations.of(context)!
                                                .flash
                                            : '${index + 1}'
                                        : '++',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ))))),
                    separatorBuilder: (context, index) => SizedBox(
                      width: width * 0.02,
                    ),
                    itemCount: 10,
                  )),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.donnez_une_cotation,
              ),
              const SizedBox(
                height: 10,
              ),
              ColorFilterWidget(colorFilterController),
              const SizedBox(
                height: 20,
              ),
              if (widget.isSprayWall)
                Text(
                  AppLocalizations.of(context)!.cotation + 'Fontainebleau',
                ),
              if (widget.isSprayWall)
                SizedBox(
                  height: 10,
                ),
              if (widget.isSprayWall)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LimitedBox(
                      maxHeight: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ButtonWidget(
                            borderRadius: 8,
                            isSelected: selectedCotation == cotationList[index],
                            onPressed: () {
                              selectedCotation = cotationList[index];
                              setState(() {});
                            },
                            child: Text(cotationList[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface)),
                          );
                        },
                        separatorBuilder: (context, _) => SizedBox(
                          width: 5,
                        ),
                        itemCount: cotationList.length,
                      )),
                ),
              Center(
                  child: Container(
                constraints: BoxConstraints(maxHeight: height * 0.3),
                child: videoCapture,
              )),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            widget.onUnsent();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 10, bottom: 10),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.devalider,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ))),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () => editSent(context),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context)!.valider,
                          style: Theme.of(context).textTheme.bodyMedium!),
                    ),
                  ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ]));
  }
}
