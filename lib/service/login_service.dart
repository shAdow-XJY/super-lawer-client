
import 'package:super_lawer/config/http/http.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/util/number_util.dart';

class LoginService {
  static Future<RResponse> login(String passport, String password) async {
    Map<String, dynamic> response = await Http.post("/v1/user/login",
        params: {"passport": passport, "pwd": ecryptoMd5(password)});
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> sendCheckCode(String mail) async {
    Map<String, dynamic> response =
        await Http.post("/v1/user/check-code/send", params: {"mail": mail});
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> register(
      {required String mail,
      required String checkCode,
      required String cover,
      required String passport,
      required String password,
      required String phone,
      required String username}) async {
    Map<String, dynamic> response = await Http.post("/v1/user/register", data: {
      "check_code": checkCode,
      "cover": cover,
      "email": mail,
      "passport": passport,
      "password": ecryptoMd5(password),
      "phone": phone,
      "username": username
    });
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> forgetPwd({required String passport}) async {
    Map<String, dynamic> response =
        await Http.post("/v1/user/check-code/send/passport", params: {
      "passport": passport,
    });
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> checkCode(
      {required String passport, required String checkCode}) async {
    Map<String, dynamic> response =
        await Http.post("/v1/user/check-code/check", params: {
      "passport": passport,
      "checkCode": checkCode,
    });

    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }

  static Future<RResponse> changePwd(
      {required String passport, required String pwd}) async {
    Map<String, dynamic> response = await Http.put("/v1/user/pwd", params: {
      "passport": passport,
      "pwd": ecryptoMd5(pwd),
    });
    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }
}
