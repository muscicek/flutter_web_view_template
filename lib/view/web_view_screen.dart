import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_view/model/AppModel.dart';
import 'package:web_view/view/no_connection_page.dart';
import 'package:web_view/widget/bottom_navigation_bar_maker.dart';
import 'package:web_view/widget/bottom_navigation_bar_v2_maker.dart';
import 'package:web_view/widget/drawer_maker.dart';
import 'package:web_view/widget/fab_maker.dart';
import 'package:webview_flutter/webview_flutter.dart';

bool firstTime = true;

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.appModel});

  final AppModel appModel;
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final controller = WebViewController();
  int _selectedIndex = 0;
  var loading = true;
  var currentUrl = "https://perukmarket.com.tr/";

  void _onItemTapped(int index) {
    setState(() {
      loading = true;
      controller.loadRequest(Uri.parse(widget.appModel.bottomMenu.links.elementAt(index).link));
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
                  switch (change.url) {
                    case "https://perukmarket.com.tr/":
                      setState(() {
                        _selectedIndex = 0;
                      });
                      break;
                    case "https://perukmarket.com.tr/index.php?route=product/search":
                      setState(() {
                        _selectedIndex = 1;
                      });
                      break;
                    case "https://perukmarket.com.tr/alisveris-sepetim":
                      setState(() {
                        _selectedIndex = 2;
                      });
                      break;
                    case "https://perukmarket.com.tr/hakkimizda":
                      setState(() {
                        _selectedIndex = 3;
                      });
                      break;
                    case "https://perukmarket.com.tr/giris-yap":
                      setState(() {
                        _selectedIndex = 4;
                      });
                      break;

                    default:
                  }
                  setState(() {
                    print("change");
                    loading = true;
                  });
                },
                onPageStarted: (String url) {
                  setState(() {
                    print("change");
                    loading = true;
                  });
                },
                onPageFinished: (String url) {
                  late String jsCode;
                  if (!widget.appModel.displayNoneClasses.isEmpty) {
                    widget.appModel.displayNoneClasses.forEach((element) {
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
                  });
                },
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) async {
                  if (request.url.startsWith("https://perukmarket.com.tr/")) {
                    return NavigationDecision.navigate;
                  }

                  //launch Url tıklanan linkin bir uygulaması var ise o uygulamaya gitmeye yarıyor
                  if (!await launchUrl(Uri.parse(request.url))) {
                    print("asdsa");
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
            //extend body navigation barın diğer style'ında fab'ının arkasındaki boşluğu silmek için
            extendBody: true,
            key: _scaffoldKey,

            //App bar ve Header Menü

            appBar: widget.appModel.appBar.status
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
                    title: Image.network(widget.appModel.appBar.logo, height: 35),
                  )
                : null,

            // Mobile Menü Status durumu gelince burada kontrol edilir.
            drawer: widget.appModel.status == true
                ? CustomDrawer.maker(
                    mobileMenuList: widget.appModel.mobileMenu,
                    logoUrl: widget.appModel.appBar.logo,
                    controller: controller,
                    scaffoldKey: _scaffoldKey,
                  )
                : null,
            body: loading == true
                ? Shimmer.fromColors(
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
                  )
                : _connectionStatus == ConnectivityResult.mobile || _connectionStatus == ConnectivityResult.wifi
                    ? WebViewWidget(
                        controller: controller,
                      )
                    : NoConnectionView(),

            //Bottom Navigation Bar'ın diğer style'ı için floating action button kullanılacak

            floatingActionButton: getFab(widget.appModel.bottomMenu.style),
            floatingActionButtonLocation: getFabLocation(widget.appModel.bottomMenu.style),
            bottomNavigationBar: getBottomNavigationBar(widget.appModel.bottomMenu.style)),
      ),
    );
  }

  Widget? getFab(String style) {
    switch (style) {
      case "style-1":
        return null;

      default:
        return CustomFab.maker(
            bottomMenu: widget.appModel.bottomMenu, currentIndex: _selectedIndex, onTap: _onItemTapped);
    }
  }

  Widget getBottomNavigationBar(String style) {
    switch (style) {
      case "style-1":
        return CustomNavigationBar.maker(
            bottomMenu: widget.appModel.bottomMenu,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed);
      default:
        return CustomNavigationBarV2.maker(
            bottomMenu: widget.appModel.bottomMenu, currentIndex: _selectedIndex, onTap: _onItemTapped);
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
