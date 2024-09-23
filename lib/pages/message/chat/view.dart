import 'package:firebase_chat/common/style/style.dart';
import 'package:firebase_chat/common/values/values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'controller.dart';
import 'widgets/chat_list.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(() => Container(
            child: Text(
              "${controller.state.to_name}",
              overflow: TextOverflow.clip,
              maxLines: 1,
              style: TextStyle(
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp),
            ),
          )),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 20.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 44.w,
                width: 44.w,
                // decoration: BoxDecoration(color: AppColors.primaryElement),
                child: CachedNetworkImage(
                  imageUrl: controller.state.to_avatar.value,
                  height: 44.w,
                  width: 44.w,
                  imageBuilder: ((context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22.w)),
                          image: DecorationImage(image: imageProvider)),
                    );
                  }),
                  errorWidget: (context, url, error) {
                    return Image(
                        image: AssetImage(controller.state.to_avatar.value));
                  },
                ),
              ),
              Positioned(
                  right: 0.w,
                  height: 14.w,
                  bottom: 5.w,
                  child: Container(
                    height: 14.w,
                    width: 14.w,
                    decoration: BoxDecoration(
                        color: controller.state.to_online.value == "1"
                            ? Colors.green
                            : Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(12.w)),
                        border: Border.all(
                            width: 2, color: AppColors.primaryElementText)),
                  ))
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(child: Obx(() {
        return Stack(
          children: [
            const ChatList(),
            controller.state.more_options.value
                ? Positioned(
                    right: 20.w,
                    bottom: 70.h,
                    height: 200.h,
                    width: 40.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                              height: 40.h,
                              width: 40.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.w),
                                  color: AppColors.primaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(1, 1))
                                  ]),
                              child: const Icon(
                                Icons.attach_file_rounded,
                                color: AppColors.primaryElement,
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.imageFromGallery();
                          },
                          child: Container(
                              height: 40.h,
                              width: 40.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.w),
                                  color: AppColors.primaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(1, 1))
                                  ]),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.primaryElement,
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.goVoiceCall();
                          },
                          child: Container(
                              height: 40.h,
                              width: 40.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.w),
                                  color: AppColors.primaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(1, 1))
                                  ]),
                              child: const Icon(
                                Icons.call,
                                color: AppColors.primaryElement,
                              )),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                              height: 40.h,
                              width: 40.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.w),
                                  color: AppColors.primaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(1, 1))
                                  ]),
                              child: const Icon(
                                Icons.videocam,
                                color: AppColors.primaryElement,
                              )),
                        )
                      ],
                    ))
                : Container(),
            Positioned(
                bottom: 0.w,
                child: Container(
                  // color: Colors.amber,
                  width: 360.w,
                  padding:
                      EdgeInsets.only(left: 20.w, bottom: 10.h, right: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 270.w,
                        padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.w),
                            color: AppColors.primaryBackground,
                            border: Border.all(color: Colors.grey)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 220.w,
                              child: TextField(
                                controller: controller.chatMessageController,
                                keyboardType: TextInputType.multiline,
                                autofocus: false,
                                // onTapOutside: (event) {

                                //   FocusManager
                                //     .instance.primaryFocus
                                //     ?.unfocus();},
                                decoration: InputDecoration(
                                    hintText: "Message .....",
                                    contentPadding: EdgeInsets.only(
                                        left: 15.w, top: 0, bottom: 0),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent))),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.sendMessage();
                              },
                              child: SizedBox(
                                height: 40.w,
                                width: 40.w,
                                child: Icon(
                                  Icons.send,
                                  size: 35.w,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.goMoreOptions();
                        },
                        child: Container(
                          height: 40.w,
                          width: 40.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.w),
                              color: AppColors.primaryElement,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(1, 1))
                              ]),
                          child: Obx(() {
                            return controller.state.more_options.value
                                ? const Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  );
                          }),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        );
      })),
    );
  }
}
