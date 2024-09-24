import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> getCryptoNews() async {
  final response =
      await http.get(Uri.parse('https://api.coingecko.com/api/v3/news'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse.containsKey('data')) {
      return jsonResponse['data'] as List<dynamic>;
    } else {
      throw Exception('Unexpected response structure');
    }
  } else {
    throw Exception('Failed to load news');
  }
}
