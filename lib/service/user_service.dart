import 'package:super_lawer/config/http/http.dart';
import 'package:super_lawer/config/http/http_options.dart';
import 'package:super_lawer/model/enterpeiseAuth.dart';
import 'package:super_lawer/model/lawerAuth.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/util/date_util.dart';

class UserService {
  static Future<RResponse> getInfo() async {
    Map<String, dynamic> response = await Http.get("/v1/user/info");
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> checkAuthInfo() async {
    Map<String, dynamic> response = await Http.get("/v1/user/auth/info");
    response = response['data']['auth_info'];

    Map<String, dynamic> map = Map();
    switch (response['auth_type']) {
      case 'enterprise':
        map["auth_type"] = "enterprise";
        EnterpeiseAuth enterpeiseAuth = EnterpeiseAuth();
        enterpeiseAuth.authStatus = response['auth_status'];
        enterpeiseAuth.id = response['auth_info']['id'];
        if (enterpeiseAuth.authStatus == "认证完成")
          enterpeiseAuth.authTime =
              transferTimeStamp(response['auth_info']['auth_time'].toString());
        else {
          enterpeiseAuth.authTime = transferTimeStamp(
              response['auth_info']['create_time'].toString());
        }
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
        lawerAuth.authStatus = response['auth_status'];
        lawerAuth.id = response['auth_info']['id'];
        lawerAuth.realName = response['auth_info']['real_name'];
        lawerAuth.idNumber = response['auth_info']['id_number'];
        lawerAuth.degree = response['auth_info']['degree'];
        lawerAuth.workingTime = response['auth_info']['working_time'];
        lawerAuth.idcardFrontUrl = response['auth_info']['idcard_front'];
        lawerAuth.idcardBackUrl = response['auth_info']['idcard_back'];
        lawerAuth.businessLicenseUrl =
            response['auth_info']['business_license'];
        if (lawerAuth.authStatus == "认证完成")
          lawerAuth.authTime =
              transferTimeStamp(response['auth_info']['auth_time'].toString());
        else {
          lawerAuth.authTime = transferTimeStamp(
              response['auth_info']['create_time'].toString());
        }
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

  static Future<RResponse> authEnterpeise(String url, String enterpeiseName,
      String enterpeiseAdd, String instituteCode) async {
    Map<String, dynamic> response =
        await Http.post("/v1/user/auth/enterprise", data: {
      "business_license_url": url,
      "enterprise_add": enterpeiseAdd,
      "enterprise_name": enterpeiseName,
      "institution_code": instituteCode
    });
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> authlawer(
      String business_license_url,
      String degree,
      String id_number,
      String idcard_back_url,
      String idcard_front_url,
      String real_name,
      int sex,
      int working_time) async {
    Map<String, dynamic> response =
        await Http.post("/v1/user/auth/lawer", data: {
      "business_license_url": business_license_url,
      "degree": degree,
      "id_number": id_number,
      "idcard_back_url": idcard_back_url,
      "idcard_front_url": idcard_front_url,
      "real_name": real_name,
      "sex": sex,
      "working_time": working_time
    });
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> getNewInfo() async {
    Map<String, dynamic> response = await Http.get(
      "/v1/user/info/status",
    );
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }
}
