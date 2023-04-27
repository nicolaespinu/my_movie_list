import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _movies = <dynamic>[];

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  Future<void> _getMovies() async {
    final Response response = await get(Uri.parse('https://yts.mx/api/v2/list_movies.json'));
    if (response.statusCode == 200) {
      setState(() {
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
        _movies = (data['data'] as Map<String, dynamic>)['movies'] as List<dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My movie list'),
      ),
      body: ListView.builder(
          itemCount: _movies.length,
          itemBuilder: (BuildContext context, int index) {
            final String title = (_movies[index] as Map<String, dynamic>)['title'] as String;
            final String year = (_movies[index] as Map<String, dynamic>)['year'] as String;
            final Map<String, dynamic> movie = _movies[index] as Map<String, dynamic>;

            return ListTile(
              leading: Image.network(movie['medium_cover_image'] as String),
              title: Text('$title $year'),
            );
          }),
    );
  }
}
