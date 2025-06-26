import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ssda/Services/Exceptions/api_exception.dart';

// Your kdioBaseOptions remains unchanged
var kdioBaseOptions = BaseOptions(
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
);

class ApiService {
  static final Dio _dio = Dio(kdioBaseOptions);
  static final GetStorage _box = GetStorage(); // GetStorage instance

  static Future requestMethods({
    String? methodType,
    required String url,
    dynamic body,
    Map<String, String>? customHeaders,
    bool isAuthorize = false, // This parameter is now respected
  }) async {
    if (url.isEmpty) throw ApiException(400, "URL is Required");

    try {
      Response response;
      final Map<String, dynamic> headers = customHeaders ?? {};
      headers.putIfAbsent("Cache-Control", () => "no-cache");

      // --- <<< CORE CHANGE: Automatically add Authorization header >>> ---
      if (isAuthorize) {
        final String? token = _box.read('authToken');
        print('Token being used for request: $token');

        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      }
      // --- <<< END OF CHANGE >>> ---

      Options options = Options(headers: headers);

      switch (methodType) {
        case "GET":
          response = await _dio.get(url, options: options);
          break;
        case "POST":
          response = await _dio.post(url, data: body, options: options);
          break;
        case "PUT":
          response = await _dio.put(url, data: body, options: options);
          break;
        case "DELETE":
          response = await _dio.delete(url, data: body, options: options);
          break;
        default:
          throw ApiException(400, "Invalid Method Type");
      }
      return response.data;
    } on DioException catch (e) {
      return Future.error(ApiException(
        e.response?.statusCode ?? 500,
        e.message ?? "Dio Error",
        stackTrace: e.stackTrace,
      ));
    } catch (e, s) {
      throw ApiException(500, e.toString(), stackTrace: s);
    }
  }
}