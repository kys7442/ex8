import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'hymn_detail_page.dart';

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
      final response = await http
          .get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_hymn?list'));
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
        _showErrorDialog('서버 오류', '찬송가 목록을 가져오는 데 실패했습니다.');
      }
    } catch (e) {
      setState(() {
        errorMessage = '에러가 발생했습니다: $e';
        isLoading = false;
      });
      _showErrorDialog('네트워크 오류', '네트워크 연결을 확인해주세요.');
    }
  }

  void _showErrorDialog(String title, String message) {
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url); // String을 Uri로 변환
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // launch 대신 launchUrl 사용
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
                      title: Text('${hymn['title']} - ${hymn['category']}'),
                      subtitle: Text(
                        hymn['preview'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.link),
                        onPressed: () {
                          _launchURL(hymn['link']);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HymnDetailPage(
                              hymnId: hymn['id'], // 찬송가 ID 전달
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
