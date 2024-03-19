import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:web_view/header_menu_static_variables.dart';
import 'package:web_view/navigationbar_static_variables.dart';
import 'package:web_view/no_connection_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final controller = WebViewController();
  int _selectedIndex = 0;
  var loading = true;
  var currentUrl = 'https://perukmarket.com.tr/';
  void _onItemTapped(int index) {
    setState(() {
      controller.loadRequest(Uri.parse(AppNavigationBarVariables.navigation_bar_items_url.elementAt(index).toString()));
      _selectedIndex = index;
    });
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    var newCurrent = await controller.currentUrl();
    if (newCurrent != null) {
      currentUrl = newCurrent;
    }

    setState(() {
      loading = true;
    });
    setState(() {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        //controller.loadRequest(Uri.parse(currentUrl));
        controller
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onUrlChange: (change) {
                setState(() {
                  print("change");
                  loading = true;
                });
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {
                String
                    jsCode = /*"var elements = document.getElementsByClassName('mobile-top-bar');"
                "for (var i = 0; i < elements.length; i++) {"
                "  elements[i].style.display = 'none';"
                "}"
                "var elements = document.getElementsByClassName('bottom-menu bottom-menu-266');"
                "for (var i = 0; i < elements.length; i++) {"
                "  elements[i].style.display = 'none';"
                "}"
                "var elements = document.getElementsByClassName('header-classic');"
                "for (var i = 0; i < elements.length; i++) {"
                "  elements[i].style.display = 'none';"
                "}"*/
                    "var elements = document.getElementsByClassName('bottom-menu bottom-menu-266');"
                    "for (var i = 0; i < elements.length; i++) {"
                    "  elements[i].style.display = 'none';"
                    "}"
                    //burası footerdakileri kaldırıyor
                    "var elements = document.getElementsByClassName(' grid-row grid-row-4');"
                    "for (var i = 0; i < elements.length; i++) {"
                    "  elements[i].style.display = 'none';"
                    "}"
                    "var elements = document.getElementsByClassName(' grid-row grid-row-3');"
                    "for (var i = 0; i < elements.length; i++) {"
                    "  elements[i].style.display = 'none';"
                    "}";

                controller.runJavaScript(jsCode);
                setState(() {
                  debugPrint("finished");
                  loading = false;
                  FlutterNativeSplash.remove();
                });
              },
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(currentUrl));
        setState(() {});
      } else {
        FlutterNativeSplash.remove();
      }

      _connectionStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();

    initConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // WebView'de geriye gidebiliyorsa, geriye git
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,

          //App bar ve Header Menü

          /* appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.list,
                size: 35,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(Icons.refresh, size: 35),
                  onPressed: () {
                    setState(() {
                      controller.reload();
                    });
                  },
                ),
              ),
            ],
            title:
                Image.network("https://perukmarket.com.tr/image/cache/catalog/perukmarket_logo-220x50.png", height: 35),
          ),
          drawer: Container(
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
                        ],
                      ),
                    ),
                  ),
                  for (var i = 0; i < HeaderMenuStaticVariables.header_menu_items.length; i++)
                    newMethod(
                        HeaderMenuStaticVariables.header_menu_items_url.elementAt(i),
                        HeaderMenuStaticVariables.header_menu_items_icons.elementAt(i),
                        HeaderMenuStaticVariables.header_menu_items.elementAt(i))
                ],
              ),
            ),
          ),
         */

          body: _connectionStatus == ConnectivityResult.none
              ? ExampleUiLoadingAnimation()
              : loading == true
                  ? Center(child: CircularProgressIndicator())
                  : WebViewWidget(
                      controller: controller,
                    ),
          bottomNavigationBar: BottomNavigationBar(
            iconSize: 25,
            type: BottomNavigationBarType.fixed,
            items: AppNavigationBarVariables.navigation_bar_items,
            currentIndex: _selectedIndex,
            selectedItemColor: AppNavigationBarVariables.selected_item_color, // Seçili öğenin metin rengi
            unselectedItemColor: AppNavigationBarVariables.unselected_item_color,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Widget newMethod(String url, IconData head_icon, String text) {
    return GestureDetector(
      onTap: () {
        controller.loadRequest(Uri.parse(url));
        _scaffoldKey.currentState?.closeDrawer();
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Icon(head_icon, size: 28),
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
}


// Text(_connectionStatus.toString()),
                    