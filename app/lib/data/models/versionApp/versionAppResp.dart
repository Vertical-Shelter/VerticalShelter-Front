class VersionAppResp {
  VersionAppResp({
    this.version,
    this.message,
    this.url,
    this.forceUpdate,
  });

  String? version;
  String? message;
  String? url;
  bool? forceUpdate;
  bool needUpdate = false;

  factory VersionAppResp.fromJson(Map<String, dynamic> json) => VersionAppResp(
        version: json["version"],
        message: json["message"],
        forceUpdate: json["force_update"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "version": version,
        "message": message,
        "forceUpdate": forceUpdate,
      };
}

VersionAppResp versionAppRespFromJson(Map<String, dynamic> json) =>
    VersionAppResp.fromJson(json);
