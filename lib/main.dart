import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:newsx/api_keys.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

// to format date
String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate = DateFormat('dd-MMM-yyyy').format(dateTime);
  return formattedDate;
}

// to remove quotes from link
String formatLink(String link) {
  if (link.isNotEmpty) {
    return link.substring(0, link.length - 0);
  } else {
    return 'Sorry Link Not Found';
  }
}

// fetching data from api
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
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
      child: const NewsX(),
    ),
  );
}

class NewsX extends StatelessWidget {
  const NewsX({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NewsX',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light, // Initial brightness is light
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Dark theme configuration
      ),
      home: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display SplashScreen while fetching data
            return const SplashScreen();
          } else if (snapshot.hasError) {
            // Display error message if data fetching fails
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            // Data loaded successfully, navigate to NewsList with loaded data
            return NewsList(data: snapshot.data!);
          }
        },
      ),
    );
  }
}

// SplashScreen widget to display splash screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NewsX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Stay Informed, Stay Ahead with NewsX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ThemeProvider class to manage theme mode and night mode
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isNightModeEnabled = false; // New boolean flag

  ThemeMode get themeMode => _themeMode;
  bool get isNightModeEnabled =>
      _isNightModeEnabled; // Getter for night mode flag

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleNightMode(bool value) {
    _isNightModeEnabled = value;
    notifyListeners();
  }
}

// NewsList widget to display list of news
class NewsList extends StatelessWidget {
  final List<dynamic> data;

  const NewsList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isNightModeEnabled =
        Provider.of<ThemeProvider>(context).isNightModeEnabled;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 18, 18),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NewsX',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Stay Informed, Stay Ahead',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.nightlight_round),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleNightMode(
                      !Provider.of<ThemeProvider>(context, listen: false)
                          .isNightModeEnabled);
            },
          ),
        ],
      ),
      body: Container(
        color: isNightModeEnabled ? Colors.white : Colors.black,
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: data.length,
          itemBuilder: (context, index) {
            var item = data[index];
            String date = formatDate(item['pubDate'] ?? 'Not Avaiable');
            dynamic url = formatLink(item['link'] ?? 'Sorry Link Not Found');
            return ListTile(
              leading: Text(
                (index + 1).toString(),
              ),
              title: Text(
                item['title'] ?? 'Title Not Found',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: isNightModeEnabled ? Colors.black : Colors.white,
                ),
              ),
              subtitle: Text(
                'Source ${item['source'] ?? 'not avaiable'}  Publish Date $date',
                style: TextStyle(
                  color: isNightModeEnabled ? Colors.black : Colors.white,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  Share.share(
                    'Check out this news: ${item['title']} $url',
                  );
                },
              ),
              onTap: () => launchUrlString(url),
            );
          },
        ),
      ),
    );
  }
}
