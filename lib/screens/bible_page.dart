import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'first_sub_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  _BiblePageState createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  List<String> oldTestamentBooks = [];
  List<String> newTestamentBooks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBibleBooks();
  }

  Future<void> fetchBibleBooks() async {
    try {
      final response1 = await http.get(
          Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_bible?old=true'));
      final response2 = await http.get(
          Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_bible?new=true'));

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final List<dynamic> oldData = json.decode(response1.body);
        final List<dynamic> newData = json.decode(response2.body);
        setState(() {
          oldTestamentBooks =
              oldData.map((book) => book['book_kor'].toString()).toList();
          newTestamentBooks =
              newData.map((book) => book['book_kor'].toString()).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('서버 오류', '성경책 데이터를 가져오는 데 실패했습니다.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('네트워크 오류', '네트워크 연결을 확인해주세요.');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text("성경책"),
                centerTitle: true,
                bottom: TabBar(
                  tabs: [
                    Tab(text: '구약'),
                    Tab(text: '신약'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  BookGridView(books: oldTestamentBooks),
                  BookGridView(books: newTestamentBooks),
                ],
              ),
            ),
          );
  }
}

class BookGridView extends StatelessWidget {
  final List<String> books;

  const BookGridView({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 4 / 4,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FirstSubPage(bookName: books[index], bookId: index + 1),
                ),
              );
            },
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      books[index][0],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      books[index],
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
