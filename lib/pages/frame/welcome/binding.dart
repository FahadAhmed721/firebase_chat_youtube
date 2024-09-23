import 'package:firebase_chat/pages/frame/welcome/controller.dart';
import 'package:get/get.dart';

class WelcomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomController>(() => WelcomController());
  }
}
