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
  bool isLoggedIn = false;
  String? loggedInUserId;
  String? loggedInUsername;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchComments();
    checkLoginStatus();
  }

  Future<void> fetchComments() async {
    try {
      final response = await http.get(Uri.parse(
          '${dotenv.env['API_BASE_URL']}/api/community_comments?communityId=${widget.communityId}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          comments = List<Map<String, dynamic>>.from(data);
          comments.sort((a, b) => a['created_at'].compareTo(b['created_at']));
        });
      }
    } catch (e) {
      // 에러 처리
    }
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getString('authToken') != null &&
          prefs.getInt('userId') != null &&
          prefs.getString('username') != null;
      loggedInUserId = prefs.getInt('userId')?.toString();
      loggedInUsername = prefs.getString('username');
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
            _buildPostContent(),
            SizedBox(height: 16),
            _buildLoginStatus(),
            SizedBox(height: 16),
            _buildCommentsSection(),
            SizedBox(height: 16),
            _buildCommentInput(),
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

  Widget _buildLoginStatus() {
    return Text(
      isLoggedIn
          ? '로그인 상태: ${loggedInUsername ?? '알 수 없음'}'
          : '로그인되지 않음. 로그인 후 댓글을 작성할 수 있습니다.',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCommentsSection() {
    return Expanded(
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          final DateTime createdAt = DateTime.parse(comment['created_at']);
          final String formattedDate =
              '${createdAt.year}-${createdAt.month}-${createdAt.day}';
          final String authorName = comment['author'];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        comment['content'],
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      authorName,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentInput() {
    if (!isLoggedIn) {
      return Text('로그인 후 댓글을 작성할 수 있습니다.');
    }

    return Row(
      children: [
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
            if (loggedInUserId != null && loggedInUsername != null) {
              postComment(_commentController.text, loggedInUsername!);
              _commentController.clear();
            }
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
          'author': author,
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        fetchComments();
      } else {
        // 에러 처리
      }
    } catch (e) {
      // 에러 처리
    }
  }
}
