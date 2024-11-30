import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the package
import 'package:url_launcher/url_launcher.dart'; // Add this import

Future<void> main() async {
  // 환경 변수를 통해 환경을 결정
  const String env = String.fromEnvironment('ENV', defaultValue: 'development');
  await dotenv.load(fileName: 'assets/.env.$env'); // assets 폴더에서 파일 로드
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Bible App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[850], // 하단 메뉴 바의 배경색을 그레이로 설정
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: SplashScreen(),
    );
  }
}

// SplashScreen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlueAccent,
        child: Center(
          child: Image.asset('assets/images/onechapteraday.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
        ),
      ),
    );
  }
}

// MainPage
class MainPage extends StatefulWidget {
  final int initialIndex;

  MainPage({this.initialIndex = 0});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // 초기화 시 전달된 인덱스를 사용
  }

  final List<Widget> _pages = [
    HomePage(),
    FirstPage(), // 성경책 페이지 (구약, 신약)
    HymnPage(),
    CommunityPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '성경책',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: '찬송가',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '커뮤니티',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

// HomePage remains the same
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Builder를 통해 올바른 context를 가져옴
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => SettingsPage(),
              );
            },
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
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('프로필'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.menu_book),
              title: Text('메뉴1'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Etc1Page()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.menu),
              title: Text('메뉴2'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Etc2Page()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.menu),
              title: Text('메뉴3'),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Recent News',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Latest Bible News Item 1'),
                ),
                ListTile(
                  title: Text('Frequent Verses'),
                ),
                ListTile(
                  title: Text('Popular YouTube Videos'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ProfilePage (프로필 페이지)
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필')),
      body: Center(
        child: Text('프로필 페이지 내용'),
      ),
    );
  }
}

// Etc1Page (메뉴1에 대한 페이지)
class Etc1Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메뉴1')),
      body: Center(
        child: Text('메뉴1 페이지 내용'),
      ),
    );
  }
}

// Etc2Page (메뉴2에 대한 페이지)
class Etc2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메뉴2')),
      body: Center(
        child: Text('메뉴2 페이지 내용'),
      ),
    );
  }
}

// Etc3Page (메뉴3에 대한 페이지)
class Etc3Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메뉴3')),
      body: Center(
        child: Text('메뉴3 페이지 내용'),
      ),
    );
  }
}

// BiblePage with Tabs
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<String> oldTestamentBooks = [];
  List<String> newTestamentBooks = [];

  @override
  void initState() {
    super.initState();
    fetchBibleBooks();
  }

  Future<void> fetchBibleBooks() async {
    final response1 = await http
        .get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_bible?old=true'));
    final response2 = await http
        .get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_bible?new=true'));

    if (response1.statusCode == 200) {
      final List<dynamic> data = json.decode(response1.body);
      setState(() {
        oldTestamentBooks =
            data.map((book) => book['book_kor'].toString()).toList();
      });
    }

    if (response2.statusCode == 200) {
      final List<dynamic> data = json.decode(response2.body);
      setState(() {
        newTestamentBooks =
            data.map((book) => book['book_kor'].toString()).toList();
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // 이전 페이지가 있을 때는 정상적인 pop 작동
    } else {
      // 이전 페이지가 없을 때는 HomePage로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    return false; // 기본 뒤로 가기 동작 취소
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("성경"),
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
      ),
    );
  }
}

class BookGridView extends StatelessWidget {
  final List<String> books;

  BookGridView({required this.books});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2 / 1,
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
              child: Center(
                child: Text(
                  books[index],
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FirstSubPage extends StatefulWidget {
  final String bookName;
  final int bookId;

  FirstSubPage({required this.bookName, required this.bookId});

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
        title: Text('${widget.bookName}'),
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
      bottomNavigationBar:
          MainPageBottomNavigationBar(selectedIndex: 1), // 성경책 탭이 선택된 상태로 설정
    );
  }
}

class FirstSub2Page extends StatefulWidget {
  final String bookName;
  final int bookId;
  final int chapterId;

  FirstSub2Page(
      {required this.bookName, required this.bookId, required this.chapterId});

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
      bottomNavigationBar:
          MainPageBottomNavigationBar(selectedIndex: 1), // 성경책 탭이 선택된 상태로 설정
    );
  }
}

// HymnPage
class HymnPage extends StatefulWidget {
  @override
  _HymnPageState createState() => _HymnPageState();
}

class _HymnPageState extends State<HymnPage> {
  List<Map<String, dynamic>> hymns = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchHymns();
  }

  Future<void> fetchHymns() async {
    try {
      final response = await http
          .get(Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_hymn?list'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          hymns = List<Map<String, dynamic>>.from(data['hymns']);
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
      appBar: AppBar(title: Text('찬송가')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // 한 줄에 5개의 카드
                    childAspectRatio: 2 / 1, // 카드의 가로 세로 비율
                  ),
                  itemCount: hymns.length,
                  itemBuilder: (context, index) {
                    final hymn = hymns[index];
                    return Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HymnDetailPage(hymnId: hymn['id']),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            hymn['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

// HymnDetailPage
class HymnDetailPage extends StatelessWidget {
  final int hymnId;

  HymnDetailPage({required this.hymnId});

  Future<Map<String, dynamic>> fetchHymnDetails() async {
    final response = await http.get(
        Uri.parse('${dotenv.env['API_BASE_URL']}/api/api_hymn?id=$hymnId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load hymn details');
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hymn Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchHymnDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            final hymn = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hymn['title'],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(hymn['preview']),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _launchURL(hymn['link']),
                    child: Text(
                      'Play on YouTube',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Source: ${hymn['source']}'),
                  // Add more details as needed
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: MainPageBottomNavigationBar(selectedIndex: 2),
    );
  }
}

// CommunityPage
class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('커뮤니티'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Community Post 1'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CommunityDetailPage(title: 'Community Post 1')));
            },
          ),
          ListTile(
            title: Text('Community Post 2'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CommunityDetailPage(title: 'Community Post 2')));
            },
          ),
          ListTile(
            title: Text('Community Post 3'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CommunityDetailPage(title: 'Community Post 3')));
            },
          ),
        ],
      ),
    );
  }
}

// CommunityDetailPage
class CommunityDetailPage extends StatelessWidget {
  final String title;

  CommunityDetailPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('$title - Detailed content here'),
      ),
    );
  }
}

// SettingsPage
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Text('Settings Page - 추후 구현 예정'),
      ),
    );
  }
}

// 공통적으로 사용할 하단 바 위젯
class MainPageBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  MainPageBottomNavigationBar({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: '성경책',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.music_note),
          label: '찬송가',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: '커뮤니티',
        ),
      ],
      currentIndex: selectedIndex, // 선택된 인덱스를 전달받아 설정
      selectedItemColor: Colors.blue,
      onTap: (index) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainPage(initialIndex: index)), // 선택한 인덱스를 MainPage로 전달
          (route) => false,
        );
      },
    );
  }
}
