import 'package:firebase_chat/common/apis/chat.dart';
import 'package:firebase_chat/common/entities/notifications.dart';
import 'package:firebase_chat/common/routes/names.dart';
import 'package:firebase_chat/common/store/user.dart';
import 'package:firebase_chat/pages/message/state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:get/get.dart';

class MessageController extends GetxController {
  MessageController();
  final title = "Chatty .";
  final state = MessageState();

  void goProfile() async {
    await Get.toNamed(AppRoutes.Profile, arguments: state.head_detail.value);
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  @override
  void onReady() {
    super.onReady();

    firebaseMessageSetup();
  }

  void getProfile() {
    var profile = UserStore.to.profile;
    state.head_detail.value = profile;
    state.head_detail.refresh();
  }

  firebaseMessageSetup() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null) {
      BindFcmTokenRequestEntity bindFcmTokenRequestEntity =
          BindFcmTokenRequestEntity();

      bindFcmTokenRequestEntity.fcmToken = fcmToken;

      ChatApi.bind_fcmtoken(bindFcmTokenRequestEntity);
    }
  }
}
