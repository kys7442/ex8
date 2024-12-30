import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HymnDetailPage extends StatelessWidget {
  final int hymnId;

  const HymnDetailPage({super.key, required this.hymnId});

  Future<Map<String, dynamic>> fetchHymnDetails(BuildContext context) async {
    try {
      final response = await http.get(
          Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_hymn?id=$hymnId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        _showErrorDialog(context, '서버 오류', '찬송가 데이터를 가져오는 데 실패했습니다.');
        throw Exception('Failed to load hymn details');
      }
    } catch (e) {
      _showErrorDialog(context, '네트워크 오류', '네트워크 연결을 확인해주세요.');
      throw Exception('Failed to load hymn details: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('찬송가 상세')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchHymnDetails(context),
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
