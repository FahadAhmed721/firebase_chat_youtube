import 'dart:async';
import 'dart:io';
import 'package:firebase_chat/common/apis/chat.dart';
import 'package:firebase_chat/common/entities/entities.dart';
import 'package:firebase_chat/common/routes/routes.dart';
import 'package:firebase_chat/common/store/user.dart';
import 'package:firebase_chat/common/widgets/widgets.dart';
import 'package:firebase_chat/pages/frame/welcome/state.dart';
import 'package:firebase_chat/pages/message/chat/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/utils/message_enums.dart';

class ChatController extends GetxController {
  ChatController();
  final title = "Chatty .";
  final state = ChatState();
  late String doc_id;
  var chatMessageController = TextEditingController();

  // get the user sender token
  final token = UserStore.to.profile.token;

  //firebase data instance
  final db = FirebaseFirestore.instance;
  late StreamSubscription<QuerySnapshot<Msgcontent>> listener;
  ScrollController messageScrollController = ScrollController();
  bool isLoadMore = true;
  File? _photo;
  final ImagePicker imagePicker = ImagePicker();

  goMoreOptions() {
    state.more_options.value = state.more_options.value ? false : true;
  }

  goVoiceCall() {
    state.more_options.value = false;
    Get.toNamed(AppRoutes.VoiceCall, parameters: {
      "to_token": state.to_token.value,
      "to_name": state.to_name.value,
      "to_avatar": state.to_avatar.value,
      "call_role": "anchor",
      "doc_id": doc_id
    });
  }

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    print(data);
    doc_id = data["doc_id"]!;
    state.to_token.value = data["to_token"] ?? "";
    state.to_name.value = data["to_name"] ?? "";
    state.to_avatar.value = data["to_avatar"] ?? "";
    state.to_online.value = data["to_online"] ?? "1";
  }

  @override
  void onReady() {
    super.onReady();
    state.msgcontentList.clear();
    final messages = db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (msgContent, options) => msgContent.toFirestore())
        .orderBy("addtime", descending: true)
        .limit(15);

    listener = messages.snapshots().listen((event) {
      List<Msgcontent> tempMsgList = <Msgcontent>[];
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:

            // Handle If you add any new doc in firebase.
            if (change.doc.data() != null) {
              tempMsgList.add(change.doc.data()!);
            }

            break;
          case DocumentChangeType.modified:
            // TODO: Handle If you updated any doc in firebase.
            break;
          case DocumentChangeType.removed:
            // TODO: Handle If you deleted any doc in firebase.
            break;
        }
      }
      tempMsgList.reversed.forEach((element) {
        state.msgcontentList.value.insert(0, element);
      });
      state.msgcontentList.refresh();
      if (messageScrollController.hasClients) {
        print("messagescroll controller");
        messageScrollController.position.animateTo(
            // points to the very top of your list
            // lowest index // 0
            // minScrollExtent or maxScrollExtent works together with reverse proporty of a Custom ScrollView or any Scroll view
            messageScrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      }
    });

    /// This addlistener is for pagination
    messageScrollController.addListener(() {
      if (messageScrollController.offset + 20 >
          messageScrollController.position.maxScrollExtent) {
        if (isLoadMore) {
          state.isLoading.value = true;
          // to stop unecessary request to firebase
          isLoadMore = false;
          asyncLoadMoreData();
        }
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    listener.cancel();
    chatMessageController.dispose();
    messageScrollController.dispose();
  }

  Future<void> asyncLoadMoreData() async {
    final messages = await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (msg, option) => msg.toFirestore())
        .orderBy("addtime", descending: true)
        .where("addtime", isLessThan: state.msgcontentList.value.last.addtime)
        .limit(10)
        .get();
    if (messages.docs.isNotEmpty) {
      messages.docs.forEach((element) {
        var data = element.data();
        state.msgcontentList.value.add(data);
      });
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      isLoadMore = true;
    });
    state.isLoading.value = false;
  }

  Future imageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      await uploadImage();
    } else {}
  }

  Future uploadImage() async {
    var result = await ChatApi.upload_img(file: _photo);
    if (result.code == 0) {
      sendImageMessage(result.data!);
    } else {
      toastInfo(msg: "sending image failed");
    }
  }

  Future<void> sendImageMessage(String url) async {
    Msgcontent msgcontent = Msgcontent(
        token: token,
        content: url,
        type: MessageSecondryType.IMAGE.name,
        addtime: Timestamp.now());

    await db
        .collection("message")
        .doc(doc_id)
        .collection('msglist')
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (msgData, option) => msgData.toFirestore())
        .add(msgcontent)
        .then((DocumentReference doc) {
      print("new IMAGE message doc is ....${doc.id} ");
    });

    var messageresult = await db
        .collection("message")
        .doc(doc_id)
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (msg, option) => msg.toFirestore())
        .get();

    // to know if we have any unread messages or calls
    if (messageresult.data() != null) {
      var item = messageresult.data()!;
      int to_msg_num = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int from_msg_num = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_token == token) {
        from_msg_num = from_msg_num + 1;
      } else {
        to_msg_num = to_msg_num + 1;
      }
      await db.collection("message").doc(doc_id).update({
        "to_msg_num": to_msg_num,
        "from_msg_num": from_msg_num,
        "last_msg": "[image]",
        "last_time": Timestamp.now()
      });
    }
  }

  Future<void> sendMessage() async {
    String messageContent = chatMessageController.text;

    if (messageContent.isEmpty) {
      return;
    }

    Msgcontent msgcontent = Msgcontent(
        token: token,
        content: messageContent,
        type: MessageSecondryType.TEXT.name,
        addtime: Timestamp.now());

    await db
        .collection("message")
        .doc(doc_id)
        .collection('msglist')
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (msgData, option) => msgData.toFirestore())
        .add(msgcontent)
        .then((DocumentReference doc) {
      chatMessageController.clear();
      print("new message doc is ....${doc.id} ");
    });

    var messageresult = await db
        .collection("message")
        .doc(doc_id)
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (msg, option) => msg.toFirestore())
        .get();

    // to know if we have any unread messages or calls
    if (messageresult.data() != null) {
      var item = messageresult.data()!;
      int to_msg_num = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int from_msg_num = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_token == token) {
        from_msg_num = from_msg_num + 1;
      } else {
        to_msg_num = to_msg_num + 1;
      }
      await db.collection("message").doc(doc_id).update({
        "to_msg_num": to_msg_num,
        "from_msg_num": from_msg_num,
        "last_msg": messageContent,
        "last_time": Timestamp.now()
      });
    }
  }

  void closeAllPop() {
    Get.focusScope!.unfocus();
    state.more_options.value = false;
  }
}
