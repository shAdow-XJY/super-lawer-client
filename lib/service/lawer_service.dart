import 'package:super_lawer/config/http/http.dart';
import 'package:super_lawer/model/response.dart';

class LawerService {
  static Future<RResponse> handleProject(int projectId, int result) async {
    Map<String, dynamic> response = await Http.post("/v1/projects/$projectId",
        params: {"handleResult": result});
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> listCase(String caseStatus) async {
    Map<String, dynamic> response =
    await Http.get("/v1/case/", params: {"caseStatus": caseStatus});
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

}
