import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityDetailPage extends StatefulWidget {
  final int communityId;
  final String title;
  final String content;
  final String author;
  final String createdAt;

  const CommunityDetailPage({
    super.key,
    required this.communityId,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  @override
  CommunityDetailPageState createState() => CommunityDetailPageState();
}

class CommunityDetailPageState extends State<CommunityDetailPage> {
  List<Map<String, dynamic>> comments = [];
  bool isLoggedIn = false; // 로그인 여부를 확인하는 변수

  @override
  void initState() {
    super.initState();
    fetchComments();
    checkLoginStatus(); // 로그인 상태 확인
  }

  Future<void> fetchComments() async {
    try {
      final response = await http.get(Uri.parse(
          'https://example.com/api/community_comments?communityId=${widget.communityId}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          comments = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      // 에러 처리
    }
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getString('authToken') != null; // 토큰이 존재하면 로그인 상태로 간주
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('기도실(중보)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Community ID: ${widget.communityId}'),
            SizedBox(height: 16),
            Text('Author: ${widget.author}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Created At: ${widget.createdAt}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Content:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(widget.content),
            SizedBox(height: 16),
            if (isLoggedIn) ...[
              TextField(
                decoration: InputDecoration(
                  labelText: '댓글 입력',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  // 댓글 제출 로직 추가
                },
              ),
              SizedBox(height: 16),
            ] else ...[
              Text(
                '로그인 하시면 댓글을 달 수 있습니다.',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    title: Text(comment['content']),
                    subtitle:
                        Text('${comment['author']} - ${comment['created_at']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
