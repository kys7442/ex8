import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _authorController =
      TextEditingController(); // 작성자 입력 컨트롤러 추가

  @override
  void initState() {
    super.initState();
    fetchComments();
    checkLoginStatus(); // 로그인 상태 확인
  }

  Future<void> fetchComments() async {
    try {
      final response = await http.get(Uri.parse(
          '${dotenv.env['API_BASE_URL']}/api/community_comments?communityId=${widget.communityId}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          comments = List<Map<String, dynamic>>.from(data);
          comments.sort(
              (a, b) => a['created_at'].compareTo(b['created_at'])); // 오름차순 정렬
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
            _buildPostContent(), // 본문 영역
            SizedBox(height: 16),
            _buildCommentsSection(), // 댓글 영역
            SizedBox(height: 16),
            _buildCommentInput(), // 댓글 입력 영역
          ],
        ),
      ),
    );
  }

  Widget _buildPostContent() {
    return Column(
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
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Expanded(
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return ListTile(
            title: Text(comment['content']),
            subtitle: Text('${comment['author']} - ${comment['created_at']}'),
          );
        },
      ),
    );
  }

  Widget _buildCommentInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _authorController,
            decoration: InputDecoration(
              labelText: '작성자 입력',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: '댓글 입력',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            postComment(_commentController.text, _authorController.text);
            _commentController.clear();
            _authorController.clear();
          },
          child: Text('등록'),
        ),
      ],
    );
  }

  Future<void> postComment(String content, String author) async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['API_BASE_URL']}/api/community_comments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'communityId': widget.communityId.toString(),
          'author': author, // 입력된 작성자 이름 사용
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        fetchComments(); // 댓글 목록 갱신
      } else {
        // 에러 처리
      }
    } catch (e) {
      // 에러 처리
    }
  }
}
