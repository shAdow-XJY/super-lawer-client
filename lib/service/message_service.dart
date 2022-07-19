import 'package:super_lawer/config/http/http.dart';
import 'package:super_lawer/model/response.dart';

class MessageService {
  static Future<RResponse> listContacts() async {
    Map<String, dynamic> response = await Http.get("/v1/msg/contacts");
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> listMessage(int contactId) async {
    Map<String, dynamic> response =
        await Http.get("/v1/msg/contacts/$contactId");
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> sendMsg(int contactId, String content) async {
    Map<String, dynamic> response =
        await Http.post("  /v1/msg/contacts/$contactId", params: {
      "content": content,
      "msgType": 0,
    });
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }
}
