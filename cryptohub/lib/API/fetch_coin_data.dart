import 'package:cryptohub/widgets/screens/chartpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<CandleData>> fetchCandlestickData(String coinId, int days) async {
  final url =
      'https://api.coingecko.com/api/v3/coins/$coinId/ohlc?vs_currency=usd&days=$days';
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<CandleData> candleData = data.map((entry) {
        return CandleData(
          DateTime.fromMillisecondsSinceEpoch(entry[0]),
          entry[1], // open
          entry[2], // high
          entry[3], // low
          entry[4], // close
        );
      }).toList();
      return candleData;
    } else {
      // Provide more context for HTTP errors
      throw Exception(
          'Failed to load data: ${response.statusCode} - ${response.body}-${coinId}');
    }
  } catch (e) {
    // Catch any other errors (like network issues)
    throw Exception('Failed to fetch data: $e');
  }
}
