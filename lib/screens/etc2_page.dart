import 'package:flutter/material.dart';
import 'first_sub2_page.dart';

class Etc2Page extends StatelessWidget {
  final List<Map<String, dynamic>> mostViewedBible;

  const Etc2Page({super.key, required this.mostViewedBible});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('많이 본 말씀')),
      body: ListView.builder(
        itemCount: mostViewedBible.length,
        itemBuilder: (context, index) {
          final bible = mostViewedBible[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              dense: true,
              title: Text(
                bible['contents'],
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FirstSub2Page(
                      bookName: bible['book_kor'],
                      bookId: bible['book_no'],
                      chapterId: bible['chapter'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
