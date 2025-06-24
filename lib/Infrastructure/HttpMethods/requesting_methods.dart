import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ssda/Services/Exceptions/api_exception.dart';

// आपका मूल BaseOptions, इसमें कोई बदलाव नहीं है
var kdioBaseOptions = BaseOptions(
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
);

class ApiService {
  static final Dio _dio = Dio(kdioBaseOptions);
  static final GetStorage _box = GetStorage(); // GetStorage का इंस्टेंस

  static Future requestMethods({
    String? methodType,
    required String url,
    dynamic body,
    Map<String, String>? customHeaders,
    bool isAuthorize = false, // <<<--- हम आपके इस पैरामीटर का सम्मान करेंगे
  }) async {
    if (url.isEmpty) throw ApiException(400, "URL is Required");

    try {
      Response response;

      // --- <<< यहाँ महत्वपूर्ण बदलाव किया गया है >>> ---
      // ऑथेंटिकेशन टोकन को स्वचालित रूप से जोड़ने का लॉजिक
      final Map<String, dynamic> headers = customHeaders ?? {};
      headers.putIfAbsent("Cache-Control", () => "no-cache");

      // isAuthorize फ्लैग के आधार पर या सीधे टोकन की जांच करके टोकन जोड़ें
      final String? token = _box.read('authToken');
      if (isAuthorize || token != null) {
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
          print("✅ [ApiService] Auth token found and added to headers.");
        } else {
          print("⚠️ [ApiService] Request needs authorization, but no token was found in storage.");
        }
      }
      // ----------------------------------------------------

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
      print("❌ [ApiService] DioException Occurred:");
      print("URL: ${e.requestOptions.uri}");
      print("Type: ${e.type}");
      if (e.response != null) {
        print("Response Status Code: ${e.response!.statusCode}");
        print("Response Data: ${e.response!.data}");
      }
      return Future.error(ApiException(
          e.response?.statusCode ?? 500, e.message ?? "Dio Error",
          stackTrace: e.stackTrace));
    } catch (e, s) {
      print("❌ [ApiService] Generic error in ApiService: $e");
      throw ApiException(500, e.toString(), stackTrace: s);
    }
  }
}
