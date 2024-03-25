import 'package:flutter/material.dart';
import 'package:web_view/view/splash_screen_view.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("03f94a7a-8419-437f-92d9-652a312c3539");
  OneSignal.Notifications.requestPermission(true);
  OneSignal.User.pushSubscription.addObserver((state) {
    print(OneSignal.User.pushSubscription.optedIn);
    print(OneSignal.User.pushSubscription.id);
    print(OneSignal.User.pushSubscription.token);
    print(state.current.jsonRepresentation());
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/": (_) => SplashScreenView(),
      },
    );
  }
}
