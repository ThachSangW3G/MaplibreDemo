import 'package:http/http.dart' as http;

class FetchDataController {
  static Future<String?> fetchUrl(Uri uri) async {
    try {
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
