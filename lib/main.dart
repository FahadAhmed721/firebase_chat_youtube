import 'package:firebase_chat/common/routes/routes.dart';
import 'package:firebase_chat/common/style/theme.dart';
import 'package:firebase_chat/global.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'common/utils/firebaseMessagingHandler.dart';

void main() async {
  await Global.iniit();

  firebaseChatInit().then((value) {
    FirebaseMessagingHandler.config();
  });

  runApp(const MyApp());
}

Future firebaseChatInit() async {
  FirebaseMessaging.onBackgroundMessage(
      FirebaseMessagingHandler.firebaseMessagingBackground);
  if (GetPlatform.isAndroid) {
    await FirebaseMessagingHandler.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(FirebaseMessagingHandler.channel_call);

    await FirebaseMessagingHandler.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(FirebaseMessagingHandler.channel_message);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 780),
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: AppTheme.light,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            builder: EasyLoading.init(),
          );
        });
  }
}
