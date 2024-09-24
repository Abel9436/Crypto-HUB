import 'package:cryptohub/API/fetch_all_coins.dart';
import 'package:cryptohub/widgets/fields/commonfield.dart';
import 'package:cryptohub/widgets/screens/chartpage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'dart:async';
import 'package:scroll_bottom_navigation_bar/scroll_bottom_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class CoinsListPage extends StatefulWidget {
  @override
  _CoinsListPageState createState() => _CoinsListPageState();
}

class _CoinsListPageState extends State<CoinsListPage> {
  late Future<List<Coin>> _coins;
  TextEditingController coinController = TextEditingController();
  List<Coin> filteredCoins = [];
  List<Coin> allCoins = [];
  Random random = Random();
  int random_index = 0;
  int filtered_coin_length = 0;

  final ScrollController _scrollController =
      ScrollController(); // For scrollable navbar

  @override
  void initState() {
    super.initState();
    _fetchCoins();
  }

  Future<void> _fetchCoins() async {
    _coins = fetchAllCoins();
    _coins.then((coins) {
      setState(() {
        allCoins = coins;
        filteredCoins = coins;
        filtered_coin_length = filteredCoins.length;
        if (filtered_coin_length > 0) {
          random_index = random.nextInt(filtered_coin_length);
        }
      });
    });
  }

  Future<void> _refreshCoins() async {
    await _fetchCoins();
  }

  void filterCoins(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCoins = allCoins;
      } else {
        filteredCoins = allCoins.where((coin) {
          return coin.name.toLowerCase().contains(query.toLowerCase()) ||
              coin.symbol.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      filtered_coin_length = filteredCoins.length;
      if (filtered_coin_length > 0) {
        random_index = random.nextInt(filtered_coin_length);
      }
    });
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(height / 20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/logo.jpg'),
                ),
                color: Color.fromARGB(255, 50, 50, 50),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crypto HUB',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.telegram),
              title: Text('Telegram Channel'),
              onTap: () async {
                if (await canLaunchUrl(
                    Uri.parse('https://t.me/crypto_hub_vip1'))) {
                  await launchUrl(Uri.parse('https://t.me/crypto_hub_vip1'));
                } else {
                  throw 'Could not launch URL';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Me'),
              onTap: () async {
                final Uri url = Uri.parse('https://t.me/AbelBekele07');
                if (!await launchUrl(url,
                    mode: LaunchMode.externalApplication)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch $url')),
                  );
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_box_rounded),
              title: Text('Portfolio'),
              onTap: () async {
                final Uri url = Uri.parse('https://linktr.ee/abela06');
                if (!await launchUrl(url,
                    mode: LaunchMode.externalApplication)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch $url')),
                  );
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 1, 1, 1),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image(
              fit: BoxFit.cover,
              height: height / 15,
              image: AssetImage('assets/images/logo.jpg'),
            ),
            Text(
              'Crypto HUB',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(width / 20),
            child: CommonField(
              OnChanged: filterCoins,
              controller: coinController,
              placeholder: filtered_coin_length > 0
                  ? filteredCoins[random_index].name
                  : 'Search for coins',
              prifix_icon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshCoins,
              child: FutureBuilder<List<Coin>>(
                future: _coins,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Lottie.asset(
                            height: height / 5, 'assets/lottie/loader.json'));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Lottie.asset(
                            height: height / 3.5, 'assets/lottie/error.json'));
                  } else if (!snapshot.hasData || filteredCoins.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                            height: height / 3.5,
                            'assets/lottie/search_not_found.json'),
                        Text(
                          coinController.text.toString() + ' Coin Not Found',
                          style: TextStyle(
                              fontSize: height / 50,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ));
                  } else {
                    return ListView.builder(
                      controller: _scrollController, // Assign scroll controller
                      padding: EdgeInsets.only(top: height / 30),
                      itemCount: filteredCoins.length,
                      itemBuilder: (context, index) {
                        final coin = filteredCoins[index];
                        return ListTile(
                          leading: Image.network(coin.imageUrl,
                              width: 40, height: 40),
                          title: Text(coin.name,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(coin.symbol.toUpperCase(),
                              style: const TextStyle(color: Colors.grey)),
                          trailing: Text('\$${coin.currentPrice.toString()}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CandleStickChartPage(coniname: coin.id),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
