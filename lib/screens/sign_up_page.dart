import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Center(
        child: Text('회원가입 페이지'),
      ),
    );
  }
}
