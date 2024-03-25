
Uygulama başlamadan önce [main] dosyasında "OneSignal" ayarları yapılıyor.
Splash Screen'e geçiliyor.
Splash Screen'de veriler çekildikten sonra veriler [AppModel]'e eşlenip [WebScreenView] sayfasına yönlendiriliyor.

[WebScreenView] içinde:
-------------------------------------------------------------------------------
    Bağlantı durumu kontrolü için;

    ConnectivityResult _connectionStatus = ConnectivityResult.none;
    final Connectivity _connectivity = Connectivity();
    late StreamSubscription<ConnectivityResult> _connectivitySubscription;
-------------------------------------------------------------------------------
    WebView için;

    final controller = WebViewController(); tanımlamaları yapılıyor.

initState içinde bağlantı için değişkenler oluşturulup stream'e subscribe olunuyor.

Stream uygulama başlangıcında çalıştığı için web viewi burda ayarlıyoruz.

firsTime değişkeni gecikmeleri azaltmak için kullanıldı.

current url bağlantı kopup geri geldiğinde koptuğu sayfayı yüklemesi için.


