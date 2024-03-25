import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_view/model/AppModel.dart';
import 'package:web_view/services/dio_services.dart';

import 'package:web_view/view/web_view_screen.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> with DioServices {
  late AppModel appModel;
  @override
  void initState() {
    super.initState();
    initialData();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: 200,
                child: Image(
                    image:
                        NetworkImage("https://perukmarket.com.tr/image/cache/catalog/perukmarket_logo-220x50.png")))));
  }

  Future<void> initialData() async {
    var appModel = await getData();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => WebViewScreen(
                appModel: appModel,
              )),
    );
  }
}
