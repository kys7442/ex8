import 'package:flutter/material.dart';

class CommunityDetailPage extends StatelessWidget {
  final String title;

  const CommunityDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title의 상세 내용'),
      ),
    );
  }
}
