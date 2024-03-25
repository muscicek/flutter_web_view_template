import 'package:flutter/material.dart';
import 'package:web_view/model/BottomMenuModel.dart';


class CustomNavigationBar extends StatelessWidget {
  final BottomMenuModel bottomMenu;
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final void Function(int) onTap;
  final BottomNavigationBarType type;
  
  CustomNavigationBar(
      {required this.items,
      required this.currentIndex,
      required this.onTap,
      required this.type,
      required this.bottomMenu, });

  factory CustomNavigationBar.maker({
    required BottomMenuModel bottomMenu,
    required int currentIndex,
    required void Function(int) onTap,
    required BottomNavigationBarType type,

  }) {
    List<Icon> icon_list = [];
    bottomMenu.links.forEach((element) {
      switch (element.icon) {
        case "home":
          icon_list.add(Icon(Icons.home));
          break;
        case "search":
          icon_list.add(Icon(Icons.search));
          break;
        case "shop_outlined":
          icon_list.add(Icon(Icons.shop_outlined));
          break;
        case "place":
          icon_list.add(Icon(Icons.place));
          break;
        case "heart_broken":
          icon_list.add(Icon(Icons.heart_broken));
          break;
        default:
      }
    });

    return CustomNavigationBar(
      bottomMenu: bottomMenu,
      currentIndex: currentIndex,
      onTap: onTap,
      type: type,
      items: List.generate(
          bottomMenu.links.length,
          (index) => BottomNavigationBarItem(
              icon: icon_list.elementAt(index), label: bottomMenu.links.elementAt(index).title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(int.parse(bottomMenu.setting.bgColor)),
      iconSize: 25,
      type: BottomNavigationBarType.fixed,
      items: items,
      currentIndex: currentIndex,
      selectedItemColor: Color(int.parse(bottomMenu.setting.activeColor)),
      unselectedItemColor: Color(int.parse(bottomMenu.setting.iconColor)),
      onTap: onTap,
    );
  }
}
