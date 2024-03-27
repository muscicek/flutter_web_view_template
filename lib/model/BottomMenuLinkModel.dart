
class BottomMenuLinkModel {
  String icon;
  String title;
  String link;

  BottomMenuLinkModel({
    required this.icon,
    required this.title,
    required this.link,
  });

  factory BottomMenuLinkModel.fromJson(Map<String, dynamic> json) => BottomMenuLinkModel(
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
