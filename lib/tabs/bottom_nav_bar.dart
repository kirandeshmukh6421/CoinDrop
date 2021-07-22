import 'package:coindrop/services/database/auth.dart';
import 'package:coindrop/tabs/nested_tabs/news_tab.dart';
import 'package:coindrop/tabs/nested_tabs/watchlist_tab.dart';

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
        actions: <Widget>[
          PopupMenuButton<String>(
            color: kMediumGrey,
            padding: EdgeInsets.all(0),
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((Map choice) {
                return PopupMenuItem<String>(
                  padding: EdgeInsets.all(0),
                  value: choice["text"],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      choice["icon"],
                      Text(
                        choice["text"],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          )
        ],
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       await _auth.signOut();
        //     },
        //     icon: Icon(
        //       Icons.power_settings_new_outlined,
        //     ),
        //   )
        // ],
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
            child: WatchlistTab(),
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

  void choiceAction(String choice) async {
    if (choice == Constants.Settings) {
      print('Settings');
    } else if (choice == Constants.SignOut) {
      await _auth.signOut();
    }
  }
}

class Constants {
  static const String Settings = 'Settings';
  static const String SignOut = 'Sign out';
  static const Icon SettingsIcon = Icon(Icons.settings);
  static const Icon SignOutIcon = Icon(Icons.logout);

  static const List<Map> choices = <Map>[
    {"text": Settings, "icon": SettingsIcon},
    {"text": SignOut, "icon": SignOutIcon},
  ];
  // static const List<Icon> icons = <Icon>[SettingsIcon, SignOutIcon];
}
