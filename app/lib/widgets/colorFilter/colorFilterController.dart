import 'package:app/Vertical-Tracking/Gyms/gymsController.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/models/Secteur/secteur_svg.dart';
import 'package:app/data/models/Wall/WallResp.dart';
import 'package:app/data/models/grade/gradeResp.dart';

class GradeTree {
  String ref1;
  List<GradeResp>? subgrades;
  GradeResp? grade;

  GradeTree({required this.ref1, this.subgrades, this.grade});
}

List<GradeTree> GradeTreeFromList(List<GradeResp> grades) {
  
  List<GradeTree> gradesTree = [];
  for (var grade in grades) {
    if (grade.ref2 == null) {
      gradesTree.add(GradeTree(ref1: grade.ref1, grade: grade));
    } else {
      var gradeTree = gradesTree
          .firstWhere((element) => element.ref1 == grade.ref1, orElse: () {
        var gradeTree = GradeTree(ref1: grade.ref1, subgrades: []);
        gradesTree.add(gradeTree);
        return gradeTree;
      });
      gradeTree.subgrades!.add(grade);
    }
  }
  return gradesTree;
}

class ColorFilterController {
  List<GradeTree> gradesTree;
  List<GradeTree>? savegradesTree;
  RxMap<String, dynamic>? numberOfWall;
  ScrollController controller = ScrollController();
  //VTGymController gymController = Get.find<VTGymController>();
  bool is_Percent;
  late Rxn<GradeResp> selectedGrade = Rxn<GradeResp>();
  bool is_SubGrade = false;
  RxInt index = (-1).obs;
  RxInt subindex = (-1).obs;
  void Function()? refresh;
  String? ref2;

  ColorFilterController(
      {required this.gradesTree,
      this.numberOfWall,
      this.refresh,
      this.is_Percent = false,
      GradeResp? initialGrade}) {
    if (gradesTree[0].subgrades != null) {
      is_SubGrade = true;
    }
    if (initialGrade != null) {
      selectedGrade.value = initialGrade;
      index.value =
          gradesTree.indexWhere((element) => element.ref1 == initialGrade.ref1);
      if (is_SubGrade) {
        subindex.value = gradesTree[index.value]
            .subgrades!
            .indexWhere((element) => element.ref2 == initialGrade.ref2);
      }
    }
    ;
  }

  String? get selectedGradeRef {
    if (selectedGrade.value == null) {
      return index.value == -1 ? null : gradesTree[index.value].ref1;
    }
    return selectedGrade.value!.ref1;
  }

  void setSelectedGradeByID(String id) {
    if (is_SubGrade) {
      for (var gradeTree in gradesTree) {
        if (gradeTree.subgrades != null) {
          for (var subgrade in gradeTree.subgrades!) {
            if (subgrade.id == id) {
              selectedGrade.value = subgrade;
              index.value = gradesTree.indexOf(gradeTree);
              subindex.value = gradeTree.subgrades!.indexOf(subgrade);
              return;
            }
          }
        }
      }
    } else
      selectedGrade.value =
          gradesTree.firstWhere((element) => element.grade!.id == id).grade;
    index.value = gradesTree.indexWhere((element) => element.grade!.id == id);
  }

  //only display grade from present bloc in a sector
  void gradeTreeFiltered(){
  //    if(savegradesTree == null){
  //     savegradesTree = gradesTree;
  //    }
  //    else{
  //     List<GradeTree> listNewGrade = [];

  //     for(var allGrade in savegradesTree!){
  //       for(var grade in gymController.displayedWalls){
  //         if(allGrade.ref1 == grade.grade?.ref1 && !listNewGrade.contains(allGrade)){
  //           //grade in common
  //           listNewGrade.add(allGrade);
  //         }
  //       }
  //     }

  //     if (gymController.getFilter.containsKey('color') && gymController.getFilter['color'] != null) {
  //       print('color :${gymController.getFilter['color']}');
  //     }
  //     else{
  //       gradesTree = listNewGrade;
  //     }
      
  // }
  }
}
