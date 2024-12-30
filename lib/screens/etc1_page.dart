import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Etc1Page extends StatelessWidget {
  const Etc1Page({super.key});

  Future<List<Map<String, dynamic>>> fetchWordcards(
      BuildContext context) async {
    try {
      final response = await http
          .get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_wordcards'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['wordcards']);
      } else {
        _showErrorDialog(context, '서버 오류', '말씀카드 데이터를 가져오는 데 실패했습니다.');
        return [];
      }
    } catch (e) {
      _showErrorDialog(context, '네트워크 오류', '네트워크 연결을 확인해주세요.');
      return [];
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
      appBar: AppBar(title: Text('Etc1 Page')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchWordcards(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            final wordcards = snapshot.data!;
            return ListView.builder(
              itemCount: wordcards.length,
              itemBuilder: (context, index) {
                final wordcard = wordcards[index];
                return ListTile(
                  title: Text(wordcard['title']),
                  subtitle: Text(wordcard['description']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
