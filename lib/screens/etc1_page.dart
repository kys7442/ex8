import 'package:flutter/material.dart';

class Etc1Page extends StatelessWidget {
  const Etc1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메뉴1')),
      body: Center(
        child: Text('메뉴1 페이지 내용'),
      ),
    );
  }
}
