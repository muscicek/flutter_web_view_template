import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_view/constants/AppConstants.dart';
import 'package:web_view/model/AppModel.dart';
import 'package:web_view/services/dio_services.dart';
import 'package:web_view/view/no_connection_page.dart';
import 'package:web_view/widget/bottom_navigation_bar_maker.dart';
import 'package:web_view/widget/bottom_navigation_bar_maker_v3.dart';
import 'package:web_view/widget/bottom_navigation_bar_maker_v4.dart';
import 'package:web_view/widget/bottom_navigation_bar_v2_maker.dart';
import 'package:web_view/widget/drawer_maker.dart';
import 'package:web_view/widget/fab_maker.dart';
import 'package:web_view/widget/loading_item.dart';
import 'package:webview_flutter/webview_flutter.dart';

bool firstTime = true;

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> with DioServices {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final controller = WebViewController();
  int _selectedIndex = 0;
  var loading = true;
  var splashScreen = true;
  late AppModel appModel;
  var currentUrl = AppConstants.APP_MAIN_URL;

  void _onItemTapped(int index) {
    setState(() {
      loading = true;
      controller.loadRequest(Uri.parse(appModel.bottomMenu.links.elementAt(index).link));
      _selectedIndex = index;
    });
  }

  Future<void> initialData() async {
    appModel = await getData();
    print(appModel.loadingIcon);
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

    return await _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;

    if (result != ConnectivityResult.mobile && result != ConnectivityResult.wifi) {
      setState(() {
        firstTime = true;
      });
    } else {
      setState(() {
        loading = true;
      });
    }

    print("içeri" + _connectionStatus.toString());
    var newCurrent = await controller.currentUrl();

    if (newCurrent != null) {
      currentUrl = newCurrent;
    }

    setState(() {
      if (firstTime) {
        if (_connectionStatus == ConnectivityResult.mobile || _connectionStatus == ConnectivityResult.wifi) {
          controller
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Eğer web sitesinin yüzdelik olarak yüklenme aşamasını görmek istersek kullanılabilir
                },
                onUrlChange: (change) {
                  // Bottom Navigation Bar'ın aktif indexini belirlemek için url değişikliğinde url kontrolü.
                  setState(() {
                    print("change");
                    loading = true;
                  });
                  if (change.url! == appModel.bottomMenu.links.elementAt(0).link) {
                    _selectedIndex = 0;
                  } else if (change.url! == appModel.bottomMenu.links.elementAt(1).link) {
                    _selectedIndex = 1;
                  } else if (change.url! == appModel.bottomMenu.links.elementAt(2).link) {
                    _selectedIndex = 2;
                  } else if (change.url! == appModel.bottomMenu.links.elementAt(3).link) {
                    _selectedIndex = 3;
                  } else if (change.url! == appModel.bottomMenu.links.elementAt(4).link) {
                    _selectedIndex = 4;
                  }
                },
                onPageStarted: (String url) {
                  print("change");
                  loading = true;
                },
                onPageFinished: (String url) {
                  late String jsCode;
                  if (!appModel.displayNoneClasses.isEmpty) {
                    appModel.displayNoneClasses.forEach((element) {
                      jsCode = "var elements = document.getElementsByClassName('$element');"
                          "for (var i = 0; i < elements.length; i++) {"
                          "  elements[i].style.display = 'none';"
                          "}";
                      controller.runJavaScript(jsCode);
                    });
                  }
                  
                  setState(() {
                    debugPrint("finished");
                    loading = false;
                    splashScreen = false;
                  });
                },
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) async {
                  if (request.url.startsWith(AppConstants.APP_MAIN_URL)) {
                    return NavigationDecision.navigate;
                  }

                  //launch Url tıklanan linkin bir uygulaması var ise o uygulamaya gitmeye yarıyor
                  if (!await launchUrl(Uri.parse(request.url))) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bu sayfaya geçişe izin verilmiyor'),
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'Kapat',
                          onPressed: () {},
                        ),
                      ),
                    );
                  }
                  return NavigationDecision.prevent;
                },
              ),
            )
            ..loadRequest(Uri.parse(currentUrl));
          firstTime = false;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  Future<void> setup() async {
    await initialData();
    await initConnectivity();
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
      child: splashScreen == true
          ? Scaffold(
              body: Center(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: 200,
                      child: Image(image: NetworkImage(AppConstants.SPLASH_SCREEN_LOGO)))))
          : SafeArea(
              child: Scaffold(
                  //extend body navigation barın diğer style'ında fab'ının arkasındaki boşluğu silmek için
                  extendBody: true,
                  key: _scaffoldKey,

                  //App bar ve Header Menü

                  appBar: appModel.appBar.status
                      ? AppBar(
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
                          title: Image.network(appModel.appBar.logo, height: 35),
                        )
                      : null,
                  drawer: appModel.mobileMenu.status == true
                      ? CustomDrawer.maker(
                          mobileMenuList: appModel.mobileMenu,
                          logoUrl: appModel.appBar.logo,
                          controller: controller,
                          scaffoldKey: _scaffoldKey,
                        )
                      : null,
                  body: loading == true
                      ? getLoadingStyle(appModel.loadingIcon)
                      : _connectionStatus == ConnectivityResult.mobile || _connectionStatus == ConnectivityResult.wifi
                          ? WebViewWidget(
                              controller: controller,
                            )
                          : NoConnectionView(),

                  //Bottom Navigation Bar'ın diğer style'ı için floating action button kullanılacak

                  floatingActionButton: getFab(appModel.bottomMenu.style),
                  floatingActionButtonLocation: getFabLocation(appModel.bottomMenu.style),
                  bottomNavigationBar: getBottomNavigationBar(appModel.bottomMenu.style)),
            ),
    );
  }

  Widget getLoadingStyle(String style) {
    switch (style) {
      case "icon":
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade500,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Container(
            color: Colors.black26,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            ),
          ),
        );
      default:
        return Loading_Item();
    }
  }

  Widget? getFab(String style) {
    switch (style) {
      case "style-1":
        return null;
      case "style-4":
        return null;
      case "style-5":
        return null;
      case "style-6":
        return null;
      default:
        return CustomFab.maker(bottomMenu: appModel.bottomMenu, currentIndex: _selectedIndex, onTap: _onItemTapped);
    }
  }

  Widget getBottomNavigationBar(String style) {
    switch (style) {
      case "style-6":
        return CustomNavigationBarV4.maker(
            bottomMenu: appModel.bottomMenu, currentIndex: _selectedIndex, onTap: _onItemTapped);
      case "style-1":
        return CustomNavigationBar.maker(
            bottomMenu: appModel.bottomMenu,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed);
      case "style-5":
        return CustomNavigationBarV3.maker(
            bottomMenu: appModel.bottomMenu,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed);
      default:
        return CustomNavigationBarV2.maker(
            bottomMenu: appModel.bottomMenu, currentIndex: _selectedIndex, onTap: _onItemTapped);
    }
  }

  FloatingActionButtonLocation getFabLocation(String style) {
    switch (style) {
      case "style-2":
        return FloatingActionButtonLocation.endDocked;
      case "style-3":
        return FloatingActionButtonLocation.centerDocked;
      case "style-4":
        return FloatingActionButtonLocation.centerDocked;
      default:
        return FloatingActionButtonLocation.centerDocked;
    }
  }
}
