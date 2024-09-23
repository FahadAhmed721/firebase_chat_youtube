import 'dart:convert';

import 'package:firebase_chat/common/apis/chat.dart';
import 'package:firebase_chat/common/entities/calls.dart';
import 'package:firebase_chat/common/routes/routes.dart';
import 'package:firebase_chat/common/store/user.dart';
import 'package:firebase_chat/common/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'state.dart';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import "package:permission_handler/permission_handler.dart";

class VoiceCallController extends GetxController {
  VoiceCallController();

  final state = VoiceCallState();
  final player = AudioPlayer();
  String appId = APPID;
  final db = FirebaseFirestore.instance;
  final profile_token = UserStore.to.profile.token;
  late final RtcEngine engine;

  @override
  void onInit() async {
    super.onInit();
    var data = Get.parameters;

    state.to_name.value = data["to_name"] ?? "";
    state.to_avatar.value = data["to_avatar"] ?? "";
    state.to_token.value = data["to_token"] ?? "";
    state.call_role.value = data["call_role"] ?? "";
    state.doc_id.value = data["doc_id"] ?? "";

    await initEngine();
  }

  Future<void> initEngine() async {
    await player.setAsset("assets/Sound_Horizon.mp3");
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));
    engine.registerEventHandler(RtcEngineEventHandler(
      onError: ((err, msg) {
        print("onError $err, msg is $msg");
      }),
      onJoinChannelSuccess: (connection, elapsed) {
        print("onConnection ${connection.toJson()}");
        state.isJoined.value = true;
      },
      onUserJoined: (connection, remoteUid, elapsed) async {
        await player.pause();
      },
      onLeaveChannel: (connection, stats) {
        state.isJoined.value = false;
        print(".....User has been left the room........");
      },
      onRtcStats: (connection, stats) {
        print("....Time ....... ${stats.duration}");
      },
    ));

    await engine.enableAudio();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.setAudioProfile(
        profile: AudioProfileType.audioProfileDefault,
        scenario: AudioScenarioType.audioScenarioGameStreaming);
    await joinChannel();
    if (state.call_role.value == "anchor") {
      //Future.delayed(Duration(seconds: 10), () async {
      await sendNotification("voice");
      //});

      await player.play();
    }
  }

  Future<void> sendNotification(String type) async {
    CallRequestEntity callRequestEnity = CallRequestEntity();
    callRequestEnity.call_type = type;
    callRequestEnity.doc_id = state.doc_id.value;
    callRequestEnity.to_avatar = state.to_avatar.value;
    callRequestEnity.to_name = state.to_name.value;
    callRequestEnity.to_token = state.to_token.value;

    var res = await ChatApi.call_notification(callRequestEnity);
    if (res.code == 0) {
      print("notification success");
    } else {
      print("notification failed");
    }
  }

  Future<String> getToken() async {
    if (state.call_role.value == "anchor") {
      state.channelId.value = md5
          // eg=> profile_token = 12          state.to_token =  13
          .convert(utf8.encode("${profile_token}_${state.to_token}"))
          .toString();
    } else {
      state.channelId.value = md5
          // eg=> profile_token = 12          state.to_token =  13 In other side value will be same
          .convert(utf8.encode("${state.to_token}_$profile_token"))
          .toString();
    }

    CallTokenRequestEnity callTokenRequest = CallTokenRequestEnity();
    callTokenRequest.channel_name = state.channelId.value;
    var res = await ChatApi.call_token(callTokenRequest);
    if (res.code == 0) {
      return res.data!;
    }

    return "";
  }

  Future<void> joinChannel() async {
    await Permission.microphone.request();
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    String token = await getToken();
    if (token.isEmpty) {
      EasyLoading.dismiss();
      Get.back();
      return;
    }
// this token and channelId is generated from agora website
    await engine.joinChannel(
        token: token,
        channelId: state.channelId.value,
        uid: 0,
        options: const ChannelMediaOptions(
            channelProfile: ChannelProfileType.channelProfileCommunication,
            clientRoleType: ClientRoleType.clientRoleBroadcaster));

    EasyLoading.dismiss();
  }

  Future<void> leaveChannel() async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    await player.pause();
    state.isJoined.value = false;
    EasyLoading.dismiss();
    Get.back();
  }

  Future<void> _dispose() async {
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
  }

  @override
  void onClose() {
    _dispose();
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void dispose() {
    _dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
