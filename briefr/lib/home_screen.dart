import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'dart:html' as html; 
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:url_launcher/url_launcher.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userEmail;
  List<dynamic> newsArticles = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _fetchNewsByCategory('general'); 
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email');
    });
  }

  Future<void> _fetchNewsByCategory(String category) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=API_KEY',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          newsArticles = data['articles'];
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch news: ${response.statusCode}')),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('News Headlines', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                _showUserProfile();
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(userEmail ?? 'Guest'),
                accountEmail: Text(userEmail ?? 'guest@example.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    userEmail != null ? userEmail![0].toUpperCase() : 'G',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              ListTile(
                title: Text('General News'),
                onTap: () {
                  _fetchNewsByCategory('general');
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                title: Text('Technology'),
                onTap: () {
                  _fetchNewsByCategory('technology');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Sports'),
                onTap: () {
                  _fetchNewsByCategory('sports');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Health'),
                onTap: () {
                  _fetchNewsByCategory('health');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Business'),
                onTap: () {
                  _fetchNewsByCategory('business');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildNewsListView(),
      ),
    );
  }

  Widget _buildNewsListView() {
    return ListView.builder(
      itemCount: newsArticles.length,
      itemBuilder: (context, index) {
        var article = newsArticles[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  article['urlToImage'] ?? 'https://via.placeholder.com/300x200',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Icon(Icons.error, color: Colors.grey[500]),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['title'] ?? 'No Title',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      article['description'] ?? 'No Description',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article['source']['name'] ?? 'Unknown Source',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          child: Text('Read More'),
                          onPressed: () => _openArticle(article['url']),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUserProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile: $userEmail')),
    );
  }

  void _openArticle(String? url) async {
    if (url != null) {
      if (kIsWeb) {
        
      //  html.window.open(url, '_blank');
      } else {
        
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid URL')),
      );
    }
  }
}
