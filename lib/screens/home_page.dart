import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'etc1_page.dart';
import 'etc2_page.dart';
import 'etc3_page.dart';
import 'settings_page.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'community_detail_page.dart';
import 'sign_up_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool isLoggedIn = false; // 로그인 여부를 저장하는 변수
  List<Map<String, dynamic>> wordcards = []; // 말씀 데이터를 저장할 리스트
  bool isLoading = true; // 로딩 상태를 나타내는 변수
  Map<String, dynamic> data = {}; // 데이터를 저장할 변수 추가

  void _logout() {
    setState(() {
      isLoggedIn = false; // 로그아웃 처리
    });
  }

  @override
  void initState() {
    super.initState();
    fetchHomeData(); // 새로운 데이터 가져오는 함수 호출
  }

  Future<void> fetchHomeData() async {
    try {
      final response = await http
          .get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/getHomeData'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> fetchedData = json.decode(response.body);
        setState(() {
          wordcards = [fetchedData['recommendedWordcard']];
          data = fetchedData; // 데이터를 상태로 저장
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('1일1장',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, size: 28),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info, size: 28),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => SettingsPage(),
              );
            },
          ),
          if (isLoggedIn)
            IconButton(
              icon: Icon(Icons.logout, size: 28),
              onPressed: _logout,
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, size: 24),
              title: Text('프로필', style: TextStyle(fontSize: 16)),
              onTap: () {
                if (isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(
                              onLoginSuccess: () {
                                setState(() {
                                  isLoggedIn = true;
                                });
                              },
                            )),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(isLoggedIn ? Icons.logout : Icons.login, size: 24),
              title: Text(isLoggedIn ? '로그아웃' : '로그인',
                  style: TextStyle(fontSize: 16)),
              onTap: () {
                if (isLoggedIn) {
                  _logout();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(
                              onLoginSuccess: () {
                                setState(() {
                                  isLoggedIn = true;
                                });
                              },
                            )),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.app_registration, size: 24),
              title: Text('회원가입', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.menu_book),
              title: Text('말씀카드'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Etc1Page()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.menu),
              title: Text('많이본성경'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Etc2Page()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.menu),
              title: Text('후원보기'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Etc3Page()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Container(
                    height: 100,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                        child:
                            Text('배너 광고 영역', style: TextStyle(fontSize: 14))),
                  ),
                  SizedBox(height: 24),
                  Text('오늘 추천 말씀카드',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (isLoading)
                    Center(child: CircularProgressIndicator())
                  else
                    ListTile(
                      dense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                      title: Text(
                        '${wordcards[0]['verse']} ${wordcards[0]['book']} ${wordcards[0]['schapter']}:${wordcards[0]['spage']} ~ ${wordcards[0]['echapter']}:${wordcards[0]['epage']}',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  SizedBox(height: 24),
                  Text('오늘 추천 찬송가',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (data.isNotEmpty)
                    ListTile(
                      dense: true,
                      title: Text(
                        data['recommendedHymn']['title'],
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  SizedBox(height: 32),
                  Text('많이 본 말씀',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (data.isNotEmpty)
                    ListTile(
                      dense: true,
                      title: Text(
                        data['mostViewedBible']['contents'],
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  SizedBox(height: 32),
                  Text('기도실(중보)',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (data.isNotEmpty)
                    ...data['recentCommunities'].map((community) {
                      String maskedAuthor = community['author'].replaceRange(
                          1,
                          community['author'].length - 1,
                          '*' * (community['author'].length - 2));
                      return ListTile(
                        dense: true,
                        title: Text(
                          community['title'],
                          style: TextStyle(fontSize: 11),
                        ),
                        subtitle: Text(
                          '등록자: $maskedAuthor\n등록일자: ${community['created_at']}\n댓글수: ${community['comments_count']}',
                          style: TextStyle(fontSize: 11),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommunityDetailPage(
                                communityId: community['id'],
                                title: community['title'],
                                content: community['content'],
                                author: community['author'],
                                createdAt:
                                    DateTime.parse(community['created_at'])
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
