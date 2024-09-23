import 'package:firebase_chat/common/routes/routes.dart';
import 'package:firebase_chat/common/services/storage.dart';
import 'package:firebase_chat/common/store/user.dart';
import 'package:firebase_chat/pages/frame/welcome/state.dart';
import 'package:firebase_chat/pages/profile/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:google_sign_in/google_sign_in.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ProfileController();
  final title = "Chatty .";
  final state = ProfileState();
  // Declare observable properties for animations
  late Rx<AnimationController> animationController;
  late Rx<Animation<Color?>> colorAnimation;
  late Rx<Animation<double?>> sizeAnimation;

  @override
  void onInit() {
    super.onInit();
    var userData = Get.arguments;
    if (userData != null) {
      state.user_Profile.value = userData;
    }
    animationController = AnimationController(
            vsync: this, duration: const Duration(milliseconds: 200))
        .obs;
    // This color animation is just for learning
    colorAnimation = ColorTween(begin: Colors.grey, end: Colors.red)
        .animate(animationController.value)
        .obs;

    sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
          tween: Tween<double>(begin: 35.w, end: 50.w), weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 50.w, end: 35.w), weight: 50)
    ]).animate(animationController.value).obs;
    animationController.value.addListener(() {
      animationController.refresh();
      print("animation ${animationController.value.value}");
      print("size animation ${sizeAnimation.value.value}");
    });
    animationController.value.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
      } else if (status == AnimationStatus.dismissed) {}
    });
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    animationController.value.dispose();
  }
}
