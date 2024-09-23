import 'package:firebase_chat/common/style/style.dart';
import 'package:firebase_chat/common/values/values.dart';
import 'package:firebase_chat/pages/frame/welcome/controller.dart';
import 'package:firebase_chat/pages/profile/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  AppBar _buildAppbar() {
    return AppBar(
      title: Text(
        "Profile",
        style: TextStyle(
            color: AppColor.primaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 120.w,
          width: 120.w,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(60.w)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1))
              ]),
          child: CachedNetworkImage(
            imageUrl: controller.state.user_Profile.value.avater!,
            height: 120.w,
            width: 120.w,
            imageBuilder: ((context, imageProvider) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(60.w)),
                    image: DecorationImage(image: imageProvider)),
              );
            }),
            errorWidget: (context, url, error) {
              return controller.state.user_Profile.value.avater != null
                  ? Image.asset(
                      controller.state.user_Profile.value.avater!,
                    )
                  : Container(
                      height: 120.w,
                      width: 120.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(22.w)),
                      ));
            },
          ),
        ),
        Positioned(
            bottom: 0.w,
            right: 0.w,
            child: Obx(() {
              final animationController = controller.animationController.value;
              final sizeAnimation = controller.sizeAnimation.value.value;
              return GestureDetector(
                onTap: () {
                  if (animationController.isCompleted) {
                    animationController.reverse();
                  } else {
                    animationController.forward();
                  }
                },
                child: Container(
                  height: sizeAnimation,
                  width: sizeAnimation,
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                      color: AppColors.primaryElement,
                      borderRadius: BorderRadius.circular(40.w)),
                  child: const Icon(Icons.edit),
                ),
              );
            }))
      ],
    );
  }

  Widget _buildCompleteButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 44.h,
        width: 295.w,
        margin: EdgeInsets.only(top: 60.h, bottom: 30.h),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Complete",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.primaryElementText,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        Get.defaultDialog(
            title: "Are you sure to log out?",
            content: Container(),
            onConfirm: () {
              controller.logout();
            },
            onCancel: () {},
            textConfirm: "Confirm",
            confirmTextColor: Colors.white,
            textCancel: "Cancel");
      },
      child: Container(
        height: 44.h,
        width: 295.w,
        margin: EdgeInsets.only(top: 0.h, bottom: 30.h),
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Logout",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.primaryElementText,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(),
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                child: Column(
                  children: [
                    _buildProfilePhoto(),
                    _buildCompleteButton(),
                    _buildLogoutButton()
                  ],
                ),
              ),
            )
          ],
        )));
  }
}
