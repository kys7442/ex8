import 'package:flutter/material.dart';

class CommunityDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final String author;
  final String createdAt;

  const CommunityDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('작성자: $author', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('작성일: $createdAt', style: TextStyle(fontSize: 14)),
            SizedBox(height: 16),
            Text(content, style: TextStyle(fontSize: 14)),
            // 댓글 기능 추가 가능
          ],
        ),
      ),
    );
  }
}
