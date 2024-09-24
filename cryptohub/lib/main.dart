import 'package:cryptohub/widgets/screens/coin_list_page.dart';
import 'package:cryptohub/widgets/screens/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Coins List',
      theme: ThemeData.dark(),
      home: Homepage(),
    );
  }
}
