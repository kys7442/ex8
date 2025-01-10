import 'package:flutter/material.dart';
import 'home_page.dart';
import 'bible_page.dart';
import 'hymn_page.dart';
import 'community_page.dart';
import '../widgets/main_bottom_navigation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'shopping.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;

  const MainPage({super.key, this.initialIndex = 0});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  late int _selectedIndex;
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    _bannerAd = BannerAd(
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      adUnitId: 'ca-app-pub-3568835154047233~2226160971',
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
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    HomePage(),
    BiblePage(),
    HymnPage(),
    CommunityPage(),
    ShoppingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _pages.map((page) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: page,
                    );
                  }).toList(),
                ),
              ),
              if (_isBannerAdReady)
                SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),
          Positioned(
            top: 40,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                dotenv.env['API_BASE_URL']?.contains('localhost') == true ? 'D' : '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MainPageBottomNavigationBar(
          selectedIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
