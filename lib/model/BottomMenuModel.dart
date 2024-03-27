import 'package:web_view/model/MobileMenuModel.dart';
import 'package:web_view/model/SettingModel.dart';

class BottomMenuModel {
  bool status;
  String style;
  List<MobileMenuModel> links;
  SettingModel setting;

  BottomMenuModel({
    required this.status,
    required this.style,
    required this.links,
    required this.setting,
  });

  factory BottomMenuModel.fromJson(Map<String, dynamic> json) => BottomMenuModel(
        status: json["status"],
        style: json["style"],
        links: List<MobileMenuModel>.from(json["links"].map((x) => MobileMenuModel.fromJson(x))),
        setting: SettingModel.fromJson(json["setting"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "style": style,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "setting": setting.toJson(),
      };
}
