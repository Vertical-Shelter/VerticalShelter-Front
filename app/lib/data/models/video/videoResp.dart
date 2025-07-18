class VideoResp {
  String url;

  VideoResp({
    required this.url,
  });
}

VideoResp videoRespFromJson(Map<String, dynamic> json) {
  return VideoResp(
    url: json['url'],
  );
}
