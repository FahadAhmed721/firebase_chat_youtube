import 'package:firebase_chat/common/routes/routes.dart';
import 'package:firebase_chat/pages/frame/welcome/state.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class WelcomController extends GetxController {
  WelcomController();
  final title = "Chatty .";
  final state = WelcomeState();

  @override
  void onReady() {
    if (kDebugMode) {
      print("Welcome Controller Called");
    }

    Future.delayed(
        const Duration(seconds: 3), () => Get.offAllNamed(AppRoutes.Message));

    super.onReady();
  }
}
