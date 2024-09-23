import 'package:firebase_chat/common/routes/names.dart';
import 'package:firebase_chat/common/values/values.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat/pages/message/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

  Widget _buildFloatingActionButton() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.Contact);
      },
      child: Container(
        height: 50.w,
        width: 50.w,
        decoration: BoxDecoration(
            color: AppColors.secondaryElementText,
            borderRadius: BorderRadius.circular(50.w)),
        child: const Icon(Icons.perm_contact_calendar),
      ),
    );
  }

  Widget _headBar() {
    return Center(
      child: Container(
        width: 320.w,
        // height: 44.h,
        margin: EdgeInsets.only(
          bottom: 20.h,
        ),
        child: Row(
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (BuildContext context, double val, child) {
                return Opacity(
                    opacity: val,
                    child: Container(
                      width: 44.h * val,
                      height: 44.h * val,
                      margin: EdgeInsets.only(top: val * 20.h),
                      child: child,
                    ));
              },
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.goProfile();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.primaryBackground,
                          borderRadius: BorderRadius.all(Radius.circular(22.h)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1))
                          ]),
                      child: CachedNetworkImage(
                        imageUrl: controller.state.head_detail.value.avater!,
                        imageBuilder: ((context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22.w)),
                                image: DecorationImage(image: imageProvider)),
                          );
                        }),
                        errorWidget: (context, url, error) {
                          return controller.state.head_detail.value.avater !=
                                  null
                              ? Image.asset(
                                  controller.state.head_detail.value.avater!,
                                )
                              : Container(
                                  height: 44.w,
                                  width: 44.w,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22.w)),
                                  ));
                        },
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 5.w,
                      right: 0.w,
                      height: 14.w,
                      child: Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2.w,
                                color: AppColors.primaryElementText),
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.w))),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _buildFloatingActionButton(),
        body: Obx(() {
          return SafeArea(
              child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 50.h,
                    title: _headBar(),
                  ),
                  // SliverToBoxAdapter(
                  //   child: Container(
                  //     height: 30.w,
                  //     width: 30.w,
                  //     decora
                  //   ),
                  // )
                ],
              )
            ],
          ));
        }));
  }
}
