import 'package:http/http.dart' as http;
import 'dart:convert';

// Fetch all coins from the CoinGecko API
Future<List<Coin>> fetchAllCoins() async {
  final url =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Coin> coins = data.map((coinData) {
      return Coin(
        coinData['id'],
        coinData['symbol'],
        coinData['name'],
        coinData['image'],
        coinData['current_price'],
        coinData['market_cap'],
        coinData['price_change_percentage_24h'],
      );
    }).toList();
    return coins;
  } else {
    throw Exception('Failed to load coins data');
  }
}

class Coin {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double currentPrice;
  final double marketCap;
  final double priceChangePercentage24h;

  Coin(
    this.id,
    this.symbol,
    this.name,
    this.imageUrl,
    this.currentPrice,
    this.marketCap,
    this.priceChangePercentage24h,
  );
}
