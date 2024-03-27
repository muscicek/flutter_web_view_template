import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:web_view/model/BottomMenuModel.dart';

class CustomNavigationBarV4 extends StatelessWidget {
  final BottomMenuModel bottomMenu;
  final List<SalomonBottomBarItem> items;
  final int currentIndex;
  final void Function(int) onTap;

  CustomNavigationBarV4({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.bottomMenu,
  });

  factory CustomNavigationBarV4.maker({
    required BottomMenuModel bottomMenu,
    required int currentIndex,
    required void Function(int) onTap,
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

    return CustomNavigationBarV4(
      bottomMenu: bottomMenu,
      currentIndex: currentIndex,
      onTap: onTap,
      items: List.generate(
        bottomMenu.links.length,
        (index) => SalomonBottomBarItem(
          icon: icon_list.elementAt(index),
          title: Text(bottomMenu.links.elementAt(index).title),
          selectedColor: Color(int.parse(bottomMenu.setting.activeColor)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
        backgroundColor: Color(int.parse(bottomMenu.setting.bgColor)),
        currentIndex: currentIndex,
        onTap: onTap,
        items: items);
  }
}
