import 'package:flutter/material.dart';
import 'package:cryptohub/widgets/fields/commonfield.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextEditingController controller = TextEditingController();

    // List of cryptos with mock data
    List cryptos = [
      {'image': 'assets/images/arch.jpg', 'name': 'BTC', 'price': '10,000'},
      {'image': 'assets/images/arch.jpg', 'name': 'BTC', 'price': '10,000'}
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(width / 10),
        child: Column(
          children: [
            // The common input field for searching cryptos
            // CommonField(controller: controller),

            // Use Expanded to avoid ListView taking infinite height
            SizedBox(
              height: height / 15,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cryptos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {},
                    leading: Image.asset(
                      cryptos[index]['image'],
                    ),
                    title: Text(cryptos[index]['name'],
                        style: const TextStyle(color: Colors.white)),
                    trailing: Text(cryptos[index]['price'],
                        style: const TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
