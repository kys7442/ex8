import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HymnDetailPage extends StatelessWidget {
  final int hymnId;

  const HymnDetailPage({super.key, required this.hymnId});

  Future<Map<String, dynamic>> fetchHymnDetails() async {
    final response = await http.get(
        Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_hymn?id=$hymnId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load hymn details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('찬송가 상세')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchHymnDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            final hymn = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hymn['title'],
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(hymn['preview']),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
