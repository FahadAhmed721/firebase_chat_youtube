import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? open_id;
  String? name;
  String? token;
  String? email;
  String? avater;
  String? accessToken;
  String? description;
  String? fcmtoken;
  int? online;
  int? type;

  UserData(
      {this.open_id,
      this.name,
      this.email,
      this.avater,
      this.token,
      this.fcmtoken,
      this.description,
      this.accessToken,
      this.online,
      this.type});

  factory UserData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final json = snapshot.data();
    return UserData(
        open_id: json?['open_id'],
        name: json?['name'],
        email: json?['email'],
        avater: json?['avatar'],
        accessToken: json?['access_token'],
        token: json?['token'],
        online: json?['online'],
        description: json?['description'],
        type: json?['type']);
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        open_id: json['open_id'],
        name: json['name'],
        email: json['email'],
        avater: json['avatar'],
        accessToken: json['access_token'],
        token: json['token'],
        online: json['online'],
        description: json['description'],
        type: json['type']);
  }

  Map<String, dynamic> toJson() => {
        // "id": open_id,
        "email": email,
        "avatar": avater,
        // "fcmtoken": fcmtoken,
        "name": name,
        "type": type,
        "open_id": open_id
      };

  // Map<String, dynamic> toFirestore() {
  //   return {
  //     if (id != null) "id": id,
  //     if (name != null) "name": name,
  //     if (email != null) "email": email,
  //     if (photourl != null) "photourl": photourl,
  //     if (location != null) "location": location,
  //     if (fcmtoken != null) "fcmtoken": fcmtoken,
  //     if (addtime != null) "addtime": addtime,
  //   };
  // }
}

class LoginRequestEntity {
  String? open_id;
  String? name;
  String? email;
  String? avater;

  String? fcmtoken;
  // Timestamp? addtime;
  int? type;

  LoginRequestEntity(
      {this.open_id,
      this.name,
      this.email,
      this.avater,
      // this.location,
      this.fcmtoken,
      // this.addtime,
      this.type});

  factory LoginRequestEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return LoginRequestEntity(
      open_id: data?['id'],
      name: data?['name'],
      email: data?['email'],
      avater: data?['avatar'],

      // location: data?['location'],
      fcmtoken: data?['fcmtoken'],
      // addtime: data?['addtime'],
    );
  }

  factory LoginRequestEntity.fromJson(Map<String, dynamic> json) {
    return LoginRequestEntity(
      open_id: json['open_id'],
      name: json['name'],
      email: json['email'],
      avater: json['avatar'],
      type: json["type"],
      // location: json['location'],
      fcmtoken: json['fcmtoken'],
      // addtime: json['addtime'],
    );
  }

  Map<String, dynamic> toJson() => {
        // "id": open_id,
        "email": email,
        "avatar": avater,
        // "fcmtoken": fcmtoken,
        "name": name,
        "type": type,
        "open_id": open_id
      };

  Map<String, dynamic> toFirestore() {
    return {
      if (open_id != null) "id": open_id,
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (avater != null) "avatar": avater,
      // if (location != null) "location": location,
      if (fcmtoken != null) "fcmtoken": fcmtoken,
      // if (addtime != null) "addtime": addtime,
    };
  }
}

class UserLoginResponseEntity {
  // String? open_id;
  // String? name;
  int? code;
  UserData? userData;
  String? msg;
  // String? avater;
  // String? accessToken;

  // String? fcmtoken;
  // // Timestamp? addtime;
  // int? type;

  UserLoginResponseEntity({
    this.code,
    this.userData,
    this.msg,
  });

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> jsonMap) {
    return
        // UserLoginResponseEntity(
        //   code: json['code'],
        //   open_id: json['open_id'],
        //   name: json['name'],
        //   email: json['email'],
        //   avater: json['avatar'],
        //   accessToken: json['access_token'],
        //   // location: json['location'],
        //   fcmtoken: json['fcmtoken'],
        //   // addtime: json['addtime'],
        // );

        UserLoginResponseEntity(
            code: jsonMap['code'],
            userData: UserData.fromJson(jsonMap['data']),
            msg: jsonMap['msg']);
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": userData!.toJson(),
      };

  // Map<String, dynamic> toFirestore() {
  //   return {
  //     if (open_id != null) "id": open_id,
  //     if (name != null) "name": name,
  //     if (email != null) "email": email,
  //     if (avater != null) "avatar": avater,
  //     if (accessToken != null) "access_token": accessToken,
  //     // if (location != null) "location": location,
  //     if (fcmtoken != null) "fcmtoken": fcmtoken,
  //     // if (addtime != null) "addtime": addtime,
  //   };
  // }
}

// // 登录返回
// class UserLoginResponseEntity {
//   String? accessToken;
//   String? displayName;
//   String? email;
//   String? photoUrl;

//   UserLoginResponseEntity({
//     this.accessToken,
//     this.displayName,
//     this.email,
//     this.photoUrl,
//   });

//   factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
//       UserLoginResponseEntity(
//         accessToken: json["access_token"],
//         displayName: json["display_name"],
//         email: json["email"],
//         photoUrl: json["photoUrl"],
//       );

//   Map<String, dynamic> toJson() => {
//         "access_token": accessToken,
//         "display_name": displayName,
//         "email": email,
//         "photoUrl": photoUrl,
//       };
// }

class MeListItem {
  String? name;
  String? icon;
  String? explain;
  String? route;

  MeListItem({
    this.name,
    this.icon,
    this.explain,
    this.route,
  });

  factory MeListItem.fromJson(Map<String, dynamic> json) => MeListItem(
        name: json["name"],
        icon: json["icon"],
        explain: json["explain"],
        route: json["route"],
      );
}
