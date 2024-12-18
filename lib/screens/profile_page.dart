import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필')),
      body: Center(
        child: Text('프로필 페이지 내용'),
      ),
    );
  }
}
