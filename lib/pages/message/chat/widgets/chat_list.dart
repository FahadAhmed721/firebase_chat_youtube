import 'package:firebase_chat/pages/message/chat/index.dart';
import 'package:firebase_chat/pages/message/chat/widgets/chat_left_list.dart';
import 'package:firebase_chat/pages/message/chat/widgets/chat_right_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.only(bottom: 70.w),
        child: GestureDetector(
          onTap: () {
            controller.closeAllPop();
          },
          child: CustomScrollView(
            controller: controller.messageScrollController,
            reverse: true,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  var item = controller.state.msgcontentList[index];
                  if (controller.token == item.token) {
                    return ChatRightList(msgcontent: item);
                  } else {
                    return ChatLeftList(
                      msgcontent: item,
                    );
                  }
                }, childCount: controller.state.msgcontentList.length)),
              ),
              SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
                  sliver: SliverToBoxAdapter(
                    child: controller.state.isLoading.value
                        ? const Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container(),
                  )),
            ],
          ),
        ),
      );
    });
  }
}
