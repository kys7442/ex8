import 'package:flutter/material.dart';

class ShoppingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('쇼핑몰'),
      ),
      body: Center(
        child: Text(
          '준비중',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
