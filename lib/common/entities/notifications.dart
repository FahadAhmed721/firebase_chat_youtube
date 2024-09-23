class BindFcmTokenRequestEntity {
  String? fcmToken;

  BindFcmTokenRequestEntity({this.fcmToken});
//Xmx1536M
  Map<String, dynamic> toJson() {
    return {"fcmtoken": fcmToken};
  }
}
