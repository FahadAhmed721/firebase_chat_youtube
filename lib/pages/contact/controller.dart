import 'package:firebase_chat/common/entities/contact.dart';
import 'package:firebase_chat/common/entities/entities.dart';
import 'package:firebase_chat/common/store/user.dart';
import 'package:firebase_chat/pages/contact/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/apis/contacts.dart';
import '../../common/routes/names.dart';

class ContactController extends GetxController {
  ContactController();

  final state = ContactState();
  final token = UserStore.to.profile.token;
  final db = FirebaseFirestore.instance;
  final String messageCollection = "message";

  @override
  void onReady() {
    super.onReady();
    print("My Token is $token");
    asyncLoadData();
  }

  void goChat(ContactItem contact) async {
    var from_messages = await db
        .collection(messageCollection)
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: ((value, options) => value.toFirestore()))
        .where("from_token",
            isEqualTo:
                token) // this where will return all the contact which i talk or which i will talk
        .where("to_token", isEqualTo: contact.token)
        .get(); // this where will return only the specific contact to which i am talking right now

    var to_messages = await db
        .collection(messageCollection)
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: ((value, options) => value.toFirestore()))
        .where("from_token", isEqualTo: contact.token)
        .where("to_token", isEqualTo: token)
        .get();
    if (from_messages.docs.isNotEmpty) {
      print("from_messages");
    } else {
      print("to_messages");
    }
// This statement will run only for first time
    if (from_messages.docs.isEmpty && to_messages.docs.isEmpty) {
      var profile = UserStore.to.profile;

      var msgData = Msg(
          from_avatar: profile.avater,
          to_avatar: contact.avater,
          from_name: profile.name,
          to_name: contact.name,
          from_token: profile.token,
          to_token: contact.token,
          from_online: profile.online,
          to_online: contact.online,
          last_msg: "",
          last_time: Timestamp.now(),
          msg_num: 0);

      var doc = await db
          .collection(messageCollection)
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: ((value, options) => value.toFirestore()))
          .add(msgData);

      Get.offAllNamed(AppRoutes.Chat, parameters: {
        "doc_id": doc.id,
        "to_token": contact.token ?? "",
        "to_name": contact.name ?? "",
        "to_avatar": contact.avater ?? "",
        "to_online": contact.online.toString()
      });
    } else {
      if (from_messages.docs.isNotEmpty) {
        Get.toNamed(AppRoutes.Chat, parameters: {
          "doc_id": from_messages.docs.first.id,
          "to_token": contact.token ?? "",
          "to_name": contact.name ?? "",
          "to_avatar": contact.avater ?? "",
          "to_online": contact.online.toString()
        });
      }

      if (to_messages.docs.isNotEmpty) {
        Get.toNamed(AppRoutes.Chat, parameters: {
          "doc_id": to_messages.docs.first.id,
          "to_token": contact.token ?? "",
          "to_name": contact.name ?? "",
          "to_avatar": contact.avater ?? "",
          "to_online": contact.online.toString()
        });
      }
    }
  }

  asyncLoadData() async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    state.contactList.clear();
    var result = await ContactAPI.postContact();
    print("contacts are ${result.contactData}");
    if (result.code == 0) {
      state.contactList.addAll(result.contactData!);
    }
    EasyLoading.dismiss();
  }
}
