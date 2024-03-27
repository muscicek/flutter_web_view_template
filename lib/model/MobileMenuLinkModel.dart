
class MobileMenuLinkModel {
  String icon;
  String title;
  String link;

  MobileMenuLinkModel({
    required this.icon,
    required this.title,
    required this.link,
  });

  factory MobileMenuLinkModel.fromJson(Map<String, dynamic> json) => MobileMenuLinkModel(
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
