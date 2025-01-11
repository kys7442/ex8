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
import 'package:shared_preferences/shared_preferences.dart';
import 'hymn_detail_page.dart';
import 'first_sub2_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  String? loggedInUsername;
  List<Map<String, dynamic>> wordcards = []; // 말씀 데이터를 저장할 리스트
  bool isLoading = true; // 로딩 상태를 나타내는 변수
  Map<String, dynamic> data = {}; // 데이터를 저장할 변수 추가
  String authToken = ''; // 인증 토큰을 저장할 변수 추가
  bool hasError = false; // 오류 상태를 저장하는 변수 추가

  BannerAd? _bannerAd;
  bool _isBannerAdReady = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchHomeData(); // 새로운 데이터 가져오는 함수 호출
    _loadBannerAd(); // 배너 광고 로드
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getString('authToken') != null &&
          prefs.getInt('userId') != null &&
          prefs.getString('username') != null;
      loggedInUsername = prefs.getString('username');
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userId');
    await prefs.remove('username');

    setState(() {
      isLoggedIn = false;
      loggedInUsername = null;
    });
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'YOUR_AD_UNIT_ID', // 실제 광고 단위 ID로 변경
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() {
            _isBannerAdReady = false;
          });
        },
      ),
    )..load();
  }

  Future<void> fetchHomeData() async {
    try {
      final response = await http
          .get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/getHomeData'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> fetchedData = json.decode(response.body);
        setState(() {
          wordcards = [fetchedData['recommendedWordcard']];
          data = fetchedData;
          isLoading = false;
          hasError = false; // 오류 상태 초기화
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true; // 오류 상태 설정
        });
        _showErrorDialog('서버 오류', '데이터를 가져오는 데 실패했습니다.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true; // 오류 상태 설정
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
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('1일1장'),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, size: 28),
              onPressed: hasError
                  ? null
                  : () {
                      // 오류가 있을 때 비활성화
                      Scaffold.of(context).openDrawer();
                    },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info, size: 28),
            onPressed: hasError
                ? null
                : () {
                    // 오류가 있을 때 비활성화
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SettingsPage(),
                    );
                  },
          ),
          if (isLoggedIn)
            IconButton(
              icon: Icon(Icons.logout, size: 28),
              onPressed: hasError ? null : _logout, // 오류가 있을 때 비활성화
            ),
        ],
      ),
      drawer: hasError
          ? null
          : Drawer(
              // 오류가 있을 때 Drawer 비활성화
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
                  if (isLoggedIn)
                    Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 4.0,
                      child: ListTile(
                        leading: Icon(Icons.person, size: 24),
                        title: Text('프로필', style: TextStyle(fontSize: 16)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
                          );
                        },
                      ),
                    ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    child: ListTile(
                      leading: Icon(isLoggedIn ? Icons.logout : Icons.login,
                          size: 24),
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
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  if (!isLoggedIn)
                    Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 4.0,
                      child: ListTile(
                        leading: Icon(Icons.app_registration, size: 24),
                        title: Text('회원가입', style: TextStyle(fontSize: 16)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()),
                          );
                        },
                      ),
                    ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    child: ListTile(
                      leading: Icon(Icons.menu_book),
                      title: Text('말씀카드'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Etc1Page()),
                        );
                      },
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    child: ListTile(
                      leading: Icon(Icons.menu),
                      title: Text('많이본성경'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Etc2Page(),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    child: ListTile(
                      leading: Icon(Icons.menu),
                      title: Text('후원보기'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Etc3Page()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      body: hasError
          ? Center(child: Text('네트워크 오류가 발생했습니다.'))
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  if (_isBannerAdReady)
                    SizedBox(
                      height: _bannerAd!.size.height.toDouble(),
                      width: _bannerAd!.size.width.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
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
                              child: Text('배너 광고 영역',
                                  style: TextStyle(fontSize: 16))),
                        ),
                        SizedBox(height: 24),
                        Text('추천 말씀카드',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        if (isLoading)
                          Center(child: CircularProgressIndicator())
                        else
                          Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            elevation: 4.0,
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wordcards[0]['verse'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    '${wordcards[0]['book']} ${wordcards[0]['schapter']}:${wordcards[0]['spage']} ~ ${wordcards[0]['echapter']}:${wordcards[0]['epage']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 24),
                        Text('추천 찬송가',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        if (data.isNotEmpty)
                          Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            elevation: 4.0,
                            child: ListTile(
                              dense: true,
                              title: Text(
                                data['recommendedHymn']['title'],
                                style: TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HymnDetailPage(
                                      hymnId: data['recommendedHymn']['id'],
                                      youtubeUrl: data['link'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 32),
                        Text('많이 본 말씀',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        if (data.isNotEmpty)
                          Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            elevation: 4.0,
                            child: ListTile(
                              dense: true,
                              title: Text(
                                data['mostViewedBible']['contents'],
                                style: TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FirstSub2Page(
                                      bookName: data['mostViewedBible']
                                          ['book_kor'],
                                      bookId: data['mostViewedBible']
                                          ['book_no'],
                                      chapterId: data['mostViewedBible']
                                          ['chapter'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 32),
                        Text('기도실(중보)',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        if (data.isNotEmpty)
                          ...data['recentCommunities'].map((community) {
                            String maskedAuthor = community['author']
                                .replaceRange(1, community['author'].length - 1,
                                    '*' * (community['author'].length - 2));
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 18.0),
                              elevation: 4.0,
                              child: ListTile(
                                dense: true,
                                title: Text(
                                  community['title'],
                                  style: TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  '등록자: $maskedAuthor\n등록일자: ${community['created_at']}\n댓글수: ${community['comments_count']}',
                                  style: TextStyle(fontSize: 14),
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
                                        createdAt: DateTime.parse(
                                                community['created_at'])
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0],
                                      ),
                                    ),
                                  );
                                },
                              ),
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
