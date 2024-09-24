import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:translator/translator.dart';

class NewsDetailPage extends StatefulWidget {
  String title;
  String Description;

  NewsDetailPage({super.key, required this.title, required this.Description});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  @override
  final GoogleTranslator _translator =
      GoogleTranslator(); // Create an instance of the translator

  String _translatedtitle = '';
  String _translateddescription = '';
  bool is_loading = false;

  void _translateText(title, description) async {
    setState(() {
      is_loading = true;
    });
    if (title.isNotEmpty && description.isNotEmpty) {
      var title_translation = await _translator.translate(
        title.toString(),
        from: 'en', // Specify the source language (English in this case)
        to: 'am', // Specify the target language (Spanish in this case)
      );
      var description_translation = await _translator.translate(
        description.toString(),
        from: 'en', // Specify the source language (English in this case)
        to: 'am', // Specify the target language (Spanish in this case)
      );
      setState(() {
        _translatedtitle = title_translation.toString();
        _translateddescription =
            description_translation.toString(); // Update the translated text
      });
      setState(() {
        is_loading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(height / 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios))
                ],
              ),
              SizedBox(
                height: height / 20,
              ),
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: height / 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height / 10,
              ),
              Text(
                widget.Description,
                style: TextStyle(
                    fontSize: height / 50, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: height / 10,
              ),
              is_loading
                  ? Lottie.asset('assets/lottie/loader.json')
                  : InkWell(
                      onTap: () {
                        _translateText(widget.title, widget.Description);
                      },
                      child: Container(
                        height: height / 15,
                        child: Center(
                          child: Text(
                            "Translate to Amharic",
                            style: TextStyle(
                                fontSize: height / 50,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        width: width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue),
                      ),
                    ),
              SizedBox(
                height: height / 20,
              ),
              Text(
                _translatedtitle,
                style: GoogleFonts.notoSansEthiopic(
                    fontSize: height / 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height / 10,
              ),
              Text(
                _translateddescription,
                style: GoogleFonts.notoSansEthiopic(
                    fontSize: height / 50, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
