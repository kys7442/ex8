import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Etc1Page extends StatelessWidget {
  const Etc1Page({super.key});

  Future<List<Map<String, dynamic>>> fetchWordcards() async {
    final response = await http
        .get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_wordcards'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['wordcards']);
    } else {
      throw Exception('Failed to load wordcards');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메뉴1')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchWordcards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No wordcards available'));
          } else {
            final wordcards = snapshot.data!;
            return ListView.builder(
              itemCount: wordcards.length,
              itemBuilder: (context, index) {
                final wordcard = wordcards[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(
                      '${wordcard['verse']} ${wordcard['book']} ${wordcard['schapter']}:${wordcard['spage']} ~ ${wordcard['echapter']}:${wordcard['epage']}',
                      style: TextStyle(fontSize: 16),
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
