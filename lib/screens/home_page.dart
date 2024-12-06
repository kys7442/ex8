import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'etc1_page.dart';
import 'etc2_page.dart';
import 'etc3_page.dart';
import 'settings_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false; // 로그인 여부를 저장하는 변수

  void _logout() {
    setState(() {
      isLoggedIn = false; // 로그아웃 처리
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
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
          if (isLoggedIn) // 로그인 된 경우에만 로그아웃 버튼 표시
            IconButton(
              icon: Icon(Icons.logout),
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
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('프로필'),
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
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                // 배너 광고 박스
                Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: Center(child: Text('배너 광고 영역')),
                ),
                SizedBox(height: 32),

                // 최근 등록된 찬송가
                Text('최근 등록된 찬송가',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...List.generate(
                  5,
                  (index) => ListTile(
                    dense: true,
                    title: Text(
                      '찬송가 제목 ${index + 1}',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // 최근 추가된 말씀
                Text('최근 추가된 말씀',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...List.generate(
                  5,
                  (index) => ListTile(
                    dense: true,
                    title: Text(
                      '말씀 제목 ${index + 1}',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // 핫 클릭 말씀
                Text('핫 클릭 말씀',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...List.generate(
                  5,
                  (index) => ListTile(
                    dense: true,
                    title: Text(
                      '핫 클릭 말씀 제목 ${index + 1}',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // 자주보는 성경구절
                Text('자주보는 성경구절',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...List.generate(
                  5,
                  (index) => ListTile(
                    dense: true,
                    title: Text(
                      '성경구절 제목 ${index + 1}',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
