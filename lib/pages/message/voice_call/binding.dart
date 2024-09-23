import 'package:firebase_chat/pages/frame/welcome/controller.dart';
import 'package:firebase_chat/pages/message/voice_call/controller.dart';
import 'package:get/get.dart';

class VoiceCallBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoiceCallController>(() => VoiceCallController());
  }
}
