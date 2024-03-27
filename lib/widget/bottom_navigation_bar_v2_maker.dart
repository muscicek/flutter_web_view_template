import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:web_view/model/BottomMenuModel.dart';

class CustomNavigationBarV2 extends StatelessWidget {
  final BottomMenuModel bottomMenu;
  final List<IconData> items;
  final int currentIndex;
  final void Function(int) onTap;

  CustomNavigationBarV2({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.bottomMenu,
  });

  factory CustomNavigationBarV2.maker({
    required BottomMenuModel bottomMenu,
    required int currentIndex,
    required void Function(int) onTap,
  }) {
    List<IconData> icon_list = [];
    bottomMenu.links.forEach((element) {
      switch (element.icon) {
        case "home":
          icon_list.add(Icons.home);
          break;
        case "search":
          icon_list.add(Icons.search);
          break;
        case "shop_outlined":
          icon_list.add(Icons.shop_outlined);
          break;
        case "place":
          icon_list.add(Icons.place);
          break;
        case "heart_broken":
          icon_list.add(Icons.heart_broken);
          break;
        default:
      }
    });
    switch (bottomMenu.style) {
      case "style-2":
        icon_list.removeAt(4);
        break;

      case "style-3":
        icon_list.remove(2);

        break;
      case "style-4":
        break;
      default:
    }

    return CustomNavigationBarV2(
      bottomMenu: bottomMenu,
      currentIndex: currentIndex,
      onTap: onTap,
      items: icon_list,
    );
  }

  @override
  Widget build(BuildContext context) {
    late GapLocation gapLocation;
    switch (bottomMenu.style) {
      case "style-2":
        gapLocation = GapLocation.end;

        break;
      case "style-3":
        gapLocation = GapLocation.end;
        break;
      case "style-4":
        gapLocation = GapLocation.none;
        break;
      default:
    }
    return AnimatedBottomNavigationBar(
      backgroundColor: Color(int.parse(bottomMenu.setting.bgColor)),
      icons: items,
      activeIndex: currentIndex,
      activeColor: Color(int.parse(bottomMenu.setting.activeColor)),
      inactiveColor: Color(int.parse(bottomMenu.setting.iconColor)),
      gapLocation: gapLocation,
      elevation: 0,
      notchSmoothness: NotchSmoothness.defaultEdge,
      leftCornerRadius: bottomMenu.style == "style-4" ? 32 : null,
      rightCornerRadius: bottomMenu.style == "style-4" ? 32 : null,
      iconSize: 35,
      onTap: onTap,
      //other params
    );
  }
}
