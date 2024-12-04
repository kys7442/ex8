import 'package:flutter/material.dart';
import 'community_detail_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('커뮤니티')),
      body: ListView.builder(
        itemCount: 10, // 예시 데이터 수
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('커뮤니티 글 $index'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CommunityDetailPage(title: '커뮤니티 글 $index')),
              );
            },
          );
        },
      ),
    );
  }
}
