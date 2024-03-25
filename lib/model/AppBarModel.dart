class AppBarModel {
  bool status;
  String title;
  String logo;

  AppBarModel({
    required this.status,
    required this.title,
    required this.logo,
  });

  factory AppBarModel.fromJson(Map<String, dynamic> json) => AppBarModel(
        status: json["status"],
        title: json["title"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "title": title,
        "logo": logo,
      };
}