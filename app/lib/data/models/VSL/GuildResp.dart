import 'package:app/data/models/User/user_resp.dart';
import 'package:app/data/models/VSL/UserVSLResp.dart';

class GuildResp {
  String vsl_id;
  String climbingLocation_id;
  String name;
  String? image_url;
  List<UserResp> members;
  bool? is_owner;
  UserVSLResp? ninja;
  UserVSLResp? slabmaster;
  UserVSLResp? hulk;
  String? join_request;
  String id;

  GuildResp({
    required this.vsl_id,
    required this.climbingLocation_id,
    required this.name,
    required this.image_url,
    required this.members,
    required this.is_owner,
    required this.ninja,
    required this.slabmaster,
    required this.hulk,
    required this.join_request,
    required this.id,
  });
}

GuildResp guildRespFromJson(Map<String, dynamic> json) {
  List<UserResp> members = [];
  if (json['members'] != null) {
    json['members'].forEach((v) {
      members.add(UserResp.fromJson(v));
    });
  }
  return GuildResp(
    vsl_id: json['vsl_id'] as String,
    climbingLocation_id: json['climbingLocation_id'] as String,
    name: json['name'] as String,
    image_url: json['image_url'] as String?, // Facultatif
    members: members, // Liste avec une valeur par défaut vide
    is_owner: json['is_owner'] as bool?, // Facultatif
    ninja: json['ninja'] != null
        ? UserVSLRespFromJson(json['ninja'])
        : null, // Facultatif et sous-objet
    slabmaster: json['slabmaster'] != null
        ? UserVSLRespFromJson(json['slabmaster'])
        : null, // Facultatif et sous-objet
    hulk: json['hulk'] != null
        ? UserVSLRespFromJson(json['hulk'])
        : null, // Facultatif et sous-objet
    join_request: json['join_request'] as String?, // Facultatif
    id: json['id'] as String,
  );
}
