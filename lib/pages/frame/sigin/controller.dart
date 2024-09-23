import 'dart:convert';

import 'package:firebase_chat/common/apis/user.dart';
import 'package:firebase_chat/common/entities/user.dart';
import 'package:firebase_chat/common/routes/routes.dart';
import 'package:firebase_chat/common/store/user.dart';
import 'package:firebase_chat/common/widgets/widgets.dart';
import 'package:firebase_chat/pages/frame/sigin/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:google_sign_in/google_sign_in.dart";
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../common/utils/http.dart';

class SignInController extends GetxController {
  SignInController();

  final state = SignInState();

  final GoogleSignIn _googleSignIn = GoogleSignIn(//scopes: ['openid']
      );

  Future<void> handleSignin(String type) async {
    try {
      if (type == "phone number") {
        if (kDebugMode) {
          print(".. you are logging with phone numebr..");
        }
      } else if (type == "google") {
        var user = await _googleSignIn.signIn();
        if (user != null) {
          String? displayName = user.displayName;
          String email = user.email;
          String id = user.id;
          String photoUrl = user.photoUrl ?? "";
          LoginRequestEntity userDataListRequestEnitity = LoginRequestEntity();
          userDataListRequestEnitity.name = displayName;
          userDataListRequestEnitity.email = email;
          userDataListRequestEnitity.open_id = id;
          userDataListRequestEnitity.avater = photoUrl;
          userDataListRequestEnitity.type = 2;
          // print(jsonEncode(userDataListRequestEnitity));
          asyncPostAllData(userDataListRequestEnitity);
        }
      } else {
        if (kDebugMode) {
          print(".. login type not sure ..");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("There is an error here $e");
      }
    }
  }

  asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    // var response = await HttpUtil().get('/api/index');
    // print("response is ${response}");
    // UserStore.to.setIsLogin = true;
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    var result = await UserAPI.login(params: loginRequestEntity);
    if (result.code == 0) {
      await UserStore.to.saveProfile(result.userData!);
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      toastInfo(msg: "Some thing wend wrong");
    }
    print("result is ${result.userData!.token}");
    Get.offAllNamed(AppRoutes.Message);
  }
}
