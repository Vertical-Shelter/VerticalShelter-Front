abstract class BaseEnvConfig {
  String get baseUrl;
  String getprofilUrl(String pk);
  String updateprofilUrl(String pk);
  String get climbinglocation;
  String get user;
  String get userlist;
  String get userListFriend;
  String getClimbingLocWallUrl(String pk);
  String getWallRouteSetterUrl(
      String climbingLocPk, String secteurPk, String wallPk);
  String commentUrl(String pk, String type);
  String get createUser;
  String listActualVS(String climbingPk);
  String listOldVS(String climbingPk);
  String get wallNoClimbingLoc;

  //Stats

  String get statsMyWalls;
  String get statsWallThisWeek;
  String get history;
  String get statGlobal;
  String get statPerGym;
  String get statsActivity;
  String get loginUrl;
  String friendrequest(String user_id);
  String get notifications;
  String likeUrl(String pk, String type);

  //Setting
  String getClimbingLocSecteurUrl(String pk);

  String wallSecteur(String cLocPK, String secteurPk);

  //FCM
  String fcm(String userId);

  // Sent Wall
  String sentWallsManip(
      String climbingLocPk, String secteurPk, String wallPk, String id);

  //Ranking
  String get globalRanking;
  String get friendsRanking;
  String gymRanking(String gymId);
}
