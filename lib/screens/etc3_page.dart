import 'package:flutter/material.dart';

class Etc3Page extends StatelessWidget {
  const Etc3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('후원보기')),
      body: Center(
        child: Text(
          '후원 업체를 받고 있습니다.\n'
          '후원 업체로 인해 얻어진 모든 수익은\n'
          '하나님의 사랑을 흘려 보내는 용도로\n'
          '사용하겠습니다.\n\n'
          '후원문의 : kys7442@naver.com',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
