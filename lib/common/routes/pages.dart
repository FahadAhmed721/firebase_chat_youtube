import 'package:flutter/material.dart';
import 'package:firebase_chat/common/middlewares/middlewares.dart';

import 'package:get/get.dart';

import '../../pages/frame/sigin/index.dart';
import '../../pages/contact/index.dart';
import '../../pages/frame/welcome/index.dart';
import '../../pages/message/index.dart';
import '../../pages/message/chat/index.dart';
import '../../pages/message/voice_call/index.dart';
import '../../pages/profile/index.dart';

import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static const APPlication = AppRoutes.Application;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
      // middlewares: [
      //   RouteWelcomeMiddleware(priority: 1),
      // ],
    ),
    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => const SignInPage(),
      binding: SignInBinding(),
    ),
    /*
    // check if needed to login or not
    GetPage(
      name: AppRoutes.Application,
      page: () => ApplicationPage(),
      binding: ApplicationBinding(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),
    */

    GetPage(
        name: AppRoutes.Contact,
        page: () => ContactPage(),
        binding: ContactBinding()),
    GetPage(
        name: AppRoutes.Message,
        page: () => const MessagePage(),
        binding: MessageBinding(),
        middlewares: [RouteAuthMiddleware(priority: 1)]),
    GetPage(
      name: AppRoutes.Profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
        name: AppRoutes.Chat, page: () => ChatPage(), binding: ChatBinding()),
    GetPage(
        name: AppRoutes.VoiceCall,
        page: () => VoiceCallPage(),
        binding: VoiceCallBinding()),
    /*
    //我的
    GetPage(name: AppRoutes.Me, page: () => MePage(), binding: MeBinding()),
    //聊天详情
    

    GetPage(name: AppRoutes.Photoimgview, page: () => PhotoImgViewPage(), binding: PhotoImgViewBinding()),*/
  ];
}
