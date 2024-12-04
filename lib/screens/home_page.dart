import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'etc1_page.dart';
import 'etc2_page.dart';
import 'etc3_page.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('1일1장'),
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
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // 배너 광고 박스
          Container(
            height: 100,
            color: Colors.grey[300],
            child: Center(child: Text('배너 광고')),
          ),
          SizedBox(height: 32),

          // 최근 등록된 찬송가
          Text('최근 등록된 찬송가',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    );
  }
}