import 'package:super_lawer/config/http/http.dart';
import 'package:super_lawer/model/response.dart';

class EnterpeiseService {
  static Future<RResponse> listServices() async {
    Map<String, dynamic> response = await Http.get("/v1/service/");
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> createProject(
      String name, String content, int serviceId, DateTime endTime) async {
    Map<String, dynamic> response =
        await Http.post("/v1/projects/commit", data: {
      "end_time": endTime.toString(),
      "project_content": content,
      "project_name": name,
      "project_type": "法律咨询",
      "service_id": serviceId
    });
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> listProjects(String filter) async {
    Map<String, dynamic> response =
        await Http.get("/v1/projects", params: {"filter": filter});
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> getProjectDetail(int id) async {
    Map<String, dynamic> response = await Http.get(
      "/v1/projects/$id",
    );
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> uploadCheck(int projectId, String url) async {
    Map<String, dynamic> response =
        await Http.post("/v1/projects/$projectId/fee", params: {"feeUrl": url});

    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }
}
