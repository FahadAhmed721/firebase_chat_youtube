class CallTokenRequestEnity {
  String? channel_name;

  CallTokenRequestEnity({this.channel_name});

  Map<String, dynamic> toJson() {
    return {"channel_name": channel_name};
  }

  factory CallTokenRequestEnity.fromJson(Map<String, dynamic> json) {
    return CallTokenRequestEnity(channel_name: json['channel_name']);
  }
}

class CallRequestEntity {
  String? call_type;
  String? to_token;
  String? to_avatar;
  String? doc_id;
  String? to_name;

  CallRequestEntity(
      {this.call_type,
      this.doc_id,
      this.to_avatar,
      this.to_name,
      this.to_token});

  Map<String, dynamic> toJson() {
    return {
      "call_type": call_type,
      "to_token": to_token,
      "to_avatar": to_avatar,
      "doc_id": doc_id,
      "to_name": to_name
    };
  }
}

class BaseResponseEntity {
  int? code;
  String? data;
  String? msg;

  BaseResponseEntity({
    this.code,
    this.data,
    this.msg,
  });

  factory BaseResponseEntity.fromJson(Map<String, dynamic> jsonMap) {
    return BaseResponseEntity(
        code: jsonMap['code'], data: jsonMap['data'], msg: jsonMap['msg']);
  }

  Map<String, dynamic> toJson() {
    return {"counts": code, "msg": msg, "items": data};
  }
}
