import 'package:web_view/model/MobileMenuLinkModel.dart';

class MobileMenuModel {
  bool status;
  String title;
  String description;
  List<MobileMenuLinkModel> links;

  MobileMenuModel({
    required this.status,
    required this.title,
    required this.description,
    required this.links,
  });

  factory MobileMenuModel.fromJson(Map<String, dynamic> json) => MobileMenuModel(
        status: json["status"],
        description: json["description"],
        title: json["title"],
        links: List<MobileMenuLinkModel>.from(json["links"].map((x) => MobileMenuLinkModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "title": title,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "status": status,
      };
}
