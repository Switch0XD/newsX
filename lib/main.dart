import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:newsx/api_keys.dart';
import 'package:url_launcher/url_launcher.dart';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  String formattedDate = DateFormat('dd-MMM-yyyy').format(dateTime);

  return formattedDate;
}

String formatLink(String link) {
  if (link.isNotEmpty) {
    return link.substring(0, link.length - 0);
  } else {
    return 'Sorry Link Not Found';
  }
}

Future<List<dynamic>> fetchData() async {
  final response = await http.get(
    Uri.parse('https://yahoo-finance15.p.rapidapi.com/api/v1/markets/news'),
    headers: {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'yahoo-finance15.p.rapidapi.com'
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['body'];
  } else {
    throw Exception('Failed to load data');
  }
}

void main() {
  runApp(const NewsX());
}

class NewsX extends StatelessWidget {
  const NewsX({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NewsX',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const NewsList(),
    );
  }
}

class NewsList extends StatelessWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 19, 18, 18),
          title: const Text(
            'NewsX',
            style: TextStyle(color: Colors.white),
          )),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                String date = formatDate(item['pubDate'] ?? 'Not Avaiable');

                dynamic url =
                    formatLink(item['link'] ?? 'Sorry Link Not Found');
                print(url);
                // print(item['pubDate'][0]);
                return ListTile(
                    leading: Text(
                      (index + 1).toString(),
                    ),
                    title: Text(
                      item['title'] ?? 'Title Not Found',
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Source ${item['source'] ?? 'not avaiable'}  Publish Date $date'),
                    onTap: () => {
                          launchUrl(url),
                        });
              },
            );
          }
        },
      ),
    );
  }
}
