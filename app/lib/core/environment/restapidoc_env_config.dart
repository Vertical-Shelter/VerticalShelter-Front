import 'base_env_config.dart';

class RestAPIDOCEnvConfig extends BaseEnvConfig {
  @override
  String get baseUrl2 => 'https://127.0.0.1:8000/';

  String get loginUrl => '$baseUrl/login/';

  String getprofilUrl(String pk) => '$baseUrl/user/$pk/';
  String updateprofilUrl(String pk) => '$baseUrl/user/$pk/';
  String get user => '$baseUrl/user/';
  String get createUser => '$baseUrl/register/';
  String get userlist => '${user}list-by-name/';
  String get userListFriend => '${user}me/friends/';
  String commentUrl(String pk, String type) => '$baseUrl/$type/$pk/comment/';
  String friendrequest(String user_id) {
    return '${user}$user_id/';
  }

  String get notifications => '$baseUrl/notifications/';
  String getClimbingLocWallUrl(String pk) => '$climbinglocation$pk/list-walls/';

  String listActualVS(String climbingPk) =>
      '$climbinglocation$climbingPk/list-actual-walls/';
  String listOldVS(String climbingPk) =>
      '$climbinglocation$climbingPk/list-old-walls/';

  //climbingloc
  String get climbinglocation => '$baseUrl/climbingLocation/';

  //Wall
  String get wallNoClimbingLoc => '$baseUrl/wall/';

  //Likes
  String likeUrl(String pk, String type) => '$baseUrl/$type/$pk/like/';

  // Stats
  String get statsWallThisWeek => '$baseUrl/get_my_wall_week/';
  String get statsActivity => '$baseUrl/get_my_activity/';
  String get history => '${user}me/history-new/';
  String get statGlobal => '${user}me/stats/global/';
  String get statPerGym => '${user}me/stats/perGym/';

  String get statsMyWalls => '$baseUrl/get_my_walls/';

  String get wallNoClimbingLocPk => '$baseUrl/wall/';

  //FCM

  String fcm(String userId) => '$user$userId/FCM/';

  @override
  String getClimbingLocSecteurUrl(String pk) => '$climbinglocation$pk/secteur/';

  String wallSecteur(String cLocPK, String secteurPk) =>
      getClimbingLocSecteurUrl(cLocPK) + '$secteurPk/wall/';

  String getWallRouteSetterUrl(
      String climbingLocPk, String secteurPk, String wallPk) {
    return wallSecteur(climbingLocPk, secteurPk) + '$wallPk/';
  }

  String sentWallsManip(
      String climbingLocPk, String secteurPk, String wallPk, String id) {
    return getWallRouteSetterUrl(climbingLocPk, secteurPk, wallPk) +
        'sentwall/$id/';
  }

  //Ranking
  String get globalRanking => '${user}ranking/global/';
  String gymRanking(String gymId) => '${user}ranking/$gymId/';
  String get friendsRanking => '${user}me/friends/ranking/';
}
