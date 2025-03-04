import 'package:flutter/material.dart';
import 'community_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  CommunityPageState createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  List<Map<String, dynamic>> communities = [];
  bool isLoading = true;
  int currentPage = 1;
  final int limit = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchCommunityData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchCommunityData();
    }
  }

  Future<void> fetchCommunityData() async {
    try {
      final response = await http.get(Uri.parse(
          '${dotenv.env['API_BASE_URL']}/api/community?page=$currentPage&limit=$limit'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          communities.addAll(List<Map<String, dynamic>>.from(data['communities']));
          isLoading = false;
          currentPage++;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('서버 오류', '커뮤니티 데이터를 가져오는 데 실패했습니다.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('네트워크 오류', '네트워크 연결을 확인해주세요.');
    }
  }

  Future<void> addCommunity(
      String title, String content, String author, String category) async {
    final url = Uri.parse('${dotenv.env['API_BASE_URL']}/api/community');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'title': title,
      'content': content,
      'author': author,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        final newCommunity = json.decode(response.body);
        setState(() {
          communities.insert(0, newCommunity);
        });
      } else {
        _showErrorDialog('등록 실패', '기도 등록에 실패했습니다.');
      }
    } catch (e) {
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

  String _getMaskedAuthor(String author) {
    List<String> names = author.split(' ');
    if (names.length > 2) {
      // 가운데 이름을 가립니다.
      names[1] = '${names[1][0]}.'; // 예: "John D. Doe"
    }
    return names.join(' ');
  }

  String _formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return '${parsedDate.year}-${parsedDate.month}-${parsedDate.day}';
  }

  void _showAddCommunityDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final authorController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('기도 등록'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: '제목'),
              ),
              TextFormField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: '내용',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: '작성자'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: '카테고리'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('등록'),
              onPressed: () {
                if (titleController.text.isEmpty ||
                    contentController.text.isEmpty ||
                    authorController.text.isEmpty) {
                  _showErrorDialog('입력 오류', '모든 필수 항목을 입력해주세요.');
                } else {
                  addCommunity(
                    titleController.text,
                    contentController.text,
                    authorController.text,
                    categoryController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('중보기도실'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: communities.length,
                    itemBuilder: (context, index) {
                      final community = communities[index];
                      return Column(
                        children: [
                          ListTile(
                            tileColor: index % 2 == 0
                                ? (Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200])
                                : (Theme.of(context).brightness == Brightness.dark ? Colors.grey[700] : Colors.white),
                            title: Text(
                              '${community['title']} (${community['comments_count']})',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              '${_getMaskedAuthor(community['author'])} - ${_formatDate(community['created_at'])}',
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[300] : Colors.black54,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommunityDetailPage(
                                    title: community['title'],
                                    content: community['content'],
                                    author: community['author'],
                                    createdAt: community['created_at'],
                                    communityId: community['id'],
                                  ),
                                ),
                              );
                            },
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCommunityDialog,
        child: Icon(Icons.add),
        tooltip: '기도 등록',
      ),
    );
  }
}
