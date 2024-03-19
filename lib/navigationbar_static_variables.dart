import 'package:flutter/material.dart';

class AppNavigationBarVariables {
  static const Color selected_item_color = Color.fromRGBO(252, 151, 239, 1);
  static const Color unselected_item_color = Color.fromRGBO(168, 168, 168, 1);

  static const List<String> navigation_bar_items_url = [
    "https://perukmarket.com.tr/",
    "https://perukmarket.com.tr/index.php?route=product/search",
    "https://perukmarket.com.tr/alisveris-sepetim",
    "https://perukmarket.com.tr/",
    "https://perukmarket.com.tr/giris-yap"
  ];

  static List<BottomNavigationBarItem> navigation_bar_items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Anasayfa"),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: "Ara"),
    BottomNavigationBarItem(icon: Icon(Icons.shop_outlined), label: "Sepet"),
    BottomNavigationBarItem(icon: Icon(Icons.place), label: "Boş"),
    BottomNavigationBarItem(icon: Icon(Icons.heart_broken), label: "Hesabım"),
  ];
}
