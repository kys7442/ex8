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
  bool isLoading = false;
  bool hasMoreData = true;
  int currentPage = 1;
  final int limit = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchHymns();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading &&
        hasMoreData) {
      fetchHymns();
    }
  }

  Future<void> fetchHymns() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          '${dotenv.env['API_BASE_URL']}/api/api_hymn?list&page=$currentPage&limit=$limit'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> newHymns =
            List<Map<String, dynamic>>.from(data['hymns']);

        setState(() {
          hymns.addAll(newHymns);
          currentPage++;
          isLoading = false;
          hasMoreData = newHymns.length == limit; // 데이터가 limit보다 적으면 더 이상 데이터가 없음
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('서버 오류', '찬송가 목록을 가져오는 데 실패했습니다.');
      }
    } catch (e) {
      setState(() {
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
        centerTitle: true,
      ),
      body: isLoading && hymns.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: hymns.length,
                    itemBuilder: (context, index) {
                      final hymn = hymns[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text(
                            '${hymn['title']} - ${hymn['category']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            hymn['preview'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.play_circle_fill, color: Colors.red),
                            onPressed: () {
                              _launchURL(hymn['link']);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HymnDetailPage(
                                  hymnId: hymn['id'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }
}
