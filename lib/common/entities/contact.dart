class ContactItem {
  String? name;
  String? token;
  int? online;
  String? avater;
  String? description;

  ContactItem(
      {this.avater, this.description, this.name, this.online, this.token});

  factory ContactItem.fromJson(Map<String, dynamic> json) => ContactItem(
        avater: json["avatar"],
        description: json["description"],
        name: json["name"],
        online: json["online"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "avatar": avater,
        "description": description,
        "name": name,
        "online": online,
        "token": token
      };
}

class ContactResponseEntity {
  int? code;
  List<ContactItem>? contactData;
  String? msg;

  ContactResponseEntity({
    this.code,
    this.contactData,
    this.msg,
  });

  factory ContactResponseEntity.fromJson(Map<String, dynamic> json) {
    return ContactResponseEntity(
        code: json['code'],
        contactData: json['data'] == null
            ? []
            : List<ContactItem>.from(
                json['data'].map((contact) => ContactItem.fromJson(contact))),
        msg: json['msg']);
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": contactData == null
            ? []
            : List<dynamic>.from(contactData!.map((e) => e.toJson())),
      };
}
