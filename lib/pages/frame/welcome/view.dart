import 'package:firebase_chat/common/style/style.dart';
import 'package:firebase_chat/common/values/values.dart';
import 'package:firebase_chat/pages/frame/welcome/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomePage extends GetView<WelcomController> {
  const WelcomePage({super.key});

  Widget _buildPageHeadTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 350),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: AppColors.primaryElementText,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            fontSize: 45),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryElement,
      body: SizedBox(
        height: 780.h,
        width: 360.w,
        child: _buildPageHeadTitle(controller.title),
      ),
    );
  }
}
