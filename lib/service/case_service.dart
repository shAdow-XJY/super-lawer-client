import 'package:super_lawer/config/http/http.dart';
import 'package:super_lawer/model/response.dart';

class CaseService {
  // project
  static Future<RResponse> listCases() async {
    Map<String, dynamic> response = await Http.get("/v1/case-type/");
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> createCase(
      String name, String content, int serviceId, DateTime endTime) async {
    Map<String, dynamic> response =
    // await Http.post("/v1/projects/commit", data: {
    //   "end_time": endTime.toString(),
    //   "project_content": content,
    //   "project_name": name,
    //   "project_type": "法律咨询",
    //   "service_id": serviceId
    // });
    await Http.post("/v1/case", data: {
      "accept_addr": "string",
      "accept_unit_name": "string",
      "case_application": "string",
      "case_commit_time": "2022-07-30T14:51:15.657Z",
      "case_reason": "string",
      "case_type": "string",
      "party_vos": [
        {
          "organize_type": "string",
          "party_attribute": "string",
          "party_name": "string",
          "party_type": "string"
        }
      ]
    });

    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

}
