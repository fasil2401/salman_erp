import 'dart:developer';

import 'package:axolon_erp/firebase_options.dart';
import 'package:axolon_erp/services/db_helper/db_helper.dart';
import 'package:axolon_erp/utils/Routes/route_manger.dart';
import 'package:axolon_erp/utils/Theme/theme_provider.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:axolon_erp/view/home_screen/navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await DbHelper().database;
  await UserSimplePreferences.init();
  runApp(const MyApp());
}

Future<void> handleBackgoundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

// void handleMessage(RemoteMessage? message) {
//   if (message == null) return;
//   Get.to(() => NavigationScreen(
//         screenIndex: 1,
//       ));
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'Axolon ERP',
        debugShowCheckedModeBanner: false,
        theme: ThemeProvider().theme,
        initialRoute: RouteManager().routes[0].name,
        getPages: RouteManager().routes,
        navigatorKey: navigatorKey,
        // home: SplashScreen(),
      );
    });
  }
}
