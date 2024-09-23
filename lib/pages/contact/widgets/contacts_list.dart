import 'package:firebase_chat/common/entities/contact.dart';
import 'package:firebase_chat/common/values/values.dart';
import 'package:firebase_chat/pages/contact/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ContactsList extends GetView<ContactController> {
  const ContactsList({super.key});

  Widget _buildListItem(ContactItem contact) {
    return Container(
      padding: EdgeInsets.only(top: 10.w),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[100]!))),
      child: InkWell(
        onTap: () {
          controller.goChat(contact);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 44.w,
              width: 44.w,
              // decoration: BoxDecoration(color: AppColors.primaryElement),
              child: CachedNetworkImage(
                imageUrl: contact.avater!,
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
                  return contact.avater != null
                      ? Image.asset(contact.avater!)
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
            Container(
              width: 275.w,
              padding: EdgeInsets.only(
                  top: 10.w, left: 10.w, right: 0.w, bottom: 0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 42.w,
                    width: 200.w,
                    child: Text(
                      "${contact.name}",
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Avenir",
                          fontSize: 16.sp),
                    ),
                  ),
                  Container(
                    height: 12.w,
                    width: 12.w,
                    margin: EdgeInsets.only(top: 5.w),
                    child: Image.asset('assets/icons/ang.png'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 20.w),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var item = controller.state.contactList[index];
                  print(item.name);
                  return _buildListItem(item);
                },
                childCount: controller.state.contactList.length,
              )),
            )
          ],
        ));
  }
}
