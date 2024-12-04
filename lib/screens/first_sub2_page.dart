import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirstSub2Page extends StatefulWidget {
  final String bookName;
  final int bookId;
  final int chapterId;

  const FirstSub2Page(
      {super.key,
        required this.bookName,
        required this.bookId,
        required this.chapterId});

  @override
  _FirstSub2PageState createState() => _FirstSub2PageState();
}

class _FirstSub2PageState extends State<FirstSub2Page> {
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
          '${dotenv.env['API_BASE_URL']}/api/api_bible?N=${widget.bookId}&C=${widget.chapterId}'));
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
        title: Text('${widget.bookName} ${widget.chapterId}장'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        padding: EdgeInsets.symmetric(
            vertical: 4.0), // Reduce vertical padding
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapter = chapters[index]['chapter'];
          final page = chapters[index]['page'];
          final contents = chapters[index]['contents'] ?? '내용 없음';

          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: 2.0, horizontal: 8.0), // Adjust spacing
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$chapter장 $page절 ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: contents,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              style: TextStyle(
                  fontSize: 15.0,
                  height: 1.3), // Adjust font size and line height
            ),
          );
        },
      ),
    );
  }
}