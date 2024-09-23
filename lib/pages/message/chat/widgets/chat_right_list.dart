import 'package:firebase_chat/common/entities/msgcontent.dart';
import 'package:firebase_chat/common/style/style.dart';
import 'package:firebase_chat/common/utils/message_enums.dart';
import 'package:firebase_chat/common/values/server.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatRightList extends StatelessWidget {
  Msgcontent msgcontent;
  ChatRightList({required this.msgcontent, super.key});
  String? imagPath;
  replaceImagePathToCirrectPath() {
    if (msgcontent.type == MessageSecondryType.IMAGE.name) {
      imagPath =
          msgcontent.content?.replaceAll("http://localhost/", SERVER_API_URL);
    }
  }

  @override
  Widget build(BuildContext context) {
    replaceImagePathToCirrectPath();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250.w, minHeight: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.w),
                          color: AppColor.accentColor),
                      child: msgcontent.type == MessageSecondryType.TEXT.name
                          ? Text(
                              msgcontent.content ?? "",
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            )
                          : ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 90.w),
                              child: CachedNetworkImage(imageUrl: imagPath!),
                            )),
                ],
              )),
        ],
      ),
    );
  }
}
