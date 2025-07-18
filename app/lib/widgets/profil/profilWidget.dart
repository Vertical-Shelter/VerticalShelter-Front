import 'package:app/core/app_export.dart';
import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/Wall/WallResp.dart';



// ignore: must_be_immutable
class ProfilWidget extends StatefulWidget {
  UserResp userResp;
  int numberOfBoulder = 0;
  int numberOfFriends = 0;
  List<ClimbingLocationMinimalResp> gymLists = [];
  List<WallResp> wallLists = [];

  ProfilWidget({
    Key? key,
    required this.userResp,
    required this.numberOfBoulder,
    required this.numberOfFriends,
    required this.gymLists,
    required this.wallLists,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfilWidget(
        userResp: userResp,
        numberOfBoulder: numberOfBoulder,
        numberOfFriends: numberOfFriends,
        gymLists: gymLists,
        wallLists: wallLists,
      );
}

class _ProfilWidget extends State<ProfilWidget> {
  UserResp userResp;
  int numberOfBoulder = 0;
  int numberOfFriends = 0;
  List<ClimbingLocationMinimalResp> gymLists = [];
  List<WallResp> wallLists = [];

  List<WallResp> displayWallList = [];
  ClimbingLocationMinimalResp? displayGymList;

  _ProfilWidget({
    Key? key,
    required this.userResp,
    required this.numberOfBoulder,
    required this.numberOfFriends,
    required this.gymLists,
    required this.wallLists,
  }) {
    wallLists.forEach((element) {
      displayWallList.add(element);
    });
  }

  void filterWalls(ClimbingLocationMinimalResp? gym) {
    displayWallList.clear();
    wallLists.forEach((element) {
      if (gym == null || element.climbingLocation!.id == gym.id) {
        displayWallList.add(element);
      }
    });
    displayGymList = gym;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget iconsText(String text, Widget icon, int number) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        icon,
        Text(number.toString(), style: AppTextStyle.rb14),
        Text(text, style: AppTextStyle.rb14.copyWith(color: Colors.grey))
      ],
    );
  }
}
