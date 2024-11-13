import 'package:flutter/material.dart';

void main() {
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
          child: Image.asset('assets/images/onechapteraday.png', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
        ),
      ),
    );
  }
}

// MainPage
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    BiblePage(),
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
                Scaffold.of(context).openDrawer(); // Builder를 통해 올바른 context를 가져옴
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
class BiblePage extends StatefulWidget {
  @override
  _BiblePageState createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bible'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Old Testament'),
            Tab(text: 'New Testament'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BibleFirstDepthPage(isOldTestament: true),
          BibleFirstDepthPage(isOldTestament: false),
        ],
      ),
    );
  }
}

// BibleFirstDepthPage
class BibleFirstDepthPage extends StatelessWidget {
  final bool isOldTestament;

  BibleFirstDepthPage({required this.isOldTestament});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: 39,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BibleSecondDepthPage(title: 'Chapter $index'),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text('Book $index'),
              ),
            ),
          );
        },
      ),
    );
  }
}

// BibleSecondDepthPage
class BibleSecondDepthPage extends StatelessWidget {
  final String title;

  BibleSecondDepthPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Chapter $index'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BibleThirdDepthPage(title: 'Chapter $index'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// BibleThirdDepthPage
class BibleThirdDepthPage extends StatelessWidget {
  final String title;

  BibleThirdDepthPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('$title, Verse $index: Content of the verse...'),
          );
        },
      ),
    );
  }
}

// Example placeholders for other pages
class HymnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hymns')),
      body: Center(child: Text('Hymn Page Content')),
    );
  }
}

// CommunityPage
class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Community Post 1'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityDetailPage(title: 'Community Post 1')));
            },
          ),
          ListTile(
            title: Text('Community Post 2'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityDetailPage(title: 'Community Post 2')));
            },
          ),
          ListTile(
            title: Text('Community Post 3'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityDetailPage(title: 'Community Post 3')));
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
