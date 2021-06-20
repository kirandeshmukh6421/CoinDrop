import 'package:coindrop/models/app_user.dart';
import 'package:coindrop/services/database/auth.dart';
import 'package:coindrop/tabs/nested_tabs/news_tab.dart';
import 'package:provider/provider.dart';

import '../shared/constants.dart';
import 'package:flutter/material.dart';

import 'nested_tabs/markets_tab.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: BottomNavBar()));
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final AuthService _auth = AuthService();

  int currentPage = 1;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
          backgroundColor: kDarkGrey,
          icon: Icon(Icons.star),
          label: 'Watchlist'),
      BottomNavigationBarItem(
          backgroundColor: kDarkGrey,
          icon: Icon(Icons.show_chart_rounded),
          label: 'Markets'),
      BottomNavigationBarItem(
          backgroundColor: kDarkGrey,
          icon: Icon(Icons.web_rounded),
          label: 'News'),
      BottomNavigationBarItem(
          backgroundColor: kDarkGrey,
          icon: Icon(Icons.account_balance_wallet),
          label: 'Portfolio'),
    ];
    PageController _controller = PageController(
      initialPage: currentPage,
    );

    void onTapIcon(int index) => _controller.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(
              Icons.power_settings_new_outlined,
            ),
          )
        ],
        centerTitle: true,
        title: kAppName,
        elevation: 0,
      ),
      backgroundColor: kDarkGrey,
      body: PageView(
        controller: _controller,
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        children: [
          Center(
            child: Text(
              user.uid,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Center(
            child: MarketsTab(),
          ),
          Center(
            child: NewsTab(),
          ),
          Center(
            child: Text(
              'Portfolio',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        backgroundColor: kDarkGrey,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[600],
        onTap: onTapIcon,
        items: items,
      ),
    );
  }
}
