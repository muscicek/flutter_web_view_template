import 'package:web_view/model/AppBarModel.dart';
import 'package:web_view/model/BottomMenuModel.dart';
import 'package:web_view/model/MobileMenuModel.dart';

class AppModel {
  List<String> displayNoneClasses;
  BottomMenuModel bottomMenu;
  AppBarModel appBar;
  MobileMenuModel mobileMenu;
  String loadingIcon;

  AppModel({
    required this.displayNoneClasses,
    required this.bottomMenu,
    required this.appBar,
    required this.mobileMenu,
    required this.loadingIcon,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) => AppModel(
        displayNoneClasses: List<String>.from(json["display_none_classes"].map((x) => x)),
        bottomMenu: BottomMenuModel.fromJson(json["bottom_menu"]),
        appBar: AppBarModel.fromJson(json["app_bar"]),
        mobileMenu: MobileMenuModel.fromJson(json["mobile_menu"]),
        loadingIcon: json["loading_icon"],
      );

  Map<String, dynamic> toJson() => {
        "display_none_classes": List<dynamic>.from(displayNoneClasses.map((x) => x)),
        "bottom_menu": bottomMenu.toJson(),
        "app_bar": appBar.toJson(),
        "mobile_menu": mobileMenu.toJson(),
        "loading_icon": loadingIcon,
      };
}
