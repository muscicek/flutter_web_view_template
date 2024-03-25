
class SettingModel {
  String bgColor;
  String iconColor;
  String activeColor;

  SettingModel({
    required this.bgColor,
    required this.iconColor,
    required this.activeColor,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        bgColor: json["bg_color"],
        iconColor: json["icon_color"],
        activeColor: json["active_color"],
      );

  Map<String, dynamic> toJson() => {
        "bg_color": bgColor,
        "icon_color": iconColor,
        "active_color": activeColor,
      };
}
