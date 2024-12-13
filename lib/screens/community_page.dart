import 'package:flutter/material.dart';
import 'community_detail_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('중보기도실')),
      body: ListView.builder(
        itemCount: 10, // 예시 데이터 수
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('중보기도 $index 번째'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CommunityDetailPage(title: '중보기도문 $index')),
              );
            },
          );
        },
      ),
    );
  }
}
