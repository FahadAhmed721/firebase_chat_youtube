import 'package:firebase_chat/common/style/style.dart';
import 'package:firebase_chat/common/values/values.dart';
import 'package:firebase_chat/pages/contact/controller.dart';
import 'package:firebase_chat/pages/contact/widgets/contacts_list.dart';
import 'package:firebase_chat/pages/frame/welcome/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        "Contact",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.normal,
            fontSize: 16.sp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SizedBox(
        height: 780.h,
        width: 360.w,
        child: const ContactsList(),
      ),
    );
  }
}
