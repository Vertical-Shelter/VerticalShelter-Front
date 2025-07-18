import 'package:app/data/models/ClimbingLocation/ClimbingLocation_resp.dart';
import 'package:app/data/models/SentWall/sentWallResp.dart';
import 'package:app/data/models/friendrequest/friendrequest_resp.dart';
import 'package:app/data/models/gamingObject/avatarResp.dart';
import 'package:app/data/models/gamingObject/baniereResp.dart';

UserMinimalResp userMinimalRespFromJson(Map<String, dynamic> json) {
  if (json['points'] != null && json['points'] is int) {
    json['points'] = json['points'].toDouble();
  }
  return UserMinimalResp(
    id: json['id'],
    point: json['points'],
    username: json['username'],
    image: json['profile_image_url'],
    baniere:
        json['baniere'] != null ? baniereRespFromJson(json['baniere']) : null,
    friendStatus: friendStatusFromJson(json['friendStatus']),
    isGym: json['isGym'],
  );
}

class UserMinimalResp {
  String id;
  String? username;
  BaniereResp? baniere;
  String? image;
  FriendStatus? friendStatus;
  double? point;
  final bool? isGym;

  UserMinimalResp({
    this.isGym,
    this.point,
    required this.id,
    this.baniere,
    this.username,
    this.image,
    this.friendStatus,
  });
}

class UserResp {
  String? id;
  String? username;
  String? profileImage;
  bool? isGym;
  AvatarResp? avatar;
  BaniereResp? baniere;
  int coins;
  DateTime? lastDateNews;
  ClimbingLocationResp? climbingLocation;
  int total_sent_wall;
  List<SentWallResp>? sentWalls;
  String? description;
  FriendStatus? friendStatus;
  Map? error;
  String? qrCodeUrl;
  bool isAmbassadeur;

  UserResp({
    this.id,
    this.coins = 0,
    this.total_sent_wall = 0,
    this.sentWalls,
    this.lastDateNews,
    this.isAmbassadeur = false,
    this.username,
    this.isGym,
    this.profileImage,
    this.qrCodeUrl,
    this.description,
    this.climbingLocation,
    this.friendStatus,
    this.avatar,
    this.baniere,
    this.error,
  });

  factory UserResp.fromJson(Map<String, dynamic> json) {
    List<SentWallResp> listsentWalls = [];
    if (json["sentWalls"] != null) {
      for (var item in json["sentWalls"]) {
        listsentWalls.add(sentWallRespFromJson(item));
      }
    }
    UserResp user = UserResp(
      id: json['id'],
      qrCodeUrl: json['qrcode'],
      baniere:
          json['baniere'] != null ? baniereRespFromJson(json['baniere']) : null,
      isGym: json['isGym'],
      lastDateNews: json['lastDateNews'] != null && json['lastDateNews'] != ""
          ? DateTime.parse(json['lastDateNews'])
          : null,
      sentWalls: listsentWalls,
      coins: json['coins'] ?? 0,
      total_sent_wall: json['total_sent_wall'] ?? 0,
      username: json['username'],
      profileImage: json['profile_image_url'] ?? '',
      description: json['description'],
      isAmbassadeur: json['isAmbassadeur'] ?? false,
      avatar:
          json['avatar'] != null ? avatarRespFromJson(json['avatar']) : null,
      friendStatus: friendStatusFromJson(json['friendStatus']),
      climbingLocation: json['climbingLocation'] != null
          ? climbingLocationrespFromJson(json['climbingLocation'])
          : null,
    );

    return user;
  }

  UserMinimalResp toUserMinimalResp() {
    return UserMinimalResp(
      id: id!,
      username: username,
      image: profileImage,
      baniere: baniere,
      friendStatus: friendStatus,
      point: coins.toDouble(),
      isGym: isGym,
    );
  }
}

UserResp userResFromJson(Map<String, dynamic> json) {
  // NORMAL ERROR
  if (json['id'] == null) return UserResp(error: json);

  return UserResp.fromJson(json);
}
