import 'package:web_view/model/AppBarModel.dart';
import 'package:web_view/model/BottomMenuModel.dart';
import 'package:web_view/model/MobileMenuModel.dart';

class AppModel {
  List<String> displayNoneClasses;
  BottomMenuModel bottomMenu;
  AppBarModel appBar;
  List<MobileMenuModel> mobileMenu;
  String loadingIcon;
  List<String> accessLink;
  String splashIcon;
  int splashTime;

  AppModel({
    required this.displayNoneClasses,
    required this.bottomMenu,
    required this.appBar,
    required this.mobileMenu,
    required this.loadingIcon,
    required this.accessLink,
    required this.splashIcon,
    required this.splashTime,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) => AppModel(
        displayNoneClasses: List<String>.from(json["display_none_classes"].map((x) => x)),
        bottomMenu: BottomMenuModel.fromJson(json["bottom_menu"]),
        appBar: AppBarModel.fromJson(json["app_bar"]),
        mobileMenu: List<MobileMenuModel>.from(json["mobile_menu"].map((x) => MobileMenuModel.fromJson(x))),
        loadingIcon: json["loading_icon"],
        accessLink: List<String>.from(json["access_link"].map((x) => x)),
        splashIcon: json["splash_icon"],
        splashTime: json["splash_time"],
      );

  Map<String, dynamic> toJson() => {
        "display_none_classes": List<dynamic>.from(displayNoneClasses.map((x) => x)),
        "bottom_menu": bottomMenu.toJson(),
        "app_bar": appBar.toJson(),
        "mobile_menu": List<dynamic>.from(mobileMenu.map((x) => x.toJson())),
        "loading_icon": loadingIcon,
        "access_link": List<dynamic>.from(accessLink.map((x) => x)),
        "splash_icon": splashIcon,
        "splash_time": splashTime,
      };
}
