
class MobileMenuModel {
  String icon;
  String title;
  String link;

  MobileMenuModel({
    required this.icon,
    required this.title,
    required this.link,
  });

  factory MobileMenuModel.fromJson(Map<String, dynamic> json) => MobileMenuModel(
        icon: json["icon"],
        title: json["title"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "icon": icon,
        "title": title,
        "link": link,
      };
}
