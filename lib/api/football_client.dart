import 'package:http/http.dart' as http;

class FootballClient {
  static const apiUrl = "https://api-football-v1.p.rapidapi.com/v3/";

  static const headers = {
    'X-RapidAPI-Key': '8aa68cfb04msh1ed868d9d0dc8b5p1ce766jsna54d37d1a0cc',
    'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com'
  };

  static Future<http.Response> get({
    required String url,
    Map<String, String>? headers,
  }) async {
    return await http.get(
      Uri.parse('$apiUrl$url'),
      headers: headers,
    );
  }
}
