import 'package:dio/dio.dart';
import 'dart:io';

import 'package:firebase_chat/common/entities/calls.dart';
import 'package:firebase_chat/common/entities/notifications.dart';
import 'package:firebase_chat/common/utils/http.dart';

class ChatApi {
  static Future<BaseResponseEntity> bind_fcmtoken(
      BindFcmTokenRequestEntity? bindFcmTokenRequestEntity) async {
    var response = await HttpUtil().post('api/bind_fcmtoken',
        queryParameters: bindFcmTokenRequestEntity?.toJson());

    return BaseResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> call_token(
      CallTokenRequestEnity? callTokenRequestEnity) async {
    var response = await HttpUtil().post('api/get_rtc_token',
        queryParameters: callTokenRequestEnity!.toJson());

    return BaseResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> call_notification(
      CallRequestEntity? callRequestEnity) async {
    var response = await HttpUtil()
        .post('api/send_notice', queryParameters: callRequestEnity!.toJson());

    return BaseResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> upload_img({File? file}) async {
    String fileName = file!.path.split('/').last;
    FormData formData = FormData.fromMap(
        {"file": await MultipartFile.fromFile(file.path, filename: fileName)});
    var response = await HttpUtil().post('api/upload_photo', data: formData);
    return BaseResponseEntity.fromJson(response);
  }
}
