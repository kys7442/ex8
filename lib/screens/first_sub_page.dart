import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'first_sub2_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirstSubPage extends StatefulWidget {
  final String bookName;
  final int bookId;

  const FirstSubPage({super.key, required this.bookName, required this.bookId});

  @override
  _FirstSubPageState createState() => _FirstSubPageState();
}

class _FirstSubPageState extends State<FirstSubPage> {
  List<Map<String, dynamic>> chapters = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchChapters();
  }

  Future<void> fetchChapters() async {
    try {
      final response = await http.get(Uri.parse(
          '${dotenv.env['API_BASE_URL']}/api/api_bible?book_no=${widget.bookId}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          chapters = data
              .map((chapter) => {
            'idx': chapter['idx'],
            'lang': chapter['lang'],
            'book_no': chapter['book_no'],
            'book_kor': chapter['book_kor'],
            'book_eng': chapter['book_eng'],
            'chapter': chapter['chapter'].toString(),
            'page': chapter['page'].toString(),
            'contents': chapter['contents'] ?? '내용 없음',
          })
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = '데이터를 가져오는 데 실패했습니다.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '에러가 발생했습니다: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.bookName),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : GridView.builder(
        padding: EdgeInsets.all(3.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          crossAxisCount: 3,
          childAspectRatio: 2 / 1,
        ),
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapter = chapters[index];
          return Card(
            elevation: 2,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FirstSub2Page(
                      bookName: widget.bookName,
                      bookId: widget.bookId,
                      chapterId: int.parse(chapter['chapter']),
                    ),
                  ),
                );
              },
              child: Center(
                child: Text(
                  '${chapter['chapter']}장',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}