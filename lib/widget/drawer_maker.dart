import 'package:flutter/material.dart';

import 'package:web_view/model/MobileMenuModel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomDrawer extends StatelessWidget {
  final List<MobileMenuModel> mobileMenuList;
  final List<Widget> items;
  final String logoUrl;

  CustomDrawer({
    required this.items,
    required this.mobileMenuList,
    required this.logoUrl,
  });

  factory CustomDrawer.maker(
      {required List<MobileMenuModel> mobileMenuList, required logoUrl, required controller, required scaffoldKey}) {
    List<Icon> icon_list = [];
    mobileMenuList.forEach((element) {
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

    return CustomDrawer(
      mobileMenuList: mobileMenuList,
      logoUrl: logoUrl,
      items: List.generate(
          mobileMenuList.length,
          (index) => newMethod(mobileMenuList.elementAt(index).link, icon_list.elementAt(index),
                  mobileMenuList.elementAt(index).title, () {
                controller.loadRequest(Uri.parse(mobileMenuList.elementAt(index).link));
                scaffoldKey.currentState?.closeDrawer();
              }, controller, scaffoldKey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width / 1.20,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width / 1.20,
              height: MediaQuery.of(context).size.height / 6,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        "https://perukmarket.com.tr/image/cache/catalog/perukmarket_logo-220x50.png",
                        height: MediaQuery.of(context).size.height / 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text("Peruk Market", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
                      ),
                      Text("Keyifli alışverişler dileriz.",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                    ]),
              ),
            ),
            for (var item in items) item
          ],
        ),
      ),
    );
  }
}

Widget newMethod(String url, Icon head_icon, String text, Function() onTap, WebViewController controller,
    GlobalKey<ScaffoldState> scaffoldKey) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: head_icon,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Icon(Icons.chevron_right_sharp, size: 28),
        ),
      ],
    ),
  );
}
