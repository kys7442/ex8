import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'first_sub2_page.dart';

class Etc2Page extends StatefulWidget {
  const Etc2Page({super.key});

  @override
  Etc2PageState createState() => Etc2PageState();
}

class Etc2PageState extends State<Etc2Page> {
  List<dynamic> bibleMaxViews = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchBibleMaxViews();
  }

  Future<void> _fetchBibleMaxViews() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_BASE_URL']}/api/bibleMaxViews'),
      );

      if (response.statusCode == 200) {
        setState(() {
          bibleMaxViews = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('많이 본 성경'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text('데이터를 가져오는 데 실패했습니다.'))
              : ListView.builder(
                  itemCount: bibleMaxViews.length,
                  itemBuilder: (context, index) {
                    final item = bibleMaxViews[index];
                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text('${item['book_kor']} ${item['chapter']}장'),
                        trailing: Text('Views: ${item['views']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FirstSub2Page(
                                bookName: item['book_kor'],
                                bookId: item['book_no'],
                                chapterId: item['chapter'],
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
