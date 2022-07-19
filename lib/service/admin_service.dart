import 'package:super_lawer/config/http/http.dart';
import 'package:super_lawer/model/enterpeiseAuth.dart';
import 'package:super_lawer/model/lawerAuth.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/util/date_util.dart';

class AdminService {
  static Future<RResponse> getAuthList() async {
    Map<String, dynamic> response = await Http.get(
      "/v1/user/auth/list",
    );
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> getAuthDetail(int id, String type) async {
    Map<String, dynamic> response = await Http.get("/v1/user/auth/info/detail",
        params: {'id': id, "authType": type});
    response = response['data']['auth_info'];

    Map<String, dynamic> map = Map();
    switch (response['auth_type']) {
      case 'enterprise':
        map["auth_type"] = "enterprise";
        EnterpeiseAuth enterpeiseAuth = EnterpeiseAuth();

        enterpeiseAuth.id = response['auth_info']['id'];

        enterpeiseAuth.authTime =
            transferTimeStamp(response['auth_info']['create_time'].toString());

        enterpeiseAuth.enterpriseName =
            response['auth_info']['enterprise_name'];
        enterpeiseAuth.institutionCode =
            response['auth_info']['institution_code'];
        enterpeiseAuth.enterpriseAdd = response['auth_info']['enterprise_add'];
        enterpeiseAuth.businessLicenseUrl =
            response['auth_info']['business_license'];
        map["enterpeise"] = enterpeiseAuth;
        break;
      case 'lawer':
        map["auth_type"] = "lawer";
        LawerAuth lawerAuth = LawerAuth();

        lawerAuth.id = response['auth_info']['id'];
        lawerAuth.realName = response['auth_info']['real_name'];
        lawerAuth.idNumber = response['auth_info']['id_number'];
        lawerAuth.degree = response['auth_info']['degree'];
        lawerAuth.workingTime = response['auth_info']['working_time'];
        lawerAuth.idcardFrontUrl = response['auth_info']['idcard_front'];
        lawerAuth.idcardBackUrl = response['auth_info']['idcard_back'];
        lawerAuth.businessLicenseUrl =
            response['auth_info']['business_license'];
        lawerAuth.authTime =
            transferTimeStamp(response['auth_info']['create_time'].toString());
        if (response['auth_info']['sex'] == 0)
          lawerAuth.sex = "男";
        else {
          lawerAuth.sex = "女";
        }
        map["lawer"] = lawerAuth;
        break;
    }
    return RResponse(
        code: response['code'], message: response['message'], data: map);
  }

  static Future<RResponse> handleAuth(String type, int id, int result) async {
    Map<String, dynamic> response = await Http.post("/v1/user/auth",
        params: {"authType": type, "id": id, "result": result});
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> listProject() async {
    Map<String, dynamic> response = await Http.get(
      "/v1/projects/unassigned",
    );
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> listFeeList() async {
    Map<String, dynamic> response = await Http.get(
      "/v1/projects/fee-list",
    );
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> handleFeeDetail(
      int projectId, int handleResult) async {
    Map<String, dynamic> response = await Http.post(
        "/v1/projects/$projectId/fee-handle",
        params: {"handleResult": handleResult});
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> handleProject(
      int projectId, bool handleResult, int lawyerId) async {
    Map<String, dynamic> response = Map();
    if (!handleResult)
      response = await Http.post("/v1/projects/assign/reject",
          params: {"projectId": projectId});
    else {
      response = await Http.post("/v1/projects/assign",
          params: {"projectId": projectId, "lawyerId": lawyerId});
    }
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> listLawers() async {
    Map<String, dynamic> response = await Http.get("/v1/user/lawers");
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }
}
