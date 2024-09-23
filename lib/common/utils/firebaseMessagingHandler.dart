import 'dart:convert';
import 'package:firebase_chat/common/apis/chat.dart';
import 'package:firebase_chat/common/entities/calls.dart';
import 'package:firebase_chat/common/routes/routes.dart';
import 'package:firebase_chat/common/store/config.dart';
import 'package:firebase_chat/common/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_chat/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FirebaseMessagingHandler {
  FirebaseMessagingHandler._();

  static AndroidNotificationChannel channel_call =
      const AndroidNotificationChannel(
          "com.dbestech.chatty.call", "chatty_call",
          importance: Importance.max,
          enableLights: true,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alert'));

  static AndroidNotificationChannel channel_message =
      const AndroidNotificationChannel(
    "com.dbestech.chatty.message",
    "chatty_message",
    importance: Importance.defaultImportance,
    enableLights: true,
    playSound: true,
  );

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> config() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    try {
      await messaging.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        print("initialMessage------");
        print(initialMessage);
        // You can handle the initial message here if needed.
      }

      var initializationSettingsAndroid =
          const AndroidInitializationSettings("@mipmap/ic_launcher");
      var darwinInitializationSettings = const DarwinInitializationSettings();

      LinuxInitializationSettings initializationSettingsLinux =
          const LinuxInitializationSettings(
              defaultActionName: 'Open notification');
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          macOS: darwinInitializationSettings,
          iOS: darwinInitializationSettings,
          linux: initializationSettingsLinux);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveLocalNotification);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Handle the incoming message here in a foreground state.
        // if (message != null) {
        print("message foreground/////");
        _recieveNotification(message);
        // }
      });
    } on Exception catch (error) {
      print("error message /////");
      print(error);
    }
  }

  static Future<void> _recieveNotification(RemoteMessage message) async {
    if (message.data.isNotEmpty && message.data["call_type"] != null) {
      /// 1. voice call, 2. video call, 3. text, 4. cancel
      if (message.data["call_type"] == "voice") {
        var data = message.data;
        var to_token = data["token"];
        var to_name = data["name"];
        var to_avatar = data["avatar"];
        var doc_id = data["doc_id"] ?? "";

        if (to_token != null && to_name != null && to_avatar != null) {
          Get.snackbar(
              icon: SizedBox(
                height: 44.w,
                width: 44.w,
                // decoration: BoxDecoration(color: AppColors.primaryElement),
                child: CachedNetworkImage(
                  imageUrl: to_avatar,
                  height: 44.w,
                  width: 44.w,
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.person);
                  },
                  imageBuilder: ((context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22.w)),
                          image: DecorationImage(image: imageProvider)),
                    );
                  }),
                ),
              ),
              to_name,
              "Voice call",
              duration: const Duration(seconds: 30),
              mainButton: TextButton(
                  onPressed: () {},
                  child: SizedBox(
                    width: 90.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (Get.isSnackbarOpen) {
                              Get.closeAllSnackbars();
                            }
                            FirebaseMessagingHandler._sendNotifications(
                                "cancel", to_token, to_name, to_avatar, doc_id);
                          },
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.w))),
                            child: const Icon(Icons.call_end),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (Get.isSnackbarOpen) {
                              Get.closeAllSnackbars();
                            }
                            Get.toNamed(AppRoutes.VoiceCall, parameters: {
                              "to_token": to_token,
                              "to_name": to_name,
                              "to_avatar": to_avatar,
                              "doc_id": doc_id,
                              "call_role": "audience"
                            });
                          },
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.w))),
                            child: const Icon(Icons.call),
                          ),
                        )
                      ],
                    ),
                  )));
        }
      } else if (message.data["call_type"] == "video") {
        var data = message.data;
        var to_token = data["token"];
        var to_name = data["name"];
        var to_avatar = data["avatar"];
        var doc_id = data["doc_id"] ?? "";

        if (to_token != null && to_name != null && to_avatar != null) {
          ///  @Todo....
          /// I need to add this isCallVoice in call screen for checks that wheather its video or audio
          ConfigStore.to.isCallVoice = true;
          Get.snackbar(
              icon: SizedBox(
                height: 44.w,
                width: 44.w,
                // decoration: BoxDecoration(color: AppColors.primaryElement),
                child: CachedNetworkImage(
                  imageUrl: to_avatar,
                  height: 44.w,
                  width: 44.w,
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.person);
                  },
                  imageBuilder: ((context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22.w)),
                          image: DecorationImage(image: imageProvider)),
                    );
                  }),
                ),
              ),
              to_name,
              "Video call",
              duration: const Duration(seconds: 30),
              mainButton: TextButton(
                  onPressed: () {},
                  child: SizedBox(
                    width: 90.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (Get.isSnackbarOpen) {
                              Get.closeAllSnackbars();
                            }
                            FirebaseMessagingHandler._sendNotifications(
                                "cancel", to_token, to_name, to_avatar, doc_id);
                          },
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.w))),
                            child: const Icon(Icons.call_end),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (Get.isSnackbarOpen) {
                              Get.closeAllSnackbars();
                            }

                            /// here leter will be change by AppRoutes.VideeCall
                            Get.toNamed(AppRoutes.VideoCall, parameters: {
                              "to_token": to_token,
                              "to_name": to_name,
                              "to_avatar": to_avatar,
                              "doc_id": doc_id,
                              "call_role": "audience"
                            });
                          },
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.w))),
                            child: const Icon(Icons.call),
                          ),
                        )
                      ],
                    ),
                  )));
        }
      } else if (message.data["call_type"] == "cancel") {
        FirebaseMessagingHandler.flutterLocalNotificationsPlugin.cancelAll();
        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }
        if (Get.currentRoute.contains(AppRoutes.VoiceCall) ||
            Get.currentRoute.contains(AppRoutes.VideoCall)) {
          Get.back();
        }
        var _prefs = await SharedPreferences.getInstance();
        await _prefs.setString("callVoiceOrVideo", "");
      }
    }
  }

  static Future<void> _sendNotifications(String call_type, String to_token,
      String to_name, String to_avatar, String doc_id) async {
    CallRequestEntity callRequestEntity = CallRequestEntity();
    callRequestEntity.call_type = call_type;
    callRequestEntity.to_token = to_token;
    callRequestEntity.to_avatar = to_avatar;
    callRequestEntity.doc_id = doc_id;
    callRequestEntity.to_name = to_name;

    var res = await ChatApi.call_notification(callRequestEntity);
    if (res.code == 0) {
      print("Send Notification Success");
    } else {
      print("Send Notification failed");
    }
  }

  // static Future<void> showLocalNotification(RemoteMessage message) async {
  //   // Create a notification from the message data.
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     channel_call.id, // Use the appropriate channel ID
  //     channel_call.name, // Use the appropriate channel name
  //     channelDescription: channel_call.description ?? "",
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     enableLights: true,
  //     enableVibration: true,
  //     playSound: true,
  //     // sound: RawResourceAndroidNotificationSound('alert'),
  //   );
  //   var platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   // You can customize the notification title and body here.
  //   await flutterLocalNotificationsPlugin.show(
  //     0, // Use a unique ID for each notification.
  //     message.notification?.title ?? '', // Notification title
  //     message.notification?.body ?? '', // Notification body
  //     platformChannelSpecifics,
  //   );
  // }

  static Future<void> onDidReceiveLocalNotification(
      NotificationResponse notificationResponse) async {
    // Handle local notification when the user taps on it.
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackground(
      RemoteMessage? message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    if (message != null) {
      if (message.data.isNotEmpty && message.data["call_type"] != null) {
        if (message.data["call_type"] == "cancel") {
          FirebaseMessagingHandler.flutterLocalNotificationsPlugin.cancelAll();
          var prefs = await SharedPreferences.getInstance();
          await prefs.setString("callVoiceOrVideo", "");
        }

        if (message.data["call_type"] == "voice" ||
            message.data["call_type"] == "video") {
          var data = {
            "to_token": message.data["token"],
            "to_name": message.data["name"],
            "to_avatar": message.data["avatar"],
            "doc_id": message.data["doc_id"] ?? "",
            "call_type": message.data["call_type"],
            "expire_time": DateTime.now().toString()
          };
          var prefs = await SharedPreferences.getInstance();
          await prefs.setString("callVoiceOrVideo", json.encode(data));
          // Get.to(AppRoutes.INITIAL);
        }
      }
    }

    print('Handling a background message ${message!.messageId}');
  }
}
