import 'package:app/Vertical-Tracking/MyStats/stats/subscreen/gymsStats.dart';
import 'package:app/Vertical-Tracking/MyStats/stats/subscreen/overallStats.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/Stats/statsApi.dart';
import 'package:app/data/models/Stats/statsResp.dart';
import 'package:app/data/models/grade/gradeResp.dart';
import 'package:app/utils/tuple.dart';

enum statsStyle { objectif, info, barChart, lineChart }

class statsData {
  dynamic name;
  int value;
  String? text;
  Color? color;
  bool showName;
  GradeResp? grade;
  Widget? icon;
  Gradient? gradient;

  statsData({
    required this.name,
    required this.value,
    this.grade,
    this.color,
    this.icon,
    this.text,
    this.gradient,
    this.showName = true,
  });

  toList() {
    return [this];
  }
}

class VTOverallStats {
  RxList<Tuple<statsStyle, dynamic>> statsGrid =
      <Tuple<statsStyle, dynamic>>[].obs;
  final BuildContext context = Get.context!;

  void refreshValues(Map<String, dynamic> statsResp) {
    List<statsData> statsList = <statsData>[].obs;
    statsGrid.clear();

    statsResp["attributes"].forEach((key, value) {
      statsList.add(statsData(name: key, value: value, text: "attributs"));
    });
    statsList.sort((a, b) {
      if (a.value > b.value) {
        return -1;
      } else {
        return 1;
      }
    });
    statsGrid.add(Tuple(
        statsStyle.objectif,
        statsData(
            name: AppLocalizations.of(context)!.blocs,
            icon: SvgPicture.asset(
              BlackIconConstant.boulder,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary, BlendMode.srcIn),
            ),
            color: Theme.of(context).colorScheme.primary,
            value: statsResp["sent_walls"],
            text: AppLocalizations.of(context)!.blocs_valides)));

    statsGrid.add(Tuple(
        statsStyle.objectif,
        statsData(
            name: AppLocalizations.of(context)!.salles,
            icon: SvgPicture.asset(
              BlackIconConstant.gym,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary, BlendMode.srcIn),
            ),
            color: Theme.of(context).colorScheme.primary,
            value: statsResp["climbingLocation"],
            text: AppLocalizations.of(context)!.salles_differentes)));

    statsGrid.add(Tuple(statsStyle.barChart, statsList));
    statsGrid.refresh();
  }
}

class VTGymStats {
  RxList<Tuple<statsStyle, dynamic>> statsGrid =
      <Tuple<statsStyle, dynamic>>[].obs;

  RxList<ClimbingLocationMinimalResp> gymLists =
      <ClimbingLocationMinimalResp>[].obs;

  RxString currentGymId = ''.obs;
  final BuildContext context = Get.context!;
  Map<String, dynamic> gymHasMap = {};

  List<GradeResp> gradeSystem = [];

  List<statsData> getAttributes() {
    List<statsData> statsList = <statsData>[].obs;

    gymHasMap[currentGymId.value.toString()]["attributes"]
        .forEach((key, value) {
      statsList.add(statsData(name: key, value: value, text: "attributs"));
    });

    statsList.sort((a, b) {
      if (a.value > b.value) {
        return -1;
      } else {
        return 1;
      }
    });
    return statsList;
  }

  List<statsData> getCotation() {
    List<statsData> statsList = <statsData>[].obs;
    bool isColor = gradeSystem.first.ref1.length > 4;

    gymHasMap[currentGymId.value.toString()]["grade"].forEach((key, value) {
      statsList.add(statsData(
          name: key, // a soit rien mettre soit mettre le nom de la couleur
          value: value,
          color:
              isColor && key.length <= 6 ? ColorsConstant.fromHex(key) : null,
          gradient: isColor && key.length > 6
              ? LinearGradient(colors: [
                  ColorsConstant.fromHex(key.split(",")[0]),
                  ColorsConstant.fromHex(key.split(",")[0]),
                  ColorsConstant.fromHex(key.split(",")[1]),
                  ColorsConstant.fromHex(key.split(",")[1])
                ], stops: [
                  0,
                  0.5,
                  0.5,
                  1
                ], begin: Alignment.bottomLeft, end: Alignment.topRight)
              : null,
          showName: !isColor,
          text: AppLocalizations.of(context)!.cotation));
    });

    statsList.sort((a, b) {
      var a1 = gradeSystem.firstWhereOrNull((element) {
        if (a.color == null) {
          return false;
        } else {
          return a.color!.value
              .toRadixString(16)
              .contains(element.ref1.toLowerCase());
        }
      });
      var b1 = gradeSystem.firstWhereOrNull((element) {
        if (b.color == null) {
          return false;
        } else {
          return b.color!.value
              .toRadixString(16)
              .contains(element.ref1.toLowerCase());
        }
      });

      if (a1 != null && b1 != null && a1.vgrade > b1.vgrade) {
        return 1;
      } else {
        return -1;
      }
    });
    return statsList;
  }

  statsData getMeanGrade() {
    double minimumvgrade = 0;
    List<GradeResp> meangrades = [];
    GradeResp bestGrade = gradeSystem.first;
    ClimbingLocationMinimalResp _climbingLocationResp =
        gymLists.firstWhere((element) => element.id == currentGymId.value);
    gymHasMap[currentGymId.value.toString()]["grade"].forEach((key, value) {
      GradeResp? gradeResp = _climbingLocationResp.gradeSystem
          .firstWhereOrNull((element) => element.ref1 == key.toString());
      int vgrade = gradeResp == null ? 0 : gradeResp.vgrade;
      if (value > 10 && vgrade > minimumvgrade) {
        minimumvgrade = vgrade.toDouble();
        meangrades.removeWhere((element) => element.vgrade <= minimumvgrade);
      } else if (vgrade > minimumvgrade) {
        meangrades.add(gradeResp!);
      }
      if (vgrade > bestGrade.vgrade) {
        bestGrade = gradeResp!;
      }
    });
    if (meangrades.isEmpty) {
      return statsData(
          name: bestGrade.ref1,
          value: 0,
          grade: bestGrade,
          color: Theme.of(context).colorScheme.primary,
          text: AppLocalizations.of(context)!.ton_niveau_moyen_est + " :");
    }
    double meanGrade = meangrades
            .map((e) => e.vgrade)
            .reduce((value, element) => value + element) /
        meangrades.length;
    List<GradeResp> grades = _climbingLocationResp.gradeSystem;
    // return key zhere meanColor is almost equal to the color value
    GradeResp gradeResp = grades.first;
    for (GradeResp grade in grades) {
      if (grade.vgrade >= meanGrade && grade.vgrade > minimumvgrade) {
        gradeResp = grade;
        break;
      }
    }
    return statsData(
        name: gradeResp.ref1,
        value: meanGrade.round(),
        grade: gradeResp,
        color: Theme.of(context).colorScheme.primary,
        text: AppLocalizations.of(context)!.ton_niveau_moyen_est + " :");
  }

  //need to debug this qnd rethink the logic
  // This function is not displayed
  List<statsData> getProgressLine() {
    List<statsData> statsList = <statsData>[].obs;

    gymHasMap[currentGymId.value.toString()]["date"].forEach((key, value) {
      var colorText = value.first.grade.ref1;
      statsList.add(statsData(
          name: DateTime.parse(key),
          value: value.first.grade.vgrade.round(),
          color:
              colorText.length > 6 ? null : ColorsConstant.fromHex(colorText),
          gradient: colorText.length > 6
              ? LinearGradient(colors: [
                  ColorsConstant.fromHex(colorText.split(",")[0]),
                  ColorsConstant.fromHex(colorText.split(",")[0]),
                  ColorsConstant.fromHex(colorText.split(",")[1]),
                  ColorsConstant.fromHex(colorText.split(",")[1])
                ], stops: [
                  0,
                  0.5,
                  0.5,
                  1
                ], begin: Alignment.bottomLeft, end: Alignment.topRight)
              : null,
          text: ""));
    });

    statsList.sort((a, b) {
      if (a.name.isBefore(b.name)) {
        return -1;
      } else {
        return 1;
      }
    });

    // put missing date to 0 because the graph need to have all the date
    List<DateTime> days = [];
    for (int i = 0;
        i <= statsList.last.name.difference(statsList.first.name).inDays;
        i++) {
      days.add(statsList.first.name.add(Duration(days: i)));
    }

    for (var element in days) {
      if (!statsList.any((element2) => element2.name == element)) {
        var index = days.indexOf(element);
        statsList.insert(
            index,
            statsData(
                name: element,
                value: statsList[index - 1].value,
                color: statsList[index - 1].color,
                text: ""));
      }
    }

    return statsList;
  }

  void changeCurrentGym(String _currentGym) async {
    currentGymId.value = _currentGym;
    gradeSystem = gymLists
        .firstWhere((element) => element.id == currentGymId.value)
        .gradeSystem;
    statsGrid.clear();
    statsGrid.add(Tuple(
        statsStyle.objectif,
        statsData(
            name: AppLocalizations.of(context)!.blocs,
            icon: SvgPicture.asset(
              BlackIconConstant.boulder,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary, BlendMode.srcIn),
            ),
            color: Theme.of(context).colorScheme.primary,
            value: gymHasMap[currentGymId.value.toString()]["sent_walls"],
            text: AppLocalizations.of(context)!.blocs_valides)));
    statsGrid.add(Tuple(statsStyle.info, getMeanGrade()));
    statsGrid.add(Tuple(statsStyle.barChart, getAttributes()));
    statsGrid.add(Tuple(statsStyle.barChart, getCotation()));
    // statsGrid.add(Tuple(statsStyle.lineChart, getProgressLine()));

    statsGrid.refresh();
    currentGymId.refresh();
  }

  void refreshValues(Map<String, dynamic> statsResp) {
    if (statsResp.keys.isEmpty) return;
    statsGrid.clear();
    gymLists.clear();

    currentGymId.value = statsResp.keys.first;
    gymHasMap = statsResp;

    int numberofbloc = statsResp[currentGymId.value.toString()]["sent_walls"];
    statsResp.forEach((key, value) {
      gymLists.add(value["climbingLocation"]);
    });
    gradeSystem = gymLists
        .firstWhere((element) => element.id == currentGymId.value)
        .gradeSystem;
    gymLists.refresh();
    statsGrid.add(Tuple(
        statsStyle.objectif,
        statsData(
            name: AppLocalizations.of(context)!.blocs,
            value: numberofbloc,
            icon: SvgPicture.asset(
              BlackIconConstant.boulder,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary, BlendMode.srcIn),
            ),
            color: Theme.of(context).colorScheme.primary,
            text: AppLocalizations.of(context)!.blocs_valides)));
    statsGrid.add(Tuple(statsStyle.info, getMeanGrade()));
    statsGrid.add(Tuple(statsStyle.barChart, getAttributes()));
    statsGrid.add(Tuple(statsStyle.barChart, getCotation()));
    // statsGrid.add(Tuple(statsStyle.lineChart, getProgressLine()));

    statsGrid.refresh();
  }

  toList() {
    return [this];
  }
}

class VTMyStatsController extends GetxController {
  List<String> selectedStats = [];
  RxBool isLoading = true.obs;
  RxInt index = 0.obs;
  RxString selectedValueDropdown = "week".obs;
  RxBool isGymLoading = true.obs;

  VTGymStats gymStats = VTGymStats();

  statsData TheMostDone(List<statsData> pieData) {
    int max = 0;
    statsData theMostDone = pieData.first;
    pieData.forEach((element) {
      if (element.value > max) {
        max = element.value;
        theMostDone = element;
      }
    });
    return theMostDone;
  }

  List<String> menus = [
    AppLocalizations.of(Get.context!)!.cette_semaine,
    AppLocalizations.of(Get.context!)!.ce_mois,
    AppLocalizations.of(Get.context!)!.cette_annee,
  ];

  RxString actualStats = "global".obs;

  List pages = [
    Get.put(VTOverallStatsScreen()),
    Get.put(VTGymStatsScreen()),
  ];

  VTOverallStats overallStats = VTOverallStats();

  void changeDropdown(String? value) {
    if (value != null) {
      selectedValueDropdown.value = value;
    }
  }

  void changeNavBar(int index) {
    if (this.index.value == 0) {
      actualStats.value = "global";
    } else {
      actualStats.value = "par salles";
    }

    this.index.value = index;
    this.index.refresh();
    actualStats.refresh();
  }

  @override
  void onReady() async {
    await getStatsAttribute("week");
    super.onReady();
  }

  RxList<WallStat> wallStats = <WallStat>[].obs;
  Future getStatsAttribute(String? filter_by) async {
    isLoading.value = true;
    isGymLoading.value = true;

    StatsResp statsGlobal = await statsGeneral(filter_by);

    overallStats.refreshValues(statsGlobal.obj!);
    isLoading.value = false;
    isLoading.refresh();

    wallStats.refresh();

    statsPerGym(filter_by).then((value) {
      gymStats.refreshValues(value.obj!);
      isGymLoading.value = false;
    });
    isLoading.value = false;
    // gymStats.refreshValues(statsRespAttributes.obj!["perGym"]);
  }
}

