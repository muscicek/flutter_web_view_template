import 'package:flutter/material.dart';
import 'package:web_view/model/BottomMenuModel.dart';

class CustomFab extends StatelessWidget {
  final BottomMenuModel bottomMenu;
  final int currentIndex;
  final void Function(int) onTap;
  final IconData iconData;

  const CustomFab({
    super.key,
    required this.bottomMenu,
    required this.currentIndex,
    required this.onTap,
    required this.iconData,
  });

  factory CustomFab.maker({
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
    late IconData iconData;
    switch (bottomMenu.style) {
      case "style-2":
        iconData = icon_list.elementAt(4);
        break;

      case "style-3":
        iconData = icon_list.elementAt(2);
        break;
      case "style-4":
        break;
      default:
    }

    return CustomFab(
      bottomMenu: bottomMenu,
      currentIndex: currentIndex,
      onTap: onTap,
      iconData: iconData,
    );
  }

  @override
  Widget build(BuildContext context) {
    late int index;
    switch (bottomMenu.style) {
      case "style-2":
        index = 4;

        break;

      case "style-3":
        index = 2;

        break;
      case "style-4":
        break;
      default:
    }
    return FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Color(int.parse(bottomMenu.setting.bgColor)),
        child: Icon(
          iconData,
          color: currentIndex == index
              ? Color(int.parse(bottomMenu.setting.activeColor))
              : Color(int.parse(bottomMenu.setting.iconColor)),
          size: 35,
        ),
        onPressed: () {
          onTap(index);
        }
        //params
        );
  }
}
