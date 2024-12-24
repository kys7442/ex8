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
  FirstSub2PageState createState() => FirstSub2PageState();
}

class FirstSub2PageState extends State<FirstSub2Page> {
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
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF5F5DC), // 베이지 색상 배경
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    itemCount: chapters.length,
                    itemBuilder: (context, index) {
                      //final chapter = chapters[index]['chapter'];
                      final page = chapters[index]['page'];
                      final contents = chapters[index]['contents'] ?? '내용 없음';

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 8.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$page절 ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown, // 텍스트 색상
                                ),
                              ),
                              TextSpan(
                                text: contents,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87, // 텍스트 색상
                                ),
                              ),
                            ],
                          ),
                          style: TextStyle(
                            fontSize: 16.0,
                            height: 1, // 줄 간격 조정
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
