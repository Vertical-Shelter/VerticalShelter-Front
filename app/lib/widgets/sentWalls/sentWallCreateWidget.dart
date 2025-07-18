import 'package:app/Vertical-Tracking/CreateBlocSprayWall/CreateBlocController.dart';
import 'package:app/Vertical-Tracking/Wall/wallController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/SeasonPass/UserQuestResp.dart';
import 'package:app/data/models/SentWall/sentWallReq.dart';
import 'package:app/data/models/SentWall/sentWallResp.dart';
import 'package:app/data/models/SentWall/sentWall_api.dart';
import 'package:app/widgets/buttonWidget.dart';
import 'package:app/widgets/colorFilter/colorsFilterWidget.dart';
import 'package:app/widgets/vid%C3%A9oCapture.dart';
import 'package:app/widgets/colorFilter/colorFilterController.dart';

class SentWallWidget extends StatefulWidget {
  String wallId;
  String cimbingLocationId;
  String secteurId;
  Function(SentWallResp sentWallResp) onSentWallEdit;

  bool isSprayWall = false;
  Function()? onError;

  SentWallWidget(
      {Key? key,
      required this.wallId,
      required this.onSentWallEdit,
      required this.cimbingLocationId,
      required this.secteurId,
      this.isSprayWall = false,
      this.onError})
      : super(key: key);

  @override
  _StateSentWallWidget createState() => _StateSentWallWidget();
}

class _StateSentWallWidget extends State<SentWallWidget> {
  Rx<DateTime> date = DateTime.now().obs;
  ColorFilterController colorFilterController = ColorFilterController(
      gradesTree: GradeTreeFromList(Get.find<PrefUtils>().getGradeSystem()));
  VideoCapture videoCapture = VideoCapture(
    'MyBeta',
    wantKeepAlive: true,
  );

  RxInt nTentative = 1.obs;
  String selectedCotation = "";
  void sendWall(BuildContext context) async {
    try {
      Get.back(result: true);
      if (widget.isSprayWall) {
        sentSprayWallDetails(
                SentWallReq(
                    gradeID: colorFilterController.selectedGrade.value?.id,
                    nTentative: nTentative.value,
                    date: date.value,
                    beta_url: videoCapture.url,
                    grade_font: selectedCotation,
                    beta: videoCapture.file),
                widget.cimbingLocationId,
                widget.secteurId,
                widget.wallId)
            .then((value) {
          widget.onSentWallEdit(value);
        });
      } else {
        sent_it(
                SentWallReq(
                    gradeID: colorFilterController.selectedGrade.value == null
                        ? null
                        : colorFilterController.selectedGrade.value!.id,
                    nTentative: nTentative.value,
                    beta_url: videoCapture.url,
                    date: date.value,
                    beta: videoCapture.file),
                widget.cimbingLocationId,
                widget.secteurId,
                widget.wallId)
            .then((value) {
          widget.onSentWallEdit(value);
        });
      }
    } catch (e) {
      (widget.onError ?? () {})();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        width: context.width,
        // height: context.height * 0.8,
        padding: EdgeInsets.only(left: 25, right: 25),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
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
                        date.value = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2010),
                                lastDate: DateTime.now()) ??
                            date.value;
                      },
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 24, right: 24, top: 8, bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          child: Text(
                            '${date.value.day} / ${date.value.month} / ${date.value.year}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                          )))),
              SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.nombre_de_tentatives,
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  constraints: BoxConstraints(maxHeight: height * 0.05),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Obx(() => Opacity(
                        opacity: nTentative.value == index + 1 ? 1 : 0.5,
                        child: InkWell(
                            onTap: () {
                              nTentative.value = index + 1;
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
                                        )))))),
                    separatorBuilder: (context, index) => SizedBox(
                      width: width * 0.02,
                    ),
                    itemCount: 10,
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.donnez_une_cotation,
              ),
              SizedBox(
                height: 10,
              ),
              ColorFilterWidget(colorFilterController),
              SizedBox(
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
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 24, right: 24, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.annuler,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ))),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            sendWall(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 24, right: 24, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            alignment: Alignment.center,
                            child: Text(AppLocalizations.of(context)!.valider,
                                style: Theme.of(context).textTheme.bodyMedium!),
                          )))
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ])));
  }
}
