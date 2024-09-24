import 'package:cryptohub/API/fetch_news.dart';
import 'package:cryptohub/widgets/screens/news_detail.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<dynamic>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = getCryptoNews(); // Fetch news when the app starts
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending NEWS'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while fetching data
            return Center(
                child: Lottie.asset(
                    height: height / 5, 'assets/lottie/loader.json'));
          } else if (snapshot.hasError) {
            // If there's an error, display it
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If there's no data, show a message
            return Center(
              child: Text('No news available'),
            );
          } else {
            // Display the news in a ListView
            List<dynamic> news = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(height / 30),
              itemCount: news.length,
              itemBuilder: (context, index) {
                var article = news[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: height / 40),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100)),
                    child: ListTile(
                      tileColor: Color.fromARGB(255, 44, 44, 44),
                      enabled: true,
                      title: Text(article['title'] ?? 'No Title'),
                      subtitle: Text(article['source'] ?? 'Unknown Source'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailPage(
                              title: article['title'].toString(),
                              Description: article['description'].toString(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
