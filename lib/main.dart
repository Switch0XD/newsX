import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  String formattedDate = DateFormat('dd-MMM-yyyy').format(dateTime);

  return formattedDate;
}

Future<List<dynamic>> fetchData() async {
  final response = await http.get(
    Uri.parse('https://yahoo-finance15.p.rapidapi.com/api/v1/markets/news'),
    headers: {
      'X-RapidAPI-Key': 'd8bb4a67f4mshb612732666c9775p17563djsne55c967f7a8b',
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
  const NewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewsX'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                print(item);
                return ListTile(
                  title: Text(item['title']),
                  subtitle: Text('${item['source']} - ${item['pubDate']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
