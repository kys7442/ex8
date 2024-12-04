import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'hymn_detail_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class HymnPage extends StatefulWidget {
  const HymnPage({super.key});

  @override
  _HymnPageState createState() => _HymnPageState();
}

class _HymnPageState extends State<HymnPage> {
  List<Map<String, dynamic>> hymns = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchHymns();
  }

  Future<void> fetchHymns() async {
    try {
      final response = await http.get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_hymn?list'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          hymns = List<Map<String, dynamic>>.from(data['hymns']);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = '데이터를 가져오는 데 실패했습니다.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '에러가 발생했습니다: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('찬송가'),
        centerTitle: true, // 제목을 중앙에 배치
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: hymns.length,
        itemBuilder: (context, index) {
          final hymn = hymns[index];
          return ListTile(
            title: Text(hymn['title']),
            subtitle: Text(hymn['category']), // 추가된 부분: category 출력
            trailing: Icon(Icons.link),
            onTap: () {
              _launchURL(hymn['link']);
            },
          );
        },
      ),
    );
  }
}