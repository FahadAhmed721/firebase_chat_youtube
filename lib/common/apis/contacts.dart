import 'package:firebase_chat/common/entities/contact.dart';
import 'package:firebase_chat/common/utils/http.dart';

class ContactAPI {
  static Future<ContactResponseEntity> postContact() async {
    var response = await HttpUtil().post("api/contact");
    return ContactResponseEntity.fromJson(response);
  }
}
