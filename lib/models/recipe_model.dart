class RecipeModel {
  String image;
  String label;
  String source;
  String url;

  RecipeModel(
      {required this.image,
      required this.label,
      required this.source,
      required this.url});

  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    return RecipeModel(
        image: parsedJson["image"],
        label: parsedJson["label"],
        source: parsedJson["source"],
        url: parsedJson["url"]);
  }
}
