import 'package:http/http.dart' as http;

class RequestsHttp {
  static Future<Map<String, String>> get({
    required String url,
  }) async {
    Map<String, String> responseMap = {
      "success": "",
      "error": "",
    };
    var request = http.Request('GET', Uri.parse(url));

    try {
      http.StreamedResponse response = await request.send().timeout(
            const Duration(seconds: 15),
          );

      if (response.statusCode == 200) {
        responseMap["success"] = await response.stream.bytesToString();
      } else {
        responseMap["error"] = await response.stream.bytesToString();
      }
    } catch (e) {
      responseMap["error"] = e.toString();
    }

    return responseMap;
  }
}
