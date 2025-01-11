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
  List<bool> _isExpandedList = [];

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
          _isExpandedList = List<bool>.filled(comments.length, false);
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
            Expanded(child: _buildCommentsSection()),
            SizedBox(height: 16),
            _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostContent() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 8),
          Text(
            '작성자 : ${widget.author}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
          SizedBox(height: 4),
          Text(
            '등록일 : ${widget.createdAt}',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          Divider(height: 20, thickness: 1, color: Colors.grey[300]),
          Text(
            '내용 :',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 8),
          Text(
            widget.content,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
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
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        final DateTime createdAt = DateTime.parse(comment['created_at']);
        final String formattedDate =
            '${createdAt.year}-${createdAt.month}-${createdAt.day}';
        final String authorName = comment['author'];
        final bool isExpanded = _isExpandedList[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authorName,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  isExpanded ? comment['content'] : comment['content'].substring(0, 50) + '...',
                  style: TextStyle(fontSize: 16),
                  overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                if (comment['content'].length > 50)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpandedList[index] = !isExpanded;
                        });
                      },
                      child: Text(isExpanded ? '자세히 닫기' : '자세히 보기'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
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
