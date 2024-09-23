import 'dart:convert';

import 'package:firebase_chat/common/entities/user.dart';
import 'package:firebase_chat/common/utils/http.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class UserAPI {
  static Future<UserLoginResponseEntity> login(
      {LoginRequestEntity? params}) async {
    var response =
        await HttpUtil().post("api/login", queryParameters: params!.toJson());
    print("response is $response");
    print("response is ${response.runtimeType}");
    return UserLoginResponseEntity.fromJson(response);
  }
}
