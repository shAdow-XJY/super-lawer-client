import 'package:dio/dio.dart';
import 'package:super_lawer/config/http/http.dart';
import 'package:super_lawer/model/response.dart';

class FileService {
  static Future<RResponse> uploadFile(String filePath) async {
    var image = await MultipartFile.fromFile(
      filePath,
    );
    FormData formData =
        FormData.fromMap({"file": image, "module": "user-cover"});
    Map<String, dynamic> response =
        await Http.post("/v1/file/upload", data: formData);

    return RResponse(
        code: response['code'],
        message: response['message'],
        data: response['data']);
  }
}
