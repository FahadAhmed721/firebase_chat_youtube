import 'package:firebase_chat/common/style/style.dart';
import 'package:firebase_chat/common/values/values.dart';
import 'package:firebase_chat/pages/message/voice_call/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VoiceCallPage extends GetView<VoiceCallController> {
  const VoiceCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(child: Obx(() {
          return Stack(
            children: [
              Positioned(
                  top: 10.h,
                  right: 30.w,
                  left: 30.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        controller.state.callTime.value,
                        style: TextStyle(
                            color: AppColors.primaryElementText,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 150.h),
                        height: 100.w,
                        width: 100.w,
                        // decoration: BoxDecoration(color: AppColors.primaryElement),
                        child: CachedNetworkImage(
                          imageUrl: controller.state.to_avatar.value,
                          height: 100.w,
                          width: 100.w,
                          imageBuilder: ((context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.w)),
                                  image: DecorationImage(image: imageProvider)),
                            );
                          }),
                          errorWidget: (context, url, error) {
                            return const Image(
                                image: AssetImage(
                                    "assets/images/account_header.png"));
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.h),
                        child: Text(
                          controller.state.to_name.value,
                          style: TextStyle(
                              color: AppColors.primaryElementText,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
              Positioned(
                  bottom: 80.h,
                  left: 30.w,
                  right: 30.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: 60.h,
                                width: 60.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.w),
                                    color: controller.state.openMicrophone.value
                                        ? AppColors.primaryBackground
                                        : Colors.grey[800],
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(1, 1))
                                    ]),
                                child: Icon(
                                  Icons.mic,
                                  size: 35.w,
                                  color: controller.state.openMicrophone.value
                                      ? Colors.black
                                      : Colors.white,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "Microphone",
                              style: TextStyle(
                                  color: AppColors.primaryElementText,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (controller.state.isJoined.value) {
                                controller.leaveChannel();
                              } else {
                                controller.joinChannel();
                              }
                            },
                            child: Container(
                                height: 60.h,
                                width: 60.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.w),
                                    color: controller.state.isJoined.value
                                        ? Colors.red
                                        : Colors.green,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(1, 1))
                                    ]),
                                child: Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 35.w,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Text(
                              controller.state.isJoined.value
                                  ? "Disconnect"
                                  : "Connect",
                              style: TextStyle(
                                  color: AppColors.primaryElementText,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                height: 60.h,
                                width: 60.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.w),
                                    color: controller.state.enableSpeaker.value
                                        ? AppColors.primaryBackground
                                        : Colors.grey[800],
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(1, 1))
                                    ]),
                                child: Icon(
                                  Icons.volume_down_rounded,
                                  size: 35.w,
                                  color: controller.state.enableSpeaker.value
                                      ? Colors.black
                                      : Colors.white,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "Speaker",
                              style: TextStyle(
                                  color: AppColors.primaryElementText,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          );
        })));
  }
}
