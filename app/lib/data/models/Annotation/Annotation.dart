class Annotation {
  String id;
  int category_id;
  List<double> segmentation;
  List<double>? bbox;
  double? area;
  int? iscrowd;

  Annotation(
      {
        required this.id,
      required this.category_id,
      required this.segmentation,
      required this.bbox,
      required this.area,
      required this.iscrowd,});
}

Annotation AnnotationfromJson(Map<String, dynamic> item) {
  List<double> listsegmentation = [];
  if (item["segmentation"] != null) {
    for (var segment in item["segmentation"]) {
      listsegmentation.add(segment as double);
    }
  }

  List<double> listbbox = [];
  if (item["listbbox"] != null) {
    for (var bboxItem in item["listbbox"]) {
      listbbox.add(bboxItem as double); 
    }
  }

  return Annotation(
    id: item['id'], 
    category_id: item['category_id'] as int, 
    segmentation: listsegmentation,
    bbox: listbbox, 
    area: item['area'],  
    iscrowd: item['iscrowd'], 
  );
}